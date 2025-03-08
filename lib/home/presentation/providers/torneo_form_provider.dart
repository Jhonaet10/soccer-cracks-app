import 'dart:math';
import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/home/domain/entities/toneoRegister.dart';
import 'package:app_project/home/domain/repositories/torneo_repository.dart';
import 'package:app_project/home/infrastructure/repositories/torneo_repository_impl.dart';
import 'package:app_project/home/presentation/providers/equipo_form_provider.dart';
import 'package:app_project/shared/infrastructure/inputs/inputs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:app_project/home/presentation/providers/torneo_provider.dart';

final torneoRepositoryProvider = Provider<TorneoRepository>((ref) {
  return TorneoRepositoryImpl();
});

final torneoFormProvider =
    StateNotifierProvider<TorneoFormNotifier, TorneoFormState>((ref) {
  final torneoRepository = ref.watch(torneoRepositoryProvider);
  final authState = ref.watch(authProvider);
  return TorneoFormNotifier(
    torneoRepository: torneoRepository,
    authState: authState,
    ref: ref,
  );
});

class TorneoFormState {
  final Name nombreTorneo;
  final Formato? formato; // Liga o Grupos
  final DateTime? fechaInicio;
  final List<Equipo> equipos;
  final bool isSubmitting;
  final Name formatoJuego;
  final Name duracionJuego;
  final bool isValid;
  final bool isFormPosted;
  final String successMessage;
  final String errorMessage;

  TorneoFormState({
    this.nombreTorneo = const Name.pure(),
    this.formato,
    this.fechaInicio,
    this.equipos = const [],
    this.formatoJuego = const Name.pure(),
    this.duracionJuego = const Name.pure(),
    this.isSubmitting = false,
    this.isValid = false,
    this.isFormPosted = false,
    this.successMessage = '',
    this.errorMessage = '',
  });

  TorneoFormState copyWith({
    Name? nombreTorneo,
    Formato? formato,
    DateTime? fechaInicio,
    List<Equipo>? equipos,
    Name? formatoJuego,
    Name? duracionJuego,
    bool? isSubmitting,
    bool? isValid,
    bool? isFormPosted,
    String? successMessage,
    String? errorMessage,
  }) {
    return TorneoFormState(
      nombreTorneo: nombreTorneo ?? this.nombreTorneo,
      formato: formato ?? this.formato,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      equipos: equipos ?? this.equipos,
      formatoJuego: formatoJuego ?? this.formatoJuego,
      duracionJuego: duracionJuego ?? this.duracionJuego,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValid: isValid ?? this.isValid,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class Equipo {
  final String nombre;
  final List<Jugador> jugadores;

  Equipo({required this.nombre, required this.jugadores});
}

class Formato {
  final String tipoJuego; // 'Liga' o 'Grupos'
  final String duracion; // '90 min', '60 min', '40 min'

  Formato({required this.tipoJuego, required this.duracion});

  @override
  String toString() {
    return '$tipoJuego - $duracion';
  }
}

class TorneoFormNotifier extends StateNotifier<TorneoFormState> {
  final TorneoRepository torneoRepository;
  final AuthState authState;
  final Ref ref;
  final _random = Random();

  TorneoFormNotifier({
    required this.authState,
    required this.torneoRepository,
    required this.ref,
  }) : super(TorneoFormState());

  String _generarCodigoAcceso() {
    const letras = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String codigo = '';

    // Generar 3 letras aleatorias
    for (int i = 0; i < 3; i++) {
      codigo += letras[_random.nextInt(letras.length)];
    }

    // Generar 3 números aleatorios
    for (int i = 0; i < 3; i++) {
      codigo += _random.nextInt(10).toString();
    }

    return codigo;
  }

  void clearErrorMessage() {
    state = state.copyWith(errorMessage: '');
  }

  void clearSuccessMessage() {
    state = state.copyWith(successMessage: '');
  }

  onNombreTorneoChange(String value) {
    final newNombre = Name.dirty(value);
    state = state.copyWith(
      nombreTorneo: newNombre,
      isValid: Formz.validate([
        newNombre,
      ]),
    );
  }

  setFormatoJuego(String value) {
    print('Formato de juego: $value');
    final newFormato = Name.dirty(value);
    state = state.copyWith(formatoJuego: newFormato);
    print(state.duracionJuego.value);
  }

  setDuracionJuego(String value) {
    final newDuracion = Name.dirty(value);
    state = state.copyWith(duracionJuego: newDuracion);
    print(state.formatoJuego.value);
  }

  onFormatoChange(String formatoJuego, String duracionJuego) {
    final formato = Formato(tipoJuego: formatoJuego, duracion: duracionJuego);
    state = state.copyWith(formato: formato);
  }

  onFechaInicioChange(DateTime fecha) {
    state = state.copyWith(fechaInicio: fecha);
  }

  void agregarEquipo(String nombreEquipo, List<Jugador> jugadores) {
    final equipo = Equipo(nombre: nombreEquipo, jugadores: jugadores);
    state = state.copyWith(
      equipos: List<Equipo>.from(state.equipos)..add(equipo),
    );
  }

  Future<void> registrarTorneo() async {
    state = state.copyWith(
      isSubmitting: true,
      errorMessage: '',
      successMessage: '',
    );

    try {
      final currentUserId = authState.user?.id;
      RegisterTorneo torneo = RegisterTorneo(
        nombre: state.nombreTorneo.value,
        formato: state.formatoJuego.value,
        fechaInicio: state.fechaInicio!,
        equipos: state.equipos,
        organizadorId: currentUserId ?? '',
        codigoAccesoJugador: _generarCodigoAcceso(),
        codigoAccesoArbitro: _generarCodigoAcceso(),
      );

      // Asegurarse de que los códigos sean diferentes
      while (torneo.codigoAccesoJugador == torneo.codigoAccesoArbitro) {
        torneo = torneo.copyWith(codigoAccesoArbitro: _generarCodigoAcceso());
      }

      await torneoRepository.createTorneo(torneo);

      // Recargar el torneo usando el TorneoProvider
      await ref.read(torneoProvider.notifier).loadTorneo();

      state = state.copyWith(
        isSubmitting: false,
        successMessage: 'Torneo creado exitosamente',
      );

      // Reiniciar el formulario
      state = TorneoFormState();
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Error al registrar el torneo: ${e.toString()}',
      );
      throw Exception("Error al registrar el torneo: $e");
    }
  }
}
