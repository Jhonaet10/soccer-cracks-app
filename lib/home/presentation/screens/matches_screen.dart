import 'package:app_project/home/presentation/providers/partido_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partidos = ref.watch(partidosProvider);

    if (partidos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: partidos.length,
      itemBuilder: (context, index) {
        final partido = partidos[index];

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: const Icon(Icons.sports_soccer, size: 30),
            title: Text(
              '${partido.equipo1Nombre} vs ${partido.equipo2Nombre}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Fecha: ${partido.fecha.toLocal()}'),
            trailing: partido.resultado != null
                ? Text(
                    partido.resultado!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  )
                : const Icon(Icons.schedule, color: Colors.grey),
          ),
        );
      },
    );
  }
}
