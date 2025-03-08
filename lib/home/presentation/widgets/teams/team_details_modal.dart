import 'package:app_project/home/domain/entities/equipo.dart';
import 'package:flutter/material.dart';

class TeamDetailsModal extends StatelessWidget {
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);
  final Equipo equipo;

  const TeamDetailsModal({
    super.key,
    required this.equipo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barra de arrastre
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Logo y nombre del equipo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield,
              color: mainColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            equipo.nombre,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${equipo.jugadores.length} jugadores',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Lista de jugadores
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.people, color: mainColor, size: 20),
                SizedBox(width: 8),
                Text(
                  'Plantilla del Equipo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Lista de jugadores con scroll
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: equipo.jugadores.length,
              itemBuilder: (context, index) {
                final jugador = equipo.jugadores[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: mainColor.withOpacity(0.1),
                    child: Text(
                      jugador.nombre.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    jugador.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '#${jugador.numero}',
                      style: const TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
