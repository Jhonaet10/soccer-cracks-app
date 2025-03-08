import 'package:app_project/home/domain/entities/partido.dart';

class PartidoDetalle extends Partido {
  final String equipo1Nombre;
  final String equipo2Nombre;
  final Map<String, dynamic>? incidencias;

  PartidoDetalle({
    required super.id,
    required super.torneoId,
    required super.equipo1,
    required super.equipo2,
    required super.fecha,
    super.resultado,
    super.estado = 'Pendiente',
    required this.equipo1Nombre,
    required this.equipo2Nombre,
    this.incidencias,
  });

  PartidoDetalle copyWith({
    String? id,
    String? torneoId,
    String? equipo1,
    String? equipo2,
    DateTime? fecha,
    String? resultado,
    String? estado,
    String? equipo1Nombre,
    String? equipo2Nombre,
    Map<String, dynamic>? incidencias,
  }) {
    return PartidoDetalle(
      id: id ?? this.id,
      torneoId: torneoId ?? this.torneoId,
      equipo1: equipo1 ?? this.equipo1,
      equipo2: equipo2 ?? this.equipo2,
      fecha: fecha ?? this.fecha,
      resultado: resultado ?? this.resultado,
      estado: estado ?? this.estado,
      equipo1Nombre: equipo1Nombre ?? this.equipo1Nombre,
      equipo2Nombre: equipo2Nombre ?? this.equipo2Nombre,
      incidencias: incidencias ?? this.incidencias,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'equipo1Nombre': equipo1Nombre,
      'equipo2Nombre': equipo2Nombre,
      'incidencias': incidencias,
    };
  }

  factory PartidoDetalle.fromJson(Map<String, dynamic> json) {
    return PartidoDetalle(
      id: json['id'],
      torneoId: json['torneoId'],
      equipo1: json['equipo1'],
      equipo2: json['equipo2'],
      fecha: DateTime.parse(json['fecha']),
      resultado: json['resultado'],
      estado: json['estado'] ?? 'Pendiente',
      equipo1Nombre: json['equipo1Nombre'] ?? '',
      equipo2Nombre: json['equipo2Nombre'] ?? '',
      incidencias: json['incidencias'] as Map<String, dynamic>?,
    );
  }
}
