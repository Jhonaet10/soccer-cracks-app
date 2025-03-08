import 'package:app_project/home/presentation/providers/partido_provider.dart';
import 'package:app_project/home/presentation/widgets/common/tab_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/home/presentation/widgets/matches/empty_matches.dart';
import 'package:app_project/home/presentation/widgets/matches/matches_list.dart';

class MatchesScreen extends ConsumerWidget {
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);
  final bool canEditResults;

  const MatchesScreen({
    super.key,
    this.canEditResults = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partidos = ref.watch(partidosProvider);

    return Column(
      children: [
        const TabHeader(
          title: 'Calendario de Partidos',
          description:
              'Aquí puedes ver todos los partidos programados del torneo',
        ),
        // Lista de partidos
        if (partidos.isEmpty)
          const EmptyMatches()
        else
          Expanded(
            child: MatchesList(
              partidos: partidos,
              canEditResults: canEditResults,
            ),
          ),
      ],
    );
  }
}
