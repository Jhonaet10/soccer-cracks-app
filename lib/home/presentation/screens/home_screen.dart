import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/home/presentation/providers/torneo_provider.dart';
import 'package:app_project/home/presentation/screens/home_tab_view_screen.dart';
import 'package:app_project/home/presentation/screens/matches_screen.dart';
import 'package:app_project/home/presentation/screens/register_results_screen.dart';
import 'package:app_project/home/presentation/screens/table_position_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  static const name = 'home-screen';
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torneoNotifier = ref.read(torneoProvider.notifier);
    final user = ref.watch(authProvider).user;

    // Cargar el torneo del usuario al abrir la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      torneoNotifier.getTorneoByUser();
    });

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user?.fullName.substring(0, 1).toUpperCase() ?? 'O',
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
                      user?.fullName ?? 'Organizador',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Organizador del Torneo',
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
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
            ),
          ],
          bottom: const _Tabs(),
        ),
        body: const _TabViews(),
      ),
    );
  }
}

/// **Widget que maneja los Tabs**
class _Tabs extends StatelessWidget implements PreferredSizeWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white,
      tabs: [
        Tab(text: 'Inicio', icon: Icon(Icons.home, color: Colors.white)),
        Tab(
            text: 'Partidos',
            icon: Icon(Icons.sports_soccer, color: Colors.white)),
        Tab(
            text: 'Tabla de Posiciones',
            icon: Icon(Icons.table_chart, color: Colors.white)),
        Tab(
            text: 'Resultados',
            icon: Icon(Icons.edit_note, color: Colors.white)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// **Widget que maneja el contenido de cada tab**
class _TabViews extends StatelessWidget {
  const _TabViews();

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: [
        HomeTabView(), // Refactorizado en un nuevo widget
        MatchesScreen(),
        TablePositionsScreen(),
        RegisterResultsScreen(),
      ],
    );
  }
}
