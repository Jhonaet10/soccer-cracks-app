class TablaPosicion {
  final String equipoId;
  final String? nombreEquipo; // 🔹 Nuevo campo para almacenar el nombre
  final int pj;
  final int g;
  final int e;
  final int p;
  final int dg;
  final int pts;

  TablaPosicion({
    required this.equipoId,
    this.nombreEquipo, // 🔹 Ahora es requerido
    required this.pj,
    required this.g,
    required this.e,
    required this.p,
    required this.dg,
    required this.pts,
  });

  /// 🔹 Método `copyWith()` para actualizar valores sin modificar el objeto original
  TablaPosicion copyWith({
    String? nombreEquipo,
    int? pj,
    int? g,
    int? e,
    int? p,
    int? dg,
    int? pts,
  }) {
    return TablaPosicion(
      equipoId: equipoId,
      nombreEquipo: nombreEquipo ?? this.nombreEquipo,
      pj: pj ?? this.pj,
      g: g ?? this.g,
      e: e ?? this.e,
      p: p ?? this.p,
      dg: dg ?? this.dg,
      pts: pts ?? this.pts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equipoId': equipoId,
      'nombreEquipo': nombreEquipo, // 🔹 Guardar también el nombre en Firestore
      'pj': pj,
      'g': g,
      'e': e,
      'p': p,
      'dg': dg,
      'pts': pts,
    };
  }

  factory TablaPosicion.fromJson(Map<String, dynamic> json) {
    return TablaPosicion(
      equipoId: json['equipoId'],
      nombreEquipo: json['nombreEquipo'] ??
          "Desconocido", // 🔹 Fallback si no está en Firestore
      pj: json['pj'],
      g: json['g'],
      e: json['e'],
      p: json['p'],
      dg: json['dg'],
      pts: json['pts'],
    );
  }
}
