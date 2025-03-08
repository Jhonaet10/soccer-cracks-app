import 'package:app_project/home/domain/datasource/resultado_partido_datasource.dart';
import 'package:app_project/home/domain/entities/resultado_partido.dart';
import 'package:app_project/home/domain/repositories/resultado_partido_repository.dart';

class ResultadoPartidoRepositoryImpl implements ResultadoPartidoRepository {
  final ResultadoPartidoDatasource _datasource;

  ResultadoPartidoRepositoryImpl(this._datasource);

  @override
  Future<ResultadoPartido> registrarResultado({
    required String partidoId,
    required String torneoId,
    required String equipo1Id,
    required String equipo2Id,
    required int golesEquipo1,
    required int golesEquipo2,
    required Map<String, dynamic> incidencias,
  }) {
    return _datasource.registrarResultado(
      partidoId: partidoId,
      torneoId: torneoId,
      equipo1Id: equipo1Id,
      equipo2Id: equipo2Id,
      golesEquipo1: golesEquipo1,
      golesEquipo2: golesEquipo2,
      incidencias: incidencias,
    );
  }

  @override
  Future<ResultadoPartido?> getResultadoByPartidoId(String partidoId) {
    return _datasource.getResultadoByPartidoId(partidoId);
  }

  @override
  Future<List<ResultadoPartido>> getResultadosByTorneoId(String torneoId) {
    return _datasource.getResultadosByTorneoId(torneoId);
  }
}
