import 'package:app_project/auth/domain/entities/role.dart';
import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/home/presentation/providers/torneo_provider.dart';
import 'package:app_project/home/presentation/providers/tournament_code_form_provider.dart';
import 'package:app_project/shared/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EnterTournamentCodeScreen extends ConsumerWidget {
  const EnterTournamentCodeScreen({super.key});

  void _onSubmit(BuildContext context, WidgetRef ref) async {
    final formState = ref.read(tournamentCodeFormProvider);
    print(
        'Estado del formulario - isValid: ${formState.isValid}, código: ${formState.code.value}');

    if (!formState.isValid) {
      print('Formulario no válido');
      return;
    }

    try {
      final user = ref.read(authProvider).user;
      if (user == null) {
        print('Usuario no autenticado');
        return;
      }

      final isReferee = user.rol == UserRole.referee;
      print('Es árbitro: $isReferee');

      ref.read(tournamentCodeFormProvider.notifier).setSubmitting(true);
      print('Intentando unirse al torneo con código: ${formState.code.value}');

      // Unirse al torneo
      await ref.read(torneoProvider.notifier).joinTournament(
            formState.code.value,
            isReferee ? 'Árbitro' : 'Jugador',
          );

      // Verificar si el estado del torneo indica éxito
      final torneoState = ref.read(torneoProvider);
      print(
          'Estado del torneo - successMessage: ${torneoState.successMessage}, errorMessage: ${torneoState.errorMessage}');

      if (torneoState.successMessage.isNotEmpty) {
        print('Unión exitosa, actualizando estado del usuario');

        // Cargar los datos del torneo
        await ref.read(torneoProvider.notifier).getTorneoByUser();

        if (context.mounted) {
          // Mostrar mensaje de éxito
          showCustomSnackbar(
            context,
            message: 'Se ha asociado al torneo exitosamente',
          );

          print('Redirigiendo a la pantalla principal');
          context.go('/');
        }
      } else if (torneoState.errorMessage.isNotEmpty) {
        print('Error al unirse: ${torneoState.errorMessage}');
        ref
            .read(tournamentCodeFormProvider.notifier)
            .setErrorMessage(torneoState.errorMessage);
      }
    } catch (e) {
      print('Error en _onSubmit: $e');
      ref
          .read(tournamentCodeFormProvider.notifier)
          .setErrorMessage(e.toString());
    } finally {
      if (context.mounted) {
        ref.read(tournamentCodeFormProvider.notifier).setSubmitting(false);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final formState = ref.watch(tournamentCodeFormProvider);
    final size = MediaQuery.of(context).size;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isReferee = user.rol == UserRole.referee;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Logo y título
                Hero(
                  tag: 'app_logo',
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/logo.jpg',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Tarjeta principal
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: size.width > 600 ? 500 : double.infinity,
                  ),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '¡Bienvenido ${user.fullName}!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isReferee ? 'Árbitro del Torneo' : 'Jugador del Torneo',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Ingresa el código de acceso proporcionado por el organizador para unirte al torneo',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        onChanged: ref
                            .read(tournamentCodeFormProvider.notifier)
                            .onCodeChanged,
                        decoration: InputDecoration(
                          labelText: 'Código de acceso',
                          hintText: 'Ejemplo: ABC123',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: const Icon(Icons.key),
                          errorText: formState.errorMessage,
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: formState.isSubmitting
                              ? null
                              : () => _onSubmit(context, ref),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: formState.isSubmitting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Unirme al Torneo',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Información adicional
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'El código de acceso te permite unirte a un torneo específico. Si no tienes uno, contacta al organizador.',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
