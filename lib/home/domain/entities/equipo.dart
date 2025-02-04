import 'package:app_project/home/presentation/providers/equipo_form_provider.dart';

class Equipo {
  final String id;
  final String nombre;
  final List<Jugador> jugadores;

  Equipo({
    required this.id,
    required this.nombre,
    required this.jugadores,
  });
}
