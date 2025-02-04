import 'package:app_project/home/presentation/providers/torneo_form_provider.dart';

class RegisterTorneo {
  final String nombre;
  final String formato;
  final DateTime fechaInicio;
  final List<Equipo> equipos;
  final String organizadorId;
  final String codigoAccesoJugador;
  final String codigoAccesoArbitro;

  RegisterTorneo({
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
      'nombre': nombre,
      'formato': formato,
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
}
