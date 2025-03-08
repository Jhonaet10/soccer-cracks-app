import 'package:app_project/auth/domain/entities/user.dart';
import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goRouterNotifierProvider = Provider((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return GoRouterNotifier(authNotifier);
});

class GoRouterNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;

  AuthStatus _authStatus = AuthStatus.checking;

  GoRouterNotifier(this._authNotifier) {
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;
    });
  }

  AuthStatus get authStatus => _authStatus;
  User? get currentUser => _authNotifier.state.user;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }
}
