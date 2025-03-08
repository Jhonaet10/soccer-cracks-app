import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:app_project/shared/infrastructure/inputs/inputs.dart';

final tournamentCodeFormProvider = StateNotifierProvider.autoDispose<
    TournamentCodeFormNotifier, TournamentCodeFormState>((ref) {
  return TournamentCodeFormNotifier();
});

class TournamentCodeFormState {
  final Name code;
  final bool isValid;
  final bool isSubmitting;
  final String? errorMessage;

  TournamentCodeFormState({
    this.code = const Name.pure(),
    this.isValid = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  TournamentCodeFormState copyWith({
    Name? code,
    bool? isValid,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return TournamentCodeFormState(
      code: code ?? this.code,
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TournamentCodeFormNotifier
    extends StateNotifier<TournamentCodeFormState> {
  TournamentCodeFormNotifier() : super(TournamentCodeFormState());

  onCodeChanged(String value) {
    print('Código ingresado original: $value');
    // Normalizar el código eliminando espacios y guiones
    final normalizedValue = value.replaceAll(RegExp(r'[\s-]'), '');
    print('Código normalizado: $normalizedValue');

    final newCode = Name.dirty(value);
    final isValid =
        normalizedValue.length >= 4; // Validación mínima de 4 caracteres

    print('¿El código es válido? $isValid');
    state = state.copyWith(
      code: newCode,
      isValid: isValid,
      errorMessage: null,
    );
  }

  void setSubmitting(bool value) {
    print('Cambiando estado de envío a: $value');
    state = state.copyWith(isSubmitting: value);
  }

  void setErrorMessage(String message) {
    print('Error message set: $message');
    state = state.copyWith(errorMessage: message);
  }
}
