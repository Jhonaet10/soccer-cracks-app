import 'package:app_project/home/presentation/providers/tabla_posicion_provider.dart';
import 'package:app_project/home/presentation/providers/torneo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TablePositionsScreen extends ConsumerWidget {
  const TablePositionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torneoState = ref.watch(torneoProvider);
    final torneo = torneoState.selectedTorneo;

    if (torneo == null) {
      return const Center(child: Text("No hay torneo activo."));
    }

    if (torneo.estado != "En curso") {
      return const Center(child: Text("El torneo aún no ha comenzado."));
    }

    // 🔹 Escuchar cambios en el torneo y cargar la tabla cuando el estado sea "En curso"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tablaCargada = ref.read(tablaCargadaProvider);
      if (!tablaCargada && torneo?.estado == "En curso") {
        print("Carga inicial de la tabla de posiciones...");
        ref.read(tablaPosicionesProvider.notifier).cargarTabla(torneo!.id);
        ref.read(tablaCargadaProvider.notifier).state =
            true; // Evita múltiples cargas
      }
    });

    final tablaPosiciones = ref.watch(tablaPosicionesProvider);

    if (tablaPosiciones.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0), // 🔹 Espaciado en los bordes
      child: Column(
        children: [
          const Text(
            'Tabla de Posiciones',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // 🔹 Scroll horizontal si la tabla es muy ancha
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100], // 🔹 Color de fondo suave
                borderRadius:
                    BorderRadius.circular(15), // 🔹 Bordes redondeados
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: DataTable(
                border:
                    TableBorder.all(color: Colors.black26), // 🔹 Bordes suaves
                columns: const [
                  DataColumn(
                      label: Text(
                    '#',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
                  DataColumn(
                      label: Text(
                    'Equipo',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
                  DataColumn(
                      label: Text(
                    'PJ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
                  DataColumn(
                      label: Text(
                    'G',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
                  DataColumn(
                      label: Text(
                    'E',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
                  DataColumn(
                      label: Text(
                    'P',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
                  DataColumn(
                      label: Text(
                    'DG',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
                  DataColumn(
                      label: Text(
                    'Pts',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
                ],
                headingRowColor: WidgetStateProperty.all(
                    Color.fromRGBO(0, 0, 100, 1)), // 🔹 Fondo del encabezado
                dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  return states.contains(WidgetState.selected)
                      ? Colors.blue.withOpacity(0.1)
                      : null; // 🔹 Alternar color de filas
                }),
                rows: tablaPosiciones.map((equipo) {
                  return DataRow(
                    color: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                      return (tablaPosiciones.indexOf(equipo) % 2 == 0)
                          ? Colors.grey[200]
                          : Colors.white; // 🔹 Alternar color en las filas
                    }),
                    cells: [
                      DataCell(Text(
                          (tablaPosiciones.indexOf(equipo) + 1).toString())),
                      DataCell(Text(
                        equipo.nombreEquipo!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataCell(Text(equipo.pj.toString())),
                      DataCell(Text(equipo.g.toString())),
                      DataCell(Text(equipo.e.toString())),
                      DataCell(Text(equipo.p.toString())),
                      DataCell(Text(equipo.dg.toString())),
                      DataCell(Text(
                        equipo.pts.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
