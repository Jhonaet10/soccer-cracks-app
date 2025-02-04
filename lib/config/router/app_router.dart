import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/auth/presentation/screens/check_auth_status_screen.dart';
import 'package:app_project/auth/presentation/screens/forgot_password_screen.dart';
import 'package:app_project/auth/presentation/screens/login_screen.dart';
import 'package:app_project/auth/presentation/screens/register_screen.dart';
import 'package:app_project/home/presentation/screens/create_championship_screen.dart';
import 'package:app_project/home/presentation/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      // Define the home route
      GoRoute(
          path: '/splash',
          builder: (context, state) => const CheckAuthStatusScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen()),
      GoRoute(
          path: '/forget-password',
          builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
          path: '/create-championship',
          builder: (context, state) => const CreateChampionshipScreen())
    ],
    redirect: (context, state) {
      final isGoingTo = state.uri.toString();

      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      print("Authenticacion status: $authStatus");
      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;

        return '/login';
      }
      if (authStatus == AuthStatus.authenticated) {
        print('isGoingTo: $isGoingTo');
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/';
        }
      }

      return null;
    },
  );
});
