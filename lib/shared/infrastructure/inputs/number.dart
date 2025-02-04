import 'package:formz/formz.dart';

enum NumberError { empty, invalid }

class Number extends FormzInput<String, NumberError> {
  const Number.pure() : super.pure('');
  const Number.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == NumberError.empty) return 'El campo es requerido';
    if (displayError == NumberError.invalid) {
      return 'El campo debe ser un número';
    }

    return null;
  }

  @override
  NumberError? validator(String value) {
    if (value.isEmpty) return NumberError.empty;
    if (int.tryParse(value) == null) return NumberError.invalid;
    return null;
  }
}
