import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/shared/infrastructure/inputs/email.dart';
import 'package:app_project/shared/infrastructure/inputs/password.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  final loginWithGoogleCallback =
      ref.watch(authProvider.notifier).loginWithGoogle;
  final loginWithFacebookCallback =
      ref.watch(authProvider.notifier).loginWithFacebook;

  return LoginFormNotifier(
      loginUserCallback: loginUserCallback,
      loginWithGoogleCallback: loginWithGoogleCallback,
      loginWithFacebookCallback: loginWithFacebookCallback);
});

//! 2 - Como implementamos un notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallback;
  final Function() loginWithGoogleCallback;
  final Function() loginWithFacebookCallback;

  LoginFormNotifier({
    required this.loginUserCallback,
    required this.loginWithGoogleCallback,
    required this.loginWithFacebookCallback,
  }) : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  togglePasswordVisibility() {
    state = state.copyWith(isPasswordObscured: !state.isPasswordObscured);
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email]));
  }

  onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    try {
      await loginUserCallback(state.email.value, state.password.value);
    } finally {
      state = state.copyWith(isPosting: false);
    }
  }

  onSignInWithGoogle() async {
    state = state.copyWith(isPosting: true);

    try {
      await loginWithGoogleCallback();
    } finally {
      state = state.copyWith(isPosting: false);
    }
  }

  onSignInWithFacebook() async {
    state = state.copyWith(isPosting: true);

    try {
      await loginWithFacebookCallback();
    } finally {
      state = state.copyWith(isPosting: false);
    }
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password]));
  }
}

//! 1 - State del provider
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final bool isPasswordObscured;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.isPasswordObscured = true,
      this.password = const Password.pure()});

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    bool? isPasswordObscured,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return '''
  LoginFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    email: $email
    password: $password
''';
  }
}
