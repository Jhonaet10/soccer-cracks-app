import 'package:app_project/auth/presentation/widgets/header_login.dart';
import 'package:app_project/auth/presentation/widgets/login_form.dart';
import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    print('Estado actual de autenticación: ${authState.authStatus}');

    if (authState.authStatus == AuthStatus.checking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderLogin(height: 360, logoHeight: 60),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
