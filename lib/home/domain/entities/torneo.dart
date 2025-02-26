import 'package:app_project/home/domain/entities/equipo.dart';
import 'package:app_project/home/domain/entities/jugador.dart';

class Torneo {
  final String id;
  final String nombre;
  final String formato;
  final String? estado;
  final DateTime fechaInicio;
  final List<Equipo> equipos;
  final String organizadorId;
  final String codigoAccesoJugador;
  final String codigoAccesoArbitro;

  Torneo({
    required this.id,
    this.estado = 'Sin Empezar',
    required this.nombre,
    required this.formato,
    required this.fechaInicio,
    required this.equipos,
    required this.organizadorId,
    required this.codigoAccesoJugador,
    required this.codigoAccesoArbitro,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'formato': formato,
      'estado': estado,
      'fechaInicio': fechaInicio.toIso8601String(),
      'equipos': equipos
          .map((e) => {
                'nombre': e.nombre,
                'jugadores': e.jugadores
                    .map((j) => {'nombre': j.nombre, 'numero': j.numero})
                    .toList()
              })
          .toList(),
      'organizadorId': organizadorId,
      'codigoAccesoJugador': codigoAccesoJugador,
      'codigoAccesoArbitro': codigoAccesoArbitro,
    };
  }

  Torneo copyWith({
    String? id,
    String? nombre,
    String? formato,
    String? estado,
    DateTime? fechaInicio,
    List<Equipo>? equipos,
    String? organizadorId,
    String? codigoAccesoJugador,
    String? codigoAccesoArbitro,
  }) {
    return Torneo(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      formato: formato ?? this.formato,
      estado: estado ?? this.estado,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      equipos: equipos ?? this.equipos,
      organizadorId: organizadorId ?? this.organizadorId,
      codigoAccesoJugador: codigoAccesoJugador ?? this.codigoAccesoJugador,
      codigoAccesoArbitro: codigoAccesoArbitro ?? this.codigoAccesoArbitro,
    );
  }

  //from json
  factory Torneo.fromJson(Map<String, dynamic> json) {
    return Torneo(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      formato: json['formato'] ?? '',
      estado: json['estado'] ?? 'Sin Empezar',
      fechaInicio: json['fechaInicio'] != null
          ? DateTime.parse(json['fechaInicio'])
          : DateTime.now(), // Manejo de error si es null
      equipos: (json['equipos'] as List<dynamic>? ?? [])
          .map((e) => Equipo(
                id: e['id'] ?? '',
                nombre: e['nombre'] ?? '',
                jugadores: (e['jugadores'] as List<dynamic>? ?? [])
                    .map((j) => Jugador(
                          nombre: j['nombre'] ?? '',
                          numero:
                              j['numero'] ?? 0, // Asegurar número como entero
                        ))
                    .toList(),
              ))
          .toList(),
      organizadorId: json['organizadorId'] ?? '',
      codigoAccesoJugador: json['codigoAccesoJugador'] ?? '',
      codigoAccesoArbitro: json['codigoAccesoArbitro'] ?? '',
    );
  }
}
