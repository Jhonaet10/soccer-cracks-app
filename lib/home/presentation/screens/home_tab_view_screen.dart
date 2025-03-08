import 'package:app_project/home/presentation/providers/torneo_provider.dart';
import 'package:app_project/home/presentation/widgets/torneo_info.dart';
import 'package:app_project/home/presentation/widgets/no_torneo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/shared/presentation/widgets/custom_snackbar.dart';

class HomeTabView extends ConsumerStatefulWidget {
  const HomeTabView({super.key});

  @override
  HomeTabViewState createState() => HomeTabViewState();
}

class HomeTabViewState extends ConsumerState<HomeTabView> {
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  @override
  void initState() {
    super.initState();
    // Asegurarse de que se inicie la carga del torneo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(torneoProvider.notifier).loadTorneo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final torneoState = ref.watch(torneoProvider);

    // Listener para mensajes de éxito y error
    ref.listen(torneoProvider, (previous, next) {
      if (previous?.isLoading == true && !next.isLoading) {
        if (next.successMessage.isNotEmpty) {
          showCustomSnackbar(context, message: next.successMessage);
          ref.read(torneoProvider.notifier).clearSuccessMessage();
        }
        if (next.errorMessage.isNotEmpty) {
          showCustomSnackbar(context,
              message: next.errorMessage, isError: true);
          ref.read(torneoProvider.notifier).clearErrorMessage();
        }
      }
    });

    // Mostrar indicador de carga mientras isLoading es true
    if (torneoState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: mainColor,
          strokeWidth: 3,
        ),
      );
    }

    // Solo mostrar NoTorneoWidget si explícitamente no se encontró un torneo
    if (!torneoState.isLoading && torneoState.selectedTorneo == null) {
      return const NoTorneoWidget();
    }

    // Si hay un torneo seleccionado, mostrar su información
    return TorneoInfoWidget(torneo: torneoState.selectedTorneo!);
  }
}
