import 'package:app_project/home/presentation/providers/torneo_form_provider.dart';
import 'package:app_project/home/presentation/widgets/tournament/tournament_header.dart';
import 'package:app_project/home/presentation/widgets/tournament/tournament_form.dart';
import 'package:app_project/home/presentation/widgets/tournament/teams_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/home/presentation/providers/torneo_provider.dart';
import 'package:app_project/shared/presentation/widgets/custom_snackbar.dart';

class CreateChampionshipScreen extends ConsumerStatefulWidget {
  static const name = 'create-championship-screen';

  const CreateChampionshipScreen({super.key});

  @override
  CreateChampionshipScreenState createState() =>
      CreateChampionshipScreenState();
}

class CreateChampionshipScreenState
    extends ConsumerState<CreateChampionshipScreen> {
  @override
  Widget build(BuildContext context) {
    final torneoForm = ref.watch(torneoFormProvider);
    final torneoState = ref.watch(torneoProvider);

    ref.listen<TorneoFormState>(torneoFormProvider, (prev, next) {
      if (prev?.isSubmitting == true && !next.isSubmitting) {
        if (next.successMessage.isNotEmpty) {
          showCustomSnackbar(context, message: next.successMessage);
          ref.read(torneoFormProvider.notifier).clearSuccessMessage();
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        if (next.errorMessage.isNotEmpty) {
          showCustomSnackbar(context,
              message: next.errorMessage, isError: true);
          ref.read(torneoFormProvider.notifier).clearErrorMessage();
        }
      }
    });

    ref.listen(torneoProvider, (prev, next) {
      if (prev?.isLoading == true && !next.isLoading) {
        if (next.successMessage.isNotEmpty) {
          showCustomSnackbar(context, message: next.successMessage);
          ref.read(torneoProvider.notifier).clearSuccessMessage();
          Navigator.pop(context);
        }
        if (next.errorMessage.isNotEmpty) {
          showCustomSnackbar(context,
              message: next.errorMessage, isError: true);
          ref.read(torneoProvider.notifier).clearErrorMessage();
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(0, 0, 100, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(255, 255, 255, 1)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TournamentHeader(),
            const SizedBox(height: 20),
            const TournamentForm(),
            const SizedBox(height: 20),
            const TeamsSection(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: AnimatedOpacity(
                opacity: torneoForm.isValid ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: torneoForm.isValid
                          ? ref
                              .read(torneoFormProvider.notifier)
                              .registrarTorneo
                          : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(0, 0, 100, 1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Crear Torneo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
