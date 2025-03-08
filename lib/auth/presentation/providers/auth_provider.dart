import 'package:app_project/auth/domain/domain.dart';
import 'package:app_project/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:app_project/shared/infrastructure/errors/custom_error.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider para controlar el estado de la inicialización
final authStatusProvider =
    StateProvider<AuthStatus>((ref) => AuthStatus.checking);

// Provider para el usuario actual
final currentUserProvider = StateProvider<User?>((ref) => null);

// Provider principal de autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final notifier = AuthNotifier(
    authRepository: authRepository,
    ref: ref,
  );
  // Verificar autenticación al inicializar el provider
  notifier.checkAuthStatus();
  return notifier;
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final Ref ref;

  AuthNotifier({
    required this.authRepository,
    required this.ref,
  }) : super(AuthState(authStatus: AuthStatus.checking));

  Future<void> checkAuthStatus() async {
    print('Verificando estado de autenticación...');
    try {
      final user = await authRepository.checkAuthStatus('token');
      if (user == null || user.rol == null) {
        print('No hay usuario autenticado o falta rol');
        state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          user: null,
        );
        return;
      }

      print('Usuario autenticado: ${user.email}');
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
        user: user,
      );
    } catch (e) {
      print('Error al verificar autenticación: $e');
      state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loginUser(String email, String password) async {
    state = state.copyWith(
      authStatus: AuthStatus.checking,
      errorMessage: '', // Limpiamos cualquier error previo
    );

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        errorMessage: 'Error no controlado',
      );
    }
  }

  Future<void> loginWithGoogle() async {
    state = state.copyWith(
      authStatus: AuthStatus.checking,
      errorMessage: '', // Limpiamos cualquier error previo
    );

    try {
      final user = await authRepository.loginWithGoogle();
      print('Usuario obtenido de Google: ${user.toString()}');

      if (user.rol == null) {
        print('Usuario nuevo detectado, necesita completar perfil');
        state = state.copyWith(
          user: user,
          authStatus: AuthStatus.needsProfileCompletion,
          errorMessage: '',
        );
      } else {
        print('Usuario existente, estableciendo sesión');
        _setLoggedUser(user);
      }
    } on CustomError catch (e) {
      print('Error en login con Google: ${e.message}');
      state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        errorMessage: e.message,
      );
    } catch (e) {
      print('Error no controlado en login con Google: $e');
      state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        errorMessage: 'Error no controlado',
      );
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

  void registerUser(
      String email, String password, String name, String role) async {
    state = state.copyWith(
      authStatus: AuthStatus.checking,
      errorMessage: '', // Limpiamos cualquier error previo
    );

    try {
      final user = await authRepository.register(email, password, name, role);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        errorMessage: 'Error no controlado',
      );
    }
  }

  void _setLoggedUser(User user) {
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
    ref.read(currentUserProvider.notifier).state = user;
  }

  Future<void> logout([String? errorMessage]) async {
    try {
      await authRepository.logout();
    } catch (e) {
      print('Error durante el logout: ${e.toString()}');
    }

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage ?? '',
    );
  }

  Future<void> completeRegistration(String role) async {
    if (state.user == null) {
      throw Exception('No hay usuario para completar el registro');
    }

    state = state.copyWith(authStatus: AuthStatus.checking);

    try {
      final updatedUser = await authRepository.completeRegistration(
        state.user!.id,
        role,
      );

      _setLoggedUser(updatedUser);
    } catch (e) {
      logout('Error al completar el registro: ${e.toString()}');
      throw Exception('Error al completar el registro: ${e.toString()}');
    }
  }
}

enum AuthStatus {
  checking,
  authenticated,
  notAuthenticated,
  needsProfileCompletion
}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
