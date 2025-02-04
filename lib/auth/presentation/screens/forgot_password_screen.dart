import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/logo.png',
              width: 250,
            ),
            const Text(
              'Recuperar Contraseña',
              style: TextStyle(
                color: Colors.black,
                fontSize: 35,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Regresar al Inicio de Sesión'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Recuperar Contraseña',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
