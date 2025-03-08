import 'package:app_project/home/domain/entities/jugador.dart';

class JugadorMapper {
  static Jugador jugadorJsonToEntity(Map<String, dynamic> json) => Jugador(
        nombre: json['nombre'] ?? '',
        numero: json['numero'] ?? 0,
      );

  static Map<String, dynamic> jugadorEntityToJson(Jugador jugador) => {
        'nombre': jugador.nombre,
        'numero': jugador.numero,
      };
}
