import 'package:app_project/auth/domain/domain.dart';
import 'package:app_project/auth/domain/entities/role.dart';
import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContinueRegisterScreen extends ConsumerStatefulWidget {
  const ContinueRegisterScreen({super.key});

  @override
  ContinueRegisterScreenState createState() => ContinueRegisterScreenState();
}

class ContinueRegisterScreenState
    extends ConsumerState<ContinueRegisterScreen> {
  UserRole? selectedRole;

  List<UserRole> get roles => UserRole.values;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completar registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Hola ${user.fullName}, por favor selecciona tu rol para continuar:',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final role = roles[index];
                  return Card(
                    elevation: selectedRole == role ? 4 : 1,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: selectedRole == role
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedRole = role;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Icon(
                              role.icon,
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    role.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    role.description,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (selectedRole == role)
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).primaryColor,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedRole == null
                    ? null
                    : () {
                        _completeRegistration(user);
                      },
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeRegistration(User user) async {
    if (selectedRole == null) return;

    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await _saveUserRole(user.id, selectedRole!.name);

      // Cerrar el diálogo de carga
      if (context.mounted) Navigator.pop(context);

      // Redirigir a la página principal
      if (context.mounted) context.go('/');
    } catch (e) {
      // Cerrar el diálogo de carga
      if (context.mounted) Navigator.pop(context);

      // Mostrar error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _saveUserRole(String userId, String role) async {
    await ref.read(authProvider.notifier).completeRegistration(role);
  }
}
