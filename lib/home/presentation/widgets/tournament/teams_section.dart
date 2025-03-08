import 'package:app_project/home/presentation/widgets/tournament/teams_form_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/home/presentation/providers/torneo_form_provider.dart';

class TeamsSection extends ConsumerWidget {
  const TeamsSection({super.key});

  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torneoForm = ref.watch(torneoFormProvider);

    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Equipos Participantes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => const TeamsFormModal(),
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                    );
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Agregar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (torneoForm.equipos.isEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Center(
                child: Text(
                  'No hay equipos registrados',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            Container(
              height: 160,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: torneoForm.equipos.length,
                itemBuilder: (context, index) {
                  final equipo = torneoForm.equipos[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: mainColor.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.shield,
                            color: mainColor,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                equipo.nombre,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${equipo.jugadores.length} jugadores',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
