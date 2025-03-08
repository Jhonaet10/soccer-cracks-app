import 'package:app_project/home/domain/datasource/torneo_datasource.dart';
import 'package:app_project/home/domain/entities/partido_detalle.dart';
import 'package:app_project/home/domain/entities/tabla_posicion.dart';
import 'package:app_project/home/domain/entities/toneoRegister.dart';
import 'package:app_project/home/domain/entities/torneo.dart';
import 'package:app_project/home/domain/repositories/torneo_repository.dart';
import 'package:app_project/home/infrastructure/datasources/torneo_datasource_impl.dart';

class TorneoRepositoryImpl implements TorneoRepository {
  final TorneoDatasource datasource;

  TorneoRepositoryImpl({TorneoDatasource? datasource})
      : datasource = datasource ?? TorneoDatasourceImpl();

  @override
  Future<void> createTorneo(RegisterTorneo registerTorneo) {
    return datasource.createTorneo(registerTorneo);
  }

  @override
  Future<Torneo> deleteTorneo(String id) {
    return datasource.deleteTorneo(id);
  }

  @override
  Future<Torneo?> getTorneo(String id) {
    return datasource.getTorneo(id);
  }

  @override
  Future<List<Torneo>> getTorneos() {
    return datasource.getTorneos();
  }

  @override
  Future<Torneo> updateTorneo(RegisterTorneo registerTorneo, String id) {
    return datasource.updateTorneo(registerTorneo, id);
  }

  @override
  Future<Torneo?> getTorneoByOrganizadorId(String organizadorId) {
    return datasource.getTorneoByOrganizadorId(organizadorId);
  }

  @override
  Future<void> iniciarCampeonato(String torneoId, List<String> equipoIds) {
    return datasource.iniciarCampeonato(torneoId, equipoIds);
  }

  @override
  Future<List<TablaPosicion>> getTablaPosiciones(String torneoId) {
    return datasource.getTablaPosiciones(torneoId);
  }

  @override
  Future<void> actualizarTablaPosiciones(String torneoId, String equipoGanador,
      String equipoPerdedor, int golesGanador, int golesPerdedor) {
    return datasource.actualizarTablaPosiciones(
        torneoId, equipoGanador, equipoPerdedor, golesGanador, golesPerdedor);
  }

  @override
  Future<List<PartidoDetalle>> getPartidos(String torneoId) {
    return datasource.getPartidos(torneoId);
  }

  @override
  Future<void> assignTournamentToUser(String userId, String tournamentId) {
    return datasource.assignTournamentToUser(userId, tournamentId);
  }

  @override
  Future<Torneo?> getTorneoByCode(String code, String role) {
    return datasource.getTorneoByCode(code, role);
  }

  @override
  Future<void> registrarResultadoPartido({
    required String partidoId,
    required String resultado,
    required Map<String, dynamic> incidencias,
  }) async {
    try {
      await datasource.registrarResultadoPartido(
        partidoId: partidoId,
        resultado: resultado,
        incidencias: incidencias,
      );
    } catch (e) {
      throw Exception('Error al registrar el resultado del partido: $e');
    }
  }
}
