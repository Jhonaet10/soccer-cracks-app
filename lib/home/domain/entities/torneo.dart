import 'package:app_project/home/presentation/providers/torneo_form_provider.dart';

class Torneo {
  final String id;
  final String nombre;
  final String formato;
  final DateTime fechaInicio;
  final List<Equipo> equipos;
  final String organizadorId;
  final String codigoAccesoJugador;
  final String codigoAccesoArbitro;

  Torneo({
    required this.id,
    required this.nombre,
    required this.formato,
    required this.fechaInicio,
    required this.equipos,
    required this.organizadorId,
    required this.codigoAccesoJugador,
    required this.codigoAccesoArbitro,
  });
}
