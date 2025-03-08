import '../entities/user.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String password);
  Future<User> register(
      String email, String password, String fullName, String role);
  Future<User> checkAuthStatus(String token);
  Future<User> loginWithGoogle();
  Future<User> loginWithFacebook();
  Future<User> completeRegistration(String userId, String role);
  Future<void> logout();
}
