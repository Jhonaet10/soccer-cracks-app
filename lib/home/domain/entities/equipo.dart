import 'package:app_project/home/domain/entities/jugador.dart';

class Equipo {
  final String id;
  final String nombre;
  final List<Jugador> jugadores;

  Equipo({
    required this.id,
    required this.nombre,
    required this.jugadores,
  });

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      jugadores: (json['jugadores'] as List<dynamic>)
          .map((jugador) => Jugador.fromJson(jugador))
          .toList(),
    );
  }
}
