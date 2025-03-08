import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/home/presentation/providers/torneo_provider.dart';
import 'package:app_project/home/presentation/providers/partido_provider.dart';
import 'package:app_project/home/presentation/providers/tabla_posicion_provider.dart';
import 'package:app_project/home/presentation/screens/matches_screen.dart';
import 'package:app_project/home/presentation/screens/register_results_screen.dart';
import 'package:app_project/home/presentation/screens/table_position_screen.dart';
import 'package:app_project/home/presentation/widgets/torneo_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PlayerHomeScreen extends ConsumerWidget {
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  const PlayerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final torneoState = ref.watch(torneoProvider);

    // Cargar datos adicionales cuando el torneo esté disponible
    if (torneoState.selectedTorneo != null && !torneoState.isLoading) {
      final torneo = torneoState.selectedTorneo!;
      // Solo cargar datos necesarios para el jugador
      ref.read(tablaPosicionesProvider.notifier).cargarTabla(torneo.id);
      ref.read(partidosProvider.notifier).cargarPartidos(torneo.id);
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: mainColor,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user?.fullName.substring(0, 1).toUpperCase() ?? 'J',
                  style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.fullName ?? 'Jugador',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Jugador del Torneo',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Inicio'),
              Tab(icon: Icon(Icons.sports_soccer), text: 'Partidos'),
              Tab(icon: Icon(Icons.leaderboard), text: 'Tabla'),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            // Tab de Inicio
            _HomeTab(torneoState: torneoState),

            // Tab de Partidos (vista de solo lectura para jugadores)
            torneoState.selectedTorneo == null
                ? const Center(child: Text('No hay torneo asignado'))
                : const MatchesScreen(),

            // Tab de Tabla de Posiciones
            torneoState.selectedTorneo == null
                ? const Center(child: Text('No hay torneo asignado'))
                : const TablePositionsScreen(),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final TorneoState torneoState;
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  const _HomeTab({
    required this.torneoState,
  });

  @override
  Widget build(BuildContext context) {
    if (torneoState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: mainColor),
      );
    }

    if (torneoState.selectedTorneo == null) {
      return const Center(
        child: Text('No hay torneo asignado'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          TorneoInfoWidget(
            torneo: torneoState.selectedTorneo!,
            showAdminActions: false, // No mostrar acciones de administrador
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Acciones Rápidas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        icon: Icons.emoji_events,
                        title: 'Tabla de\nPosiciones',
                        onTap: () {
                          DefaultTabController.of(context).animateTo(2);
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _ActionCard(
                        icon: Icons.sports_soccer,
                        title: 'Ver\nPartidos',
                        onTap: () {
                          DefaultTabController.of(context).animateTo(1);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estado del Torneo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: torneoState.selectedTorneo!.estado ==
                                      "En curso"
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              torneoState.selectedTorneo!.estado ??
                                  "Sin Empezar",
                              style: TextStyle(
                                color: torneoState.selectedTorneo!.estado ==
                                        "En curso"
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
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
            Icon(
              icon,
              size: 40,
              color: const Color.fromRGBO(0, 0, 100, 1),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 0, 100, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
