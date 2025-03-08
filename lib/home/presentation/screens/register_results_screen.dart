import 'package:app_project/home/domain/entities/partido_detalle.dart';
import 'package:app_project/home/presentation/providers/partido_provider.dart';
import 'package:app_project/home/presentation/widgets/common/tab_header.dart';
import 'package:app_project/home/presentation/widgets/matches/register_result_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterResultsScreen extends ConsumerWidget {
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  const RegisterResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partidos = ref.watch(partidosProvider);

    return Column(
      children: [
        const TabHeader(
          title: 'Registro de Resultados',
          description: 'Selecciona un partido para registrar su resultado',
        ),
        // Lista de partidos
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: partidos.length,
            itemBuilder: (context, index) {
              final partido = partidos[index];
              return _MatchCard(partido: partido);
            },
          ),
        ),
      ],
    );
  }
}

class _MatchCard extends StatelessWidget {
  final PartidoDetalle partido;

  const _MatchCard({
    required this.partido,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: RegisterResultModal(partido: partido),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fecha del partido
              Text(
                '${partido.fecha.day}/${partido.fecha.month}/${partido.fecha.year}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),

              // Equipos y resultado
              Row(
                children: [
                  Expanded(
                    child: Text(
                      partido.equipo1Nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: partido.resultado != null
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      partido.resultado ?? 'Pendiente',
                      style: TextStyle(
                        color: partido.resultado != null
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      partido.equipo2Nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
