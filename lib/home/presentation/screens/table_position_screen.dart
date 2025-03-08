import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/home/presentation/providers/tabla_posicion_provider.dart';
import 'package:app_project/home/presentation/providers/torneo_provider.dart';
import 'package:app_project/home/presentation/widgets/common/tab_header.dart';
import 'package:app_project/home/presentation/widgets/table/positions_table.dart';
import 'package:app_project/home/presentation/widgets/table/empty_table.dart';

class TablePositionsScreen extends ConsumerWidget {
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);
  const TablePositionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torneoState = ref.watch(torneoProvider);
    final torneo = torneoState.selectedTorneo;

    // Verificar si hay un torneo activo
    if (torneo == null) {
      return const Scaffold(
        body: EmptyTable(
          message: 'No hay torneo activo',
        ),
      );
    }

    // Verificar si el torneo ha comenzado
    if (torneo.estado != "En curso") {
      return const Scaffold(
        body: EmptyTable(
          message: 'El torneo aún no ha comenzado',
        ),
      );
    }

    // Cargar la tabla cuando el torneo está en curso
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tablaCargada = ref.read(tablaCargadaProvider);
      if (!tablaCargada && torneo.estado == "En curso") {
        ref.read(tablaPosicionesProvider.notifier).cargarTabla(torneo.id);
        ref.read(tablaCargadaProvider.notifier).state = true;
      }
    });

    final tablaPosiciones = ref.watch(tablaPosicionesProvider);

    return Column(
      children: [
        const TabHeader(
          title: 'Tabla de Posiciones',
          description: 'Aquí puedes ver la clasificación actual del torneo',
        ),
        // Tabla o indicador de carga
        if (tablaPosiciones.isEmpty)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: mainColor,
                strokeWidth: 3,
              ),
            ),
          )
        else
          Expanded(
            child: PositionsTable(
              tablaPosiciones: tablaPosiciones,
            ),
          ),
      ],
    );
  }
}
