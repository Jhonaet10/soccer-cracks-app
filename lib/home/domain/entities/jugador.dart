class Jugador {
  final String nombre;
  final int numero;

  Jugador({required this.nombre, required this.numero});

  factory Jugador.fromJson(Map<String, dynamic> json) {
    return Jugador(
      nombre: json['nombre'] as String,
      numero: json['numero'] as int,
    );
  }
}
