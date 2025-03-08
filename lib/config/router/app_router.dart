import 'package:app_project/auth/domain/entities/role.dart';
import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/auth/presentation/screens/check_auth_status_screen.dart';
import 'package:app_project/auth/presentation/screens/continue_register_screen.dart';
import 'package:app_project/auth/presentation/screens/forgot_password_screen.dart';
import 'package:app_project/auth/presentation/screens/login_screen.dart';
import 'package:app_project/auth/presentation/screens/register_screen.dart';
import 'package:app_project/home/presentation/screens/create_championship_screen.dart';
import 'package:app_project/home/presentation/screens/enter_tournament_code_screen.dart';
import 'package:app_project/home/presentation/screens/home_screen.dart';
import 'package:app_project/home/presentation/screens/player_home_screen.dart';
import 'package:app_project/home/presentation/screens/referee_home_screen.dart';
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
      GoRoute(
          path: '/continue-register',
          builder: (context, state) => const ContinueRegisterScreen()),
      GoRoute(
          path: '/enter-tournament-code',
          builder: (context, state) => const EnterTournamentCodeScreen()),
      GoRoute(
          path: '/',
          builder: (context, state) {
            final user = goRouterNotifier.currentUser;
            if (user == null) return const LoginScreen();

            switch (user.rol) {
              case UserRole.player:
                return const PlayerHomeScreen();
              case UserRole.referee:
                return const RefereeHomeScreen();
              case UserRole.organizer:
                return const HomeScreen();
              default:
                return const LoginScreen();
            }
          }),
      GoRoute(
          path: '/create-championship',
          builder: (context, state) {
            final user = goRouterNotifier.currentUser;
            if (user?.rol != UserRole.organizer) {
              return const HomeScreen(); // O redirigir a una pantalla de error
            }
            return const CreateChampionshipScreen();
          }),
    ],
    redirect: (context, state) {
      final isGoingTo = state.uri.toString();
      final authStatus = goRouterNotifier.authStatus;
      final user = goRouterNotifier.currentUser;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      print("Authenticacion status: $authStatus");

      // Si el usuario necesita completar su registro
      if (authStatus == AuthStatus.needsProfileCompletion) {
        if (isGoingTo == '/continue-register') return null;
        return '/continue-register';
      }

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;
        return '/login';
      }

      if (authStatus == AuthStatus.authenticated && user != null) {
        // Verificar si el usuario necesita ingresar un código de acceso
        final isReferee = user.rol == UserRole.referee;
        final isPlayer = user.rol == UserRole.player;
        print('User: ${user.toString()}');
        final hasNoTournaments = user.torneos == null || user.torneos!.isEmpty;
        print(user.rol.toString());
        print('Torneos: ${user.torneos}');
        print('isReferee: $isReferee');
        print('isPlayer: $isPlayer');
        print('hasNoTournaments: $hasNoTournaments');
        if ((isReferee || isPlayer) && hasNoTournaments) {
          print('Usuario necesita ingresar un código de acceso');
          if (isGoingTo == '/enter-tournament-code') return null;
          return '/enter-tournament-code';
        }

        // Verificar permisos para crear campeonato
        if (isGoingTo == '/create-championship' &&
            user.rol != UserRole.organizer) {
          return '/';
        }

        // Si el usuario está autenticado y tiene un torneo asignado
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash' ||
            isGoingTo == '/continue-register' ||
            isGoingTo == '/enter-tournament-code') {
          return '/';
        }
      }

      return null;
    },
  );
});
