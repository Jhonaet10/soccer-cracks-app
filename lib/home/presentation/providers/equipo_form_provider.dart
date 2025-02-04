import 'package:app_project/home/presentation/providers/torneo_form_provider.dart';
import 'package:app_project/shared/infrastructure/inputs/inputs.dart';
import 'package:app_project/shared/infrastructure/inputs/number.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final equipoProvider =
    StateNotifierProvider<EquipoNotifier, EquipoState>((ref) {
  final registrarEquipoCallback =
      ref.watch(torneoProvider.notifier).agregarEquipo;
  return EquipoNotifier(
    registrarEquipoCallback: registrarEquipoCallback,
  );
});

class EquipoState {
  final Name nombreEquipo;
  final Name nombreJugador;
  final Number numeroJugador;
  final List<Jugador> jugadores;
  final bool isSubmitting; // Para manejar el estado del botón
  final bool isValid; // Para manejar la validación del formulario

  EquipoState({
    this.nombreEquipo = const Name.pure(),
    this.nombreJugador = const Name.pure(),
    this.numeroJugador = const Number.pure(),
    this.jugadores = const [],
    this.isValid = false,
    this.isSubmitting = false,
  });

  EquipoState copyWith({
    Name? nombreEquipo,
    Name? nombreJugador,
    Number? numeroJugador,
    List<Jugador>? jugadores,
    bool? isSubmitting,
    bool? isValid,
  }) {
    return EquipoState(
      nombreEquipo: nombreEquipo ?? this.nombreEquipo,
      nombreJugador: nombreJugador ?? this.nombreJugador,
      numeroJugador: numeroJugador ?? this.numeroJugador,
      jugadores: jugadores ?? this.jugadores,
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class Jugador {
  final String nombre;
  final int numero;

  Jugador({required this.nombre, required this.numero});
}

class EquipoNotifier extends StateNotifier<EquipoState> {
  final Function(String, List<Jugador>) registrarEquipoCallback;
  EquipoNotifier({
    required this.registrarEquipoCallback,
  }) : super(EquipoState());

  onNombreJugadorChange(String value) {
    final newNombre = Name.dirty(value);
    state = state.copyWith(
      nombreJugador: newNombre,
    );
  }

  onNumeroJugadorChange(String value) {
    final newNumero = Number.dirty(value);
    state = state.copyWith(
      numeroJugador: newNumero,
    );
  }

  onNombreEquipoChange(String value) {
    final newNombre = Name.dirty(value);
    state = state.copyWith(
      nombreEquipo: newNombre,
      isValid: Formz.validate([newNombre]),
    );
  }

  agregarJugador() {
    if (!state.nombreJugador.isValid || !state.numeroJugador.isValid) return;

    final nuevoJugador = Jugador(
      nombre: state.nombreJugador.value,
      numero: int.parse(state.numeroJugador.value),
    );

    state = state.copyWith(
      jugadores: List<Jugador>.from(state.jugadores)..add(nuevoJugador),
      nombreJugador: const Name.pure(),
      numeroJugador: const Number.pure(),
      isValid: false,
    );
  }

  eliminarJugador(Jugador jugador) {
    state = state.copyWith(
      jugadores: List<Jugador>.from(state.jugadores)..remove(jugador),
    );
  }

  Future<void> registrarEquipo() async {
    state = state.copyWith(isSubmitting: true);

    try {
      registrarEquipoCallback(state.nombreEquipo.value, state.jugadores);
      state = EquipoState();
    } catch (e) {
      throw Exception("Error al registrar el equipo: $e");
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
