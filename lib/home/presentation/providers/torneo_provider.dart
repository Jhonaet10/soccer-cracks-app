import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/home/domain/entities/toneoRegister.dart';
import 'package:app_project/home/domain/entities/torneo.dart';
import 'package:app_project/home/domain/repositories/torneo_repository.dart';
import 'package:app_project/home/infrastructure/repositories/torneo_repository_impl.dart';
import 'package:app_project/shared/infrastructure/errors/custom_error.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_project/auth/domain/entities/role.dart';
import 'package:app_project/home/presentation/providers/partido_provider.dart';
import 'package:app_project/home/presentation/providers/tabla_posicion_provider.dart';

// Proveedor del repositorio de torneos
final torneoRepositoryProvider = Provider<TorneoRepository>((ref) {
  return TorneoRepositoryImpl();
});

// Proveedor de estado para manejar la lógica de torneos con el usuario autenticado
final torneoProvider =
    StateNotifierProvider<TorneoNotifier, TorneoState>((ref) {
  final torneoRepository = ref.watch(torneoRepositoryProvider);
  final authState = ref.watch(authProvider);
  final authNotifier = ref.watch(authProvider.notifier);
  return TorneoNotifier(torneoRepository, authState, ref, authNotifier);
});

// Estado del provider
class TorneoState {
  final bool isLoading;
  final List<Torneo> torneos;
  final Torneo? selectedTorneo;
  final String successMessage;
  final String errorMessage;

  TorneoState({
    this.isLoading = false,
    this.torneos = const [],
    this.selectedTorneo,
    this.successMessage = '',
    this.errorMessage = '',
  });

  TorneoState copyWith({
    bool? isLoading,
    List<Torneo>? torneos,
    Torneo? selectedTorneo,
    String? successMessage,
    String? errorMessage,
  }) {
    return TorneoState(
      isLoading: isLoading ?? this.isLoading,
      torneos: torneos ?? this.torneos,
      selectedTorneo: selectedTorneo ?? this.selectedTorneo,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Notifier que maneja la lógica de torneos
class TorneoNotifier extends StateNotifier<TorneoState> {
  final TorneoRepository torneoRepository;
  final AuthState authState;
  final AuthNotifier authNotifier;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Ref ref;

  TorneoNotifier(
    this.torneoRepository,
    this.authState,
    this.ref,
    this.authNotifier,
  ) : super(TorneoState()) {
    print(
        'TorneoNotifier inicializado. Estado de autenticación: ${authState.authStatus}');
    if (authState.authStatus == AuthStatus.authenticated) {
      loadTorneo();
    }
  }

  Future<void> loadTorneo() async {
    try {
      print('Iniciando carga de torneo...');
      state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      );

      if (authState.user == null) {
        print('No hay usuario autenticado');
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Usuario no autenticado',
        );
        return;
      }

      print(
          'Cargando torneo para el usuario: ${authState.user!.id} con rol: ${authState.user!.rol}');

      if (authState.user!.rol == UserRole.organizer) {
        print('Cargando torneo para organizador');
        await getTorneoByOrganizador(authState.user!.id);
      } else if (authState.user!.hasTournaments) {
        print('Cargando torneo para usuario con torneos');
        await getTorneoByUser();
      } else {
        print('Usuario sin torneos asociados');
        state = state.copyWith(
          isLoading: false,
          selectedTorneo: null,
        );
      }
    } catch (e) {
      print('Error al cargar el torneo: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar el torneo: ${e.toString()}',
      );
    }
  }

  Future<void> getTorneoByOrganizador(String organizadorId) async {
    try {
      print('Buscando torneo para organizador: $organizadorId');
      final torneo =
          await torneoRepository.getTorneoByOrganizadorId(organizadorId);

      if (torneo != null) {
        print('Torneo encontrado: ${torneo.nombre}');
        state = state.copyWith(
          selectedTorneo: torneo,
          isLoading: false,
          // Solo mostramos mensaje de éxito cuando realmente se encuentra un torneo
          successMessage: 'Torneo cargado exitosamente',
        );

        // Cargar los partidos después de obtener el torneo
        ref.read(partidosProvider.notifier).cargarPartidos(torneo.id);
      } else {
        print('No se encontró torneo para el organizador');
        state = state.copyWith(
          isLoading: false,
          // No enviamos mensaje de error, solo actualizamos el estado
        );
      }
    } catch (e) {
      print('Error al cargar el torneo: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar el torneo: ${e.toString()}',
      );
    }
  }

  void clearErrorMessage() {
    state = state.copyWith(errorMessage: '');
  }

  void clearSuccessMessage() {
    state = state.copyWith(successMessage: '');
  }

  // Crear un torneo asegurando que tenga el ID del organizador
  Future<void> createTorneo(RegisterTorneo registerTorneo) async {
    try {
      state =
          state.copyWith(isLoading: true, errorMessage: '', successMessage: '');

      final currentUserId = authState.user?.id;

      if (currentUserId == null) {
        throw CustomError('El usuario no está autenticado',
            code: 'unauthenticated');
      }

      // Crear el torneo con el usuario autenticado como organizador
      final torneoConOrganizador = registerTorneo.copyWith(
        organizadorId: currentUserId,
      );

      await torneoRepository.createTorneo(torneoConOrganizador);

      // Recargar el torneo inmediatamente después de crearlo
      await loadTorneo();

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Torneo creado exitosamente',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is CustomError
            ? e.message
            : 'Error al crear el torneo: ${e.toString()}',
      );
      if (e is CustomError) {
        throw e;
      }
      throw CustomError('Error al crear el torneo: ${e.toString()}');
    }
  }

