import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/home/presentation/providers/torneo_provider.dart';
import 'package:app_project/home/presentation/screens/home_tab_view_screen.dart';
import 'package:app_project/home/presentation/screens/matches_screen.dart';
import 'package:app_project/home/presentation/screens/table_position_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torneoNotifier = ref.read(torneoProvider.notifier);

    // Cargar el torneo del usuario al abrir la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      torneoNotifier.getTorneoByUser();
    });

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
            ),
          ],
          title: const Text(
            'Soccer Cracks',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
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
            text: 'Estadísticas',
            icon: Icon(Icons.bar_chart, color: Colors.white)),
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
        Center(child: MatchesScreen()),
        TablePositionsScreen(),
        Center(child: Text('Estadísticas')),
      ],
    );
  }
}
