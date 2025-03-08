import 'package:app_project/home/domain/entities/equipo.dart';
import 'package:app_project/home/domain/entities/jugador.dart';

class EquipoMapper {
  static Equipo equipoJsonToEntity(Map<String, dynamic> json) => Equipo(
        id: json['id'] ?? '',
        nombre: json['nombre'] ?? '',
        jugadores: (json['jugadores'] as List<dynamic>?)
                ?.map((j) => j as Jugador)
                .toList() ??
            [],
      );

  static Map<String, dynamic> equipoEntityToJson(Equipo equipo) => {
        'id': equipo.id,
        'nombre': equipo.nombre,
        'jugadores': equipo.jugadores.map((j) => j.nombre).toList(),
      };
}
