import 'package:app_project/auth/presentation/providers/login_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: Column(
        children: [
          const Center(
            child: Text(
              'Inicio de Sesión',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextField(
            onChanged: ref.read(loginFormProvider.notifier).onEmailChange,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              errorText:
                  loginForm.isFormPosted ? loginForm.email.errorMessage : null,
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
            obscureText: loginForm.isPasswordObscured,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(loginForm.isPasswordObscured
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  ref
                      .read(loginFormProvider.notifier)
                      .togglePasswordVisibility();
                },
              ),
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              errorText: loginForm.isFormPosted
                  ? loginForm.password.errorMessage
                  : null,
              labelText: 'Password',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  context.push('/forget-password');
                },
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ref.read(loginFormProvider.notifier).onFormSubmit();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes una cuenta?'),
              TextButton(
                onPressed: () {
                  context.push('/register');
                },
                child: const Text('Regístrate'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              const Text('O inicia sesión con'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref.read(loginFormProvider.notifier).onSignInWithGoogle();
                    },
                    child: const Text('Google'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Facebook'),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
