import 'package:formz/formz.dart';

// Define input validation errors
enum NameError { empty }

class Name extends FormzInput<String, NameError> {
  // Call super.pure to represent an unmodified form input.
  const Name.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Name.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == NameError.empty) return 'El campo es requerido';

    return null;
  }

  @override
  NameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return NameError.empty;

    return null;
  }
}
