import '../entities/resultado_partido.dart';

abstract class ResultadoPartidoDatasource {
  Future<ResultadoPartido> registrarResultado({
    required String partidoId,
    required String torneoId,
    required String equipo1Id,
    required String equipo2Id,
    required int golesEquipo1,
    required int golesEquipo2,
    required Map<String, dynamic> incidencias,
  });

  Future<ResultadoPartido?> getResultadoByPartidoId(String partidoId);

  Future<List<ResultadoPartido>> getResultadosByTorneoId(String torneoId);
}
