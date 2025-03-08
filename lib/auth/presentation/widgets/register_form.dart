import 'package:app_project/auth/presentation/providers/register_form_provider.dart';
import 'package:app_project/shared/infrastructure/inputs/role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterForm extends ConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerForm = ref.watch(registerFormProvider);
    final Roles = [
      {'value': 'Jugador', 'label': 'Jugador'},
      {'value': 'Organizador', 'label': 'Organizador'},
      {'value': 'Árbitro', 'label': 'Árbitro'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          TextField(
            onChanged: ref.read(registerFormProvider.notifier).onNameChange,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              labelText: 'Nombre Completo',
              errorText: registerForm.isFormPosted
                  ? registerForm.name.errorMessage
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: ref.read(registerFormProvider.notifier).onEmailChange,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              labelText: 'Email',
              errorText: registerForm.isFormPosted
                  ? registerForm.email.errorMessage
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged:
                ref.read(registerFormProvider.notifier).onPasswordChanged,
            obscureText: registerForm.isPasswordObscured,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(registerForm.isPasswordObscured
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  ref
                      .read(registerFormProvider.notifier)
                      .togglePasswordVisibility();
                },
              ),
              labelText: 'Password',
              errorText: registerForm.isFormPosted
                  ? registerForm.password.errorMessage
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          // Seleccionar el rol con diseño similar a TextField
          InputDecorator(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              labelText: 'Rol',
              errorText: registerForm.isFormPosted &&
                      registerForm.role.errorMessage != null
                  ? registerForm.role.errorMessage
                  : null,
              border: const UnderlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: registerForm.role.value == RoleType.jugador
                    ? 'Jugador'
                    : registerForm.role.value == RoleType.organizador
                        ? 'Organizador'
                        : 'Árbitro',
                onChanged: (String? value) {
                  ref.read(registerFormProvider.notifier).onRoleChanged(value!);
                },
                items: Roles.map<DropdownMenuItem<String>>(
                    (Map<String, String> role) {
                  return DropdownMenuItem<String>(
                    value: role['value'],
                    child: Text(
                      role['label']!,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                isExpanded: true, // Asegura que el Dropdown ocupe todo el ancho
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ref.read(registerFormProvider.notifier).onFormSubmit();
              },
              child: const Text('Registrar Usuario',
                  style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes una cuenta? '),
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
