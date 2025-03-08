import 'package:app_project/home/presentation/providers/torneo_form_provider.dart';
import 'package:app_project/shared/infrastructure/inputs/inputs.dart';
import 'package:app_project/shared/infrastructure/inputs/number.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final equipoProvider =
    StateNotifierProvider<EquipoNotifier, EquipoState>((ref) {
  final registrarEquipoCallback =
      ref.watch(torneoFormProvider.notifier).agregarEquipo;
  return EquipoNotifier(
    registrarEquipoCallback: registrarEquipoCallback,
  );
});

class EquipoState {
  final Name nombreEquipo;
  final Name nombreJugador;
  final Number numeroJugador;
  final List<Jugador> jugadores;
  final bool isSubmitting;
  final bool isValid;
  final String successMessage;
  final String errorMessage;

  EquipoState({
    this.nombreEquipo = const Name.pure(),
    this.nombreJugador = const Name.pure(),
    this.numeroJugador = const Number.pure(),
    this.jugadores = const [],
    this.isValid = false,
    this.isSubmitting = false,
    this.successMessage = '',
    this.errorMessage = '',
  });

  EquipoState copyWith({
    Name? nombreEquipo,
    Name? nombreJugador,
    Number? numeroJugador,
    List<Jugador>? jugadores,
    bool? isSubmitting,
    bool? isValid,
    String? successMessage,
    String? errorMessage,
  }) {
    return EquipoState(
      nombreEquipo: nombreEquipo ?? this.nombreEquipo,
      nombreJugador: nombreJugador ?? this.nombreJugador,
      numeroJugador: numeroJugador ?? this.numeroJugador,
      jugadores: jugadores ?? this.jugadores,
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class Jugador {
  final String nombre;
  final int numero;

  Jugador({required this.nombre, required this.numero});
}

typedef RegistrarEquipoCallback = void Function(
    String nombre, List<Jugador> jugadores);

class EquipoNotifier extends StateNotifier<EquipoState> {
  final RegistrarEquipoCallback registrarEquipoCallback;

  EquipoNotifier({
    required this.registrarEquipoCallback,
  }) : super(EquipoState());

  void clearErrorMessage() {
    state = state.copyWith(errorMessage: '');
  }

  void clearSuccessMessage() {
    state = state.copyWith(successMessage: '');
  }

  onNombreEquipoChange(String value) {
    final newNombre = Name.dirty(value);
    state = state.copyWith(
      nombreEquipo: newNombre,
      isValid: Formz.validate([newNombre]),
      errorMessage: '',
    );
  }

  onNombreJugadorChange(String value) {
    final newNombre = Name.dirty(value);
    state = state.copyWith(
      nombreJugador: newNombre,
      isValid: Formz.validate([
        newNombre,
        state.numeroJugador,
      ]),
      errorMessage: '',
    );
  }

  onNumeroJugadorChange(String value) {
    final newNumero = Number.dirty(value);
    state = state.copyWith(
      numeroJugador: newNumero,
      isValid: Formz.validate([
        state.nombreJugador,
        newNumero,
      ]),
      errorMessage: '',
    );
  }

  void agregarJugador() {
    if (!state.isValid) return;

    final jugador = Jugador(
      nombre: state.nombreJugador.value,
      numero: int.parse(state.numeroJugador.value),
    );

    state = state.copyWith(
      jugadores: [...state.jugadores, jugador],
      nombreJugador: const Name.pure(),
      numeroJugador: const Number.pure(),
      isValid: false,
    );
  }

  void registrarEquipo() {
    if (state.nombreEquipo.value.isEmpty) {
      state = state.copyWith(
        errorMessage: 'El nombre del equipo es requerido',
      );
      return;
    }

    if (state.jugadores.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Debe agregar al menos un jugador',
      );
      return;
    }

    try {
      state = state.copyWith(
        isSubmitting: true,
        errorMessage: '',
        successMessage: '',
      );

      registrarEquipoCallback(state.nombreEquipo.value, state.jugadores);

      state = state.copyWith(
        isSubmitting: false,
        successMessage: 'Equipo registrado exitosamente',
      );

      // Reiniciar el estado
      state = EquipoState();
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Error al registrar el equipo: ${e.toString()}',
      );
    }
  }
}
