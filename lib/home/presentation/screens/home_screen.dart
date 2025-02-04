import 'package:app_project/auth/presentation/providers/auth_provider.dart';
import 'package:app_project/home/presentation/screens/matches_screen.dart';
import 'package:app_project/home/presentation/screens/table_position_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          title: const Text('Soccer Cracks',
              style: TextStyle(color: Colors.white, fontSize: 25)),
          bottom: const TabBar(
            labelColor: Colors.white, // Color para las pestañas seleccionadas
            unselectedLabelColor:
                Colors.white, // Color para las pestañas no seleccionadas
            tabs: [
              Tab(
                text: 'Inicio',
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                iconMargin: EdgeInsets.zero,
              ),
              Tab(
                text: 'Partidos',
                icon: Icon(Icons.sports_soccer, color: Colors.white),
                iconMargin: EdgeInsets.zero,
              ),
              Tab(
                text: 'Tabla de Posiciones',
                icon: Icon(Icons.table_chart, color: Colors.white),
                iconMargin: EdgeInsets.zero,
              ),
              Tab(
                text: 'Estadísticas',
                icon: Icon(Icons.bar_chart, color: Colors.white),
                iconMargin: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/logo.png',
                      width: 250,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        textAlign: TextAlign.center,
                        'Aun no tienes registrado un Torneo',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.push('/create-championship');
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text('Crear Torneo',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Center(child: MatchesScreen()),
            const TablePositionsScreen(),
            const Center(
              child: Text('Estadísticas'),
            ),
          ],
        ),
      ),
    );
  }
}
