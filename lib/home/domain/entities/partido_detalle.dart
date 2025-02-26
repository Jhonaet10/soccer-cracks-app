import 'package:app_project/home/domain/entities/partido.dart';

class PartidoDetalle extends Partido {
  final String equipo1Nombre;
  final String equipo2Nombre;

  PartidoDetalle({
    required super.id,
    required super.torneoId,
    required super.equipo1,
    required super.equipo2,
    required super.fecha,
    super.resultado,
    required this.equipo1Nombre,
    required this.equipo2Nombre,
  });

  PartidoDetalle copyWith({
    String? id,
    String? torneoId,
    String? equipo1,
    String? equipo2,
    DateTime? fecha,
    String? resultado,
    String? equipo1Nombre,
    String? equipo2Nombre,
  }) {
    return PartidoDetalle(
      id: id ?? this.id,
      torneoId: torneoId ?? this.torneoId,
      equipo1: equipo1 ?? this.equipo1,
      equipo2: equipo2 ?? this.equipo2,
      fecha: fecha ?? this.fecha,
      resultado: resultado ?? this.resultado,
      equipo1Nombre: equipo1Nombre ?? this.equipo1Nombre,
      equipo2Nombre: equipo2Nombre ?? this.equipo2Nombre,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'equipo1Nombre': equipo1Nombre,
      'equipo2Nombre': equipo2Nombre,
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
      equipo1Nombre: json['equipo1Nombre'] ?? '',
      equipo2Nombre: json['equipo2Nombre'] ?? '',
    );
  }
}
