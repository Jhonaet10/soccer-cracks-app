import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/home/domain/entities/toneoRegister.dart';
import 'package:app_project/home/domain/entities/torneo.dart';
import 'package:app_project/home/domain/repositories/torneo_repository.dart';
import 'package:app_project/home/infrastructure/repositories/torneo_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Proveedor del repositorio de torneos
final torneoRepositoryProvider = Provider<TorneoRepository>((ref) {
  return TorneoRepositoryImpl();
});

// Proveedor de estado para manejar la lógica de torneos con el usuario autenticado
final torneoProvider =
    StateNotifierProvider<TorneoNotifier, TorneoState>((ref) {
  final torneoRepository = ref.watch(torneoRepositoryProvider);
  final authState = ref.watch(authProvider); // Obtener el usuario autenticado
  return TorneoNotifier(torneoRepository, authState);
});

// Notifier que maneja la lógica de torneos
class TorneoNotifier extends StateNotifier<TorneoState> {
  final TorneoRepository torneoRepository;
  final AuthState authState;

  TorneoNotifier(this.torneoRepository, this.authState) : super(TorneoState());

  // Crear un torneo asegurando que tenga el ID del organizador
  Future<void> createTorneo(RegisterTorneo registerTorneo) async {
    try {
      final currentUserId = authState.user?.id;

      if (currentUserId == null) {
        throw Exception("El usuario no está autenticado");
      }

      // Crear el torneo con el usuario autenticado como organizador
      final torneoConOrganizador = registerTorneo.copyWith(
        organizadorId: currentUserId,
      );

      await torneoRepository.createTorneo(torneoConOrganizador);
    } catch (e) {
      throw Exception("Error al crear el torneo: $e");
    }
  }

  // Obtener un torneo por ID
  Future<Torneo?> getTorneo(String id) async {
    try {
      return await torneoRepository.getTorneo(id);
    } catch (e) {
      throw Exception("Error al obtener el torneo: $e");
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
      final currentUserId = authState.user?.id;

      if (currentUserId == null) {
        throw Exception("Usuario no autenticado");
      }

      final torneo =
          await torneoRepository.getTorneoByOrganizadorId(currentUserId);

      if (torneo != null) {
        state = state.copyWith(
            selectedTorneo: torneo); // 🔹 Aquí se actualiza el estado
      }
    } catch (e) {
      throw Exception("Error al obtener el torneo del usuario: $e");
    }
  }

  Future<void> iniciarCampeonato() async {
    try {
      final torneo = state.selectedTorneo;
      if (torneo == null) throw Exception("No hay torneo registrado.");

      await torneoRepository.iniciarCampeonato(
        torneo.id,
        torneo.equipos.map((e) => e.id).toList(),
      );
      print("Campeonato iniciado.");
      await getTorneoByUser();
    } catch (e) {
      throw Exception("Error al iniciar el campeonato: $e");
    }
  }
}

// Estado del provider (opcional, útil si se quiere manejar estados como carga)
class TorneoState {
  final bool isLoading;
  final List<Torneo> torneos;
  final Torneo? selectedTorneo;

  TorneoState({
    this.isLoading = false,
    this.torneos = const [],
    this.selectedTorneo,
  });

  TorneoState copyWith({
    bool? isLoading,
    List<Torneo>? torneos,
    Torneo? selectedTorneo,
  }) {
    return TorneoState(
      isLoading: isLoading ?? this.isLoading,
      torneos: torneos ?? this.torneos,
      selectedTorneo: selectedTorneo ?? this.selectedTorneo,
    );
  }
}
