import 'package:app_project/home/domain/entities/equipo.dart';
import 'package:app_project/home/domain/entities/torneo.dart';

class TorneoMapper {
  static Torneo torneoJsonToEntity(Map<String, dynamic> json) => Torneo(
        id: json['id'] ?? '',
        estado: json['estado'] ?? 'Sin Empezar',
        nombre: json['nombre'] ?? '',
        formato: json['formato'] ?? '',
        fechaInicio: DateTime.parse(json['fechaInicio']),
        equipos: (json['equipos'] as List<dynamic>?)
                ?.map((e) => e as Equipo)
                .toList() ??
            [],
        organizadorId: json['organizadorId'] ?? '',
        codigoAccesoJugador: json['codigoAccesoJugador'] ?? '',
        codigoAccesoArbitro: json['codigoAccesoArbitro'] ?? '',
      );

  static Map<String, dynamic> torneoEntityToJson(Torneo torneo) => {
        'id': torneo.id,
        'estado': torneo.estado,
        'nombre': torneo.nombre,
        'formato': torneo.formato,
        'fechaInicio': torneo.fechaInicio.toIso8601String(),
        'equipos': torneo.equipos.map((e) => e.id).toList(),
        'organizadorId': torneo.organizadorId,
        'codigoAccesoJugador': torneo.codigoAccesoJugador,
        'codigoAccesoArbitro': torneo.codigoAccesoArbitro,
      };
}
