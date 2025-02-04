import 'package:app_project/home/domain/entities/torneo.dart';
import 'package:app_project/home/domain/entities/equipo.dart';

class TorneoMapper {
  static Torneo torneoJsonToEntity(Map<String, dynamic> json) {
    return Torneo(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      formato: json['formato'] as String,
      fechaInicio: DateTime.parse(json['fechaInicio'] as String),
      equipos: (json['equipos'] as List<dynamic>)
          .map((equipo) => Equipo.fromJson(equipo))
          .toList(),
      organizadorId: json['organizadorId'] as String,
      codigoAccesoJugador: json['codigoAccesoJugador'] as String,
      codigoAccesoArbitro: json['codigoAccesoArbitro'] as String,
    );
  }
}
