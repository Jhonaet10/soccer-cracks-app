import 'package:app_project/home/domain/entities/partido_detalle.dart';
import 'package:app_project/home/presentation/widgets/matches/match_card.dart';
import 'package:flutter/material.dart';

class MatchesList extends StatelessWidget {
  final List<PartidoDetalle> partidos;
  final bool canEditResults;

  const MatchesList({
    super.key,
    required this.partidos,
    this.canEditResults = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: partidos.length,
      itemBuilder: (context, index) {
        final partido = partidos[index];
        return MatchCard(
          partido: partido,
          canEditResults: canEditResults,
        );
      },
    );
  }
}
