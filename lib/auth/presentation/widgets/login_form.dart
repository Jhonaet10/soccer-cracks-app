import 'package:app_project/auth/presentation/providers/login_form_provider.dart';
import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/shared/presentation/widgets/custom_snackbar.dart';
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

    // Listener para errores de autenticación
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty) {
        showCustomSnackbar(
          context,
          message: next.errorMessage,
          isError: true,
        );
      }
    });

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
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(loginFormProvider.notifier).onSignInWithGoogle();
                    },
                    icon: Image.asset(
                      'assets/google_icon.png',
                      height: 24,
                    ),
                    label: const Text(
                      'Continuar con Google',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
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
