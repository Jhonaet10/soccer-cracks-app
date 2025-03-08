import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/shared/infrastructure/inputs/email.dart';
import 'package:app_project/shared/infrastructure/inputs/password.dart';
import 'package:app_project/shared/infrastructure/inputs/name.dart';
import 'package:app_project/shared/infrastructure/inputs/role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

//! 2 - Como implementamos un notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String, String) registerUserCallback;

  RegisterFormNotifier({required this.registerUserCallback})
      : super(RegisterFormState());

  onNameChange(String value) {
    final newName = Name.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid:
          Formz.validate([newName, state.email, state.password, state.role]),
    );
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid:
          Formz.validate([state.name, newEmail, state.password, state.role]),
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid:
          Formz.validate([state.name, state.email, newPassword, state.role]),
    );
  }

  togglePasswordVisibility() {
    state = state.copyWith(isPasswordObscured: !state.isPasswordObscured);
  }

  onRoleChanged(String value) {
    final newRole = Role.dirty(value == 'Organizador'
        ? RoleType.organizador
        : value == 'Jugador'
            ? RoleType.jugador
            : RoleType.arbitro);
    state = state.copyWith(
      role: newRole,
      isValid:
          Formz.validate([state.name, state.email, state.password, newRole]),
    );
  }

  onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);
    final roleName = state.role.value.name == 'organizador'
        ? 'Organizador'
        : state.role.value.name == 'arbitro'
            ? 'Árbitro'
            : 'Jugador';
    await registerUserCallback(
      state.email.value,
      state.password.value,
      state.name.value,
      roleName,
    );
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final name = Name.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      name: name,
      email: email,
      password: password,
      isValid: Formz.validate([name, email, password]),
    );
  }
}

//! 1 - State del provider
class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name;
  final Role role;
  final Email email;
  final Password password;
  final bool isPasswordObscured;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.isPasswordObscured = true,
    this.role = const Role.pure(),
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    bool? isPasswordObscured,
    Name? name,
    Email? email,
    Role? role,
    Password? password,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        name: name ?? this.name,
        email: email ?? this.email,
        isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
        password: password ?? this.password,
        role: role ?? this.role,
      );

  @override
  String toString() {
    return '''
  RegisterFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    name: $name
    email: $email
    password: $password
''';
  }
}
