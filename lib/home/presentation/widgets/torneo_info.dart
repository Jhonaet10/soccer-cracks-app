import 'package:app_project/home/domain/entities/torneo.dart';
import 'package:app_project/home/presentation/providers/torneo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TorneoInfoWidget extends ConsumerWidget {
  final Torneo torneo;

  const TorneoInfoWidget({super.key, required this.torneo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torneoNotifier = ref.read(torneoProvider.notifier);
    print("Torneo: ${torneo.toJson()}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/logo.jpg', width: 200),
        const SizedBox(height: 20),
        Text(
          "Torneo: ${torneo.nombre}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "Formato: ${torneo.formato}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          "Fecha de Inicio: ${torneo.fechaInicio.toLocal()}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          "Estado: ${torneo.estado}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: torneo.estado == "En curso" ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(height: 20),

        /// 🔹 Solo mostrar el botón si el torneo aún no ha comenzado
        if (torneo.estado == "Sin Empezar")
          ElevatedButton(
            onPressed: () async {
              await torneoNotifier.iniciarCampeonato();
            },
            child: const Text(
              "Iniciar Torneo",
              style: TextStyle(fontSize: 18),
            ),
          ),

        const Divider(),
        const SizedBox(height: 10),
        Text(
          "Equipos Participantes",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: torneo.equipos.length,
            itemBuilder: (context, index) {
              final equipo = torneo.equipos[index];
              return ListTile(
                title:
                    Text(equipo.nombre, style: const TextStyle(fontSize: 18)),
                subtitle: Text(
                  "Jugadores: ${equipo.jugadores.length}",
                  style: const TextStyle(fontSize: 16),
                ),
                leading: const Icon(Icons.sports_soccer, size: 30),
              );
            },
          ),
        ),
      ],
    );
  }
}