  // Obtener un torneo por ID
  Future<void> getTorneo(String id) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
        selectedTorneo: null,
      );

      final torneo = await torneoRepository.getTorneo(id);

      if (torneo != null) {
        state = state.copyWith(
          selectedTorneo: torneo,
          isLoading: false,
          successMessage: 'Torneo cargado exitosamente',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No se encontró el torneo',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar el torneo: ${e.toString()}',
      );
    }
  }

  // Obtener todos los torneos
  Future<List<Torneo>> getTorneos() async {
    try {
      return await torneoRepository.getTorneos();
    } catch (e) {
      throw Exception("Error al obtener la lista de torneos: $e");
    }
  }

  // Actualizar un torneo
  Future<void> updateTorneo(RegisterTorneo registerTorneo, String id) async {
    try {
      await torneoRepository.updateTorneo(registerTorneo, id);
    } catch (e) {
      throw Exception("Error al actualizar el torneo: $e");
    }
  }

  // Eliminar un torneo
  Future<void> deleteTorneo(String id) async {
    try {
      await torneoRepository.deleteTorneo(id);
    } catch (e) {
      throw Exception("Error al eliminar el torneo: $e");
    }
  }

  Future<void> getTorneoByUser() async {
    try {
      print('Iniciando getTorneoByUser...');

      final userTorneos = authState.user?.torneos;
      print('Torneos del usuario: $userTorneos');

      if (userTorneos == null || userTorneos.isEmpty) {
        print('Usuario sin torneos asociados');
        state = state.copyWith(
          isLoading: false,
          selectedTorneo: null,
        );
        return;
      }

      print('Obteniendo torneo con ID: ${userTorneos[0]}');
      final torneo = await torneoRepository.getTorneo(userTorneos[0]);

      if (torneo != null) {
        print('Torneo encontrado: ${torneo.nombre}');
        state = state.copyWith(
          selectedTorneo: torneo,
          isLoading: false,
          successMessage: 'Torneo cargado exitosamente',
        );

        // Cargar los partidos después de obtener el torneo
        print('Cargando partidos del torneo');
        await ref.read(partidosProvider.notifier).cargarPartidos(torneo.id);

        // Si el torneo está en curso, cargar también la tabla de posiciones
        if (torneo.estado == "En curso") {
          print('Torneo en curso, cargando tabla de posiciones');
          await ref
              .read(tablaPosicionesProvider.notifier)
              .cargarTabla(torneo.id);
        }
      } else {
        print('No se encontró el torneo');
        state = state.copyWith(
          isLoading: false,
          selectedTorneo: null,
        );
      }
    } catch (e) {
      print('Error en getTorneoByUser: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar el torneo: ${e.toString()}',
      );
    }
  }

  Future<void> iniciarCampeonato() async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      );

      final torneo = state.selectedTorneo;
      if (torneo == null) {
        throw CustomError('No hay torneo registrado', code: 'no-tournament');
      }

      await torneoRepository.iniciarCampeonato(
        torneo.id,
        torneo.equipos.map((e) => e.id).toList(),
      );

      // Recargar toda la información del torneo
      print('Actualizando información del torneo después de iniciarlo...');

      if (authState.user!.rol == UserRole.organizer) {
        await getTorneoByOrganizador(authState.user!.id);
      } else {
        await getTorneoByUser();
      }

      // Cargar los partidos
      ref.read(partidosProvider.notifier).cargarPartidos(torneo.id);

      // Cargar la tabla de posiciones
      ref.read(tablaPosicionesProvider.notifier).cargarTabla(torneo.id);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Campeonato iniciado exitosamente',
      );
    } catch (e) {
      print('Error al iniciar el campeonato: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is CustomError
            ? e.message
            : 'Error al iniciar el campeonato: ${e.toString()}',
      );
      if (e is CustomError) {
        throw e;
      }
      throw CustomError('Error al iniciar el campeonato: ${e.toString()}');
    }
  }

  Future<void> joinTournament(String code, String role) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: '',
        successMessage: '',
      );

      // Validar entrada
      if (code.isEmpty) {
        throw CustomError('El código de acceso no puede estar vacío',
            code: 'invalid-input');
      }

      final currentUserId = authState.user?.id;
      if (currentUserId == null) {
        throw CustomError('Usuario no autenticado', code: 'unauthenticated');
      }

      // Buscar el torneo por código
      final torneo = await torneoRepository.getTorneoByCode(code, role);
      if (torneo == null) {
        throw CustomError('Código de acceso inválido', code: 'invalid-code');
      }

      // Asignar el torneo al usuario
      await torneoRepository.assignTournamentToUser(currentUserId, torneo.id);

      // Recargar el torneo inmediatamente
      await getTorneoByUser();

      // Actualizar el estado del usuario
      await ref.read(authProvider.notifier).checkAuthStatus();

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Te has unido al torneo exitosamente',
      );
    } catch (e) {
      String errorMessage = 'Error desconocido';

      if (e is CustomError) {
        errorMessage = e.message;
      } else {
        print('Error no manejado: $e');
        errorMessage = 'Ha ocurrido un error inesperado';
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );
    }
  }
}
