import 'package:app_project/home/presentation/providers/torneo_provider.dart';
import 'package:app_project/home/presentation/widgets/torneo_info.dart';
import 'package:app_project/home/presentation/widgets/no_torneo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTabView extends ConsumerWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torneoState = ref.watch(torneoProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: torneoState.selectedTorneo != null
            ? TorneoInfoWidget(torneo: torneoState.selectedTorneo!)
            : const NoTorneoWidget(),
      ),
    );
  }
}
