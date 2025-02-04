import 'package:app_project/auth/presentation/widgets/header_login.dart';
import 'package:app_project/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderLogin(height: 360, logoHeight: 20),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
