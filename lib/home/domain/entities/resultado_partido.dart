class ResultadoPartido {
  final String id;
  final String partidoId;
  final String torneoId;
  final String equipo1Id;
  final String equipo2Id;
  final int golesEquipo1;
  final int golesEquipo2;
  final Map<String, dynamic> incidencias;
  final DateTime fechaRegistro;

  ResultadoPartido({
    required this.id,
    required this.partidoId,
    required this.torneoId,
    required this.equipo1Id,
    required this.equipo2Id,
    required this.golesEquipo1,
    required this.golesEquipo2,
    required this.incidencias,
    required this.fechaRegistro,
  });

  factory ResultadoPartido.fromJson(Map<String, dynamic> json) {
    return ResultadoPartido(
      id: json['id'],
      partidoId: json['partidoId'],
      torneoId: json['torneoId'],
      equipo1Id: json['equipo1Id'],
      equipo2Id: json['equipo2Id'],
      golesEquipo1: json['golesEquipo1'],
      golesEquipo2: json['golesEquipo2'],
      incidencias: json['incidencias'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partidoId': partidoId,
      'torneoId': torneoId,
      'equipo1Id': equipo1Id,
      'equipo2Id': equipo2Id,
      'golesEquipo1': golesEquipo1,
      'golesEquipo2': golesEquipo2,
      'incidencias': incidencias,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }
}
