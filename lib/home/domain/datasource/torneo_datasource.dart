import 'package:app_project/home/domain/entities/partido_detalle.dart';
import 'package:app_project/home/domain/entities/tabla_posicion.dart';
import 'package:app_project/home/domain/entities/toneoRegister.dart';
import 'package:app_project/home/domain/entities/torneo.dart';

abstract class TorneoDatasource {
  Future<void> createTorneo(RegisterTorneo registerTorneo);
  Future<Torneo> getTorneo(String id);
  Future<Torneo> updateTorneo(RegisterTorneo registerTorneo, String id);
  Future<Torneo> deleteTorneo(String id);
  Future<List<Torneo>> getTorneos();
  Future<Torneo?> getTorneoByOrganizadorId(String organizadorId);
  Future<void> iniciarCampeonato(String torneoId, List<String> equipoIds);
  Future<List<TablaPosicion>> getTablaPosiciones(String torneoId);
  Future<void> actualizarTablaPosiciones(String torneoId, String equipoGanador,
      String equipoPerdedor, int golesGanador, int golesPerdedor);
  Future<List<PartidoDetalle>> getPartidos(String torneoId);
}
