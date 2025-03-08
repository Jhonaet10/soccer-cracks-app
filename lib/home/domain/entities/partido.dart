class Partido {
  final String id;
  final String torneoId;
  final String equipo1;
  final String equipo2;
  final DateTime fecha;
  final String? resultado; // Puede ser null si aún no se ha jugado
  final String estado; // Pendiente o Finalizado

  Partido({
    required this.id,
    required this.torneoId,
    required this.equipo1,
    required this.equipo2,
    required this.fecha,
    this.resultado,
    this.estado = 'Pendiente',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'torneoId': torneoId,
      'equipo1': equipo1,
      'equipo2': equipo2,
      'fecha': fecha.toIso8601String(),
      'resultado': resultado,
      'estado': estado,
    };
  }

  factory Partido.fromJson(Map<String, dynamic> json) {
    return Partido(
      id: json['id'],
      torneoId: json['torneoId'],
      equipo1: json['equipo1'],
      equipo2: json['equipo2'],
      fecha: DateTime.parse(json['fecha']),
      resultado: json['resultado'],
      estado: json['estado'] ?? 'Pendiente',
    );
  }
}
