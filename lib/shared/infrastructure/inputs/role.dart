import 'package:formz/formz.dart';

// Define input validation errors
enum RoleError { empty, invalid }

enum RoleType { organizador, arbitro, jugador }

class Role extends FormzInput<RoleType, RoleError> {
  // Call super.pure to represent an unmodified form input.
  const Role.pure() : super.pure(RoleType.jugador);

  // Call super.dirty to represent a modified form input.
  const Role.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == RoleError.empty) return 'El campo es requerido';
    if (displayError == RoleError.invalid) {
      return 'El rol seleccionado no es válido';
    }

    return null;
  }

  @override
  RoleError? validator(RoleType value) {
    if (value == RoleType.jugador) return RoleError.invalid;

    return null;
  }
}
