import 'package:app_project/auth/presentation/widgets/header_login.dart';
import 'package:app_project/auth/presentation/widgets/register_form.dart';
import 'package:app_project/home/presentation/screens/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            HeaderLogin(height: 300, logoHeight: 0),
            Text('Registro de Usuario', style: TextStyle(fontSize: 30)),
            RegisterForm(),
          ],
        ),
      ),
    );
  }
}
