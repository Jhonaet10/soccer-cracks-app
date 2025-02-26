import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/home/domain/entities/toneoRegister.dart';
import 'package:app_project/home/domain/repositories/torneo_repository.dart';
import 'package:app_project/home/infrastructure/repositories/torneo_repository_impl.dart';
import 'package:app_project/home/presentation/providers/equipo_form_provider.dart';
import 'package:app_project/shared/infrastructure/inputs/inputs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final torneoRepositoryProvider = Provider<TorneoRepository>((ref) {
  return TorneoRepositoryImpl();
});

final torneoProvider =
    StateNotifierProvider<TorneoNotifier, TorneoState>((ref) {
  final torneoRepository = ref.watch(torneoRepositoryProvider);
  final authState = ref.watch(authProvider);
  return TorneoNotifier(
      torneoRepository: torneoRepository, authState: authState);
});

class TorneoState {
  final Name nombreTorneo;
  final Formato? formato; // Liga o Grupos
  final DateTime? fechaInicio;
  final List<Equipo> equipos;
  final bool isSubmitting;
  final Name formatoJuego;
  final Name duracionJuego;
  final bool isValid;
  final bool isFormPosted;

  TorneoState({
    this.nombreTorneo = const Name.pure(),
    this.formato,
    this.fechaInicio,
    this.equipos = const [],
    this.formatoJuego = const Name.pure(),
    this.duracionJuego = const Name.pure(),
    this.isSubmitting = false,
    this.isValid = false,
    this.isFormPosted = false,
  });

  TorneoState copyWith({
    Name? nombreTorneo,
    Formato? formato,
    DateTime? fechaInicio,
    List<Equipo>? equipos,
    Name? formatoJuego,
    Name? duracionJuego,
    bool? isSubmitting,
    bool? isValid,
    bool? isFormPosted,
  }) {
    return TorneoState(
      nombreTorneo: nombreTorneo ?? this.nombreTorneo,
      formato: formato ?? this.formato,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      equipos: equipos ?? this.equipos,
      formatoJuego: formatoJuego ?? this.formatoJuego,
      duracionJuego: duracionJuego ?? this.duracionJuego,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValid: isValid ?? this.isValid,
      isFormPosted: isFormPosted ?? this.isFormPosted,
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

class TorneoNotifier extends StateNotifier<TorneoState> {
  final TorneoRepository torneoRepository;
  final AuthState authState;
  TorneoNotifier({
    required this.authState,
    required this.torneoRepository,
  }) : super(TorneoState()) {}

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
    state = state.copyWith(isSubmitting: true);

    try {
      // Simula una llamada al backend
      print("Registrando torneo...");
      final currentUserId = authState.user?.id;
      RegisterTorneo torneo = RegisterTorneo(
        nombre: state.nombreTorneo.value,
        formato: state.formatoJuego.value,
        fechaInicio: state.fechaInicio!,
        equipos: state.equipos,
        organizadorId: currentUserId ?? '', // Asigna el id del usuario actual
        codigoAccesoJugador: '1234',
        codigoAccesoArbitro: '2345',
      );
      await torneoRepository.createTorneo(torneo);

      // Reinicia el estado después de registrar
      state = TorneoState();
    } catch (e) {
      throw Exception("Error al registrar el torneo: $e");
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
