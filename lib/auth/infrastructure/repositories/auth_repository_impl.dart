import 'package:app_project/auth/domain/domain.dart';
import '../infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({AuthDataSource? dataSource})
      : dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(
      String email, String password, String fullName, String role) {
    return dataSource.register(email, password, fullName, role);
  }

  @override
  Future<User> loginWithFacebook() {
    return dataSource.loginWithFacebook();
  }

  @override
  Future<User> loginWithGoogle() {
    return dataSource.loginWithGoogle();
  }

  @override
  Future<User> completeRegistration(String userId, String role) {
    return dataSource.completeRegistration(userId, role);
  }

  @override
  Future<void> logout() {
    return dataSource.logout();
  }
}
