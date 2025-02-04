import 'package:app_project/auth/domain/domain.dart';
import 'package:app_project/auth/infrastructure/errors/auth_errors.dart';
import 'package:app_project/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({
    required this.authRepository,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
      print('User: $user');
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }

    // final user = await authRepository.login(email, password);
    // state =state.copyWith(user: user, authStatus: AuthStatus.authenticated)
  }

  Future<void> loginWithGoogle() async {
    state = state.copyWith(authStatus: AuthStatus.checking);
    try {
      print('Login with Google');
      final user = await authRepository.loginWithGoogle();
      _setLoggedUser(user);
      print('Login exitoso');
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      print(e.toString());
      logout('Error no controlado');
    }
  }

  Future<void> loginWithFacebook() async {
    state = state.copyWith(authStatus: AuthStatus.checking);
    try {
      final user = await authRepository.loginWithFacebook();
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }
  }

  void registerUser(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.register(email, password, name);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }
  }

  void checkAuthStatus() async {
    state = state.copyWith(authStatus: AuthStatus.checking);
    try {
      final user = await authRepository.checkAuthStatus('token');
      _setLoggedUser(user);
      print(state.authStatus);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }
  }

  void _setLoggedUser(User user) {
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> logout([String? errorMessage]) async {
    // TODO: limpiar token
    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}
