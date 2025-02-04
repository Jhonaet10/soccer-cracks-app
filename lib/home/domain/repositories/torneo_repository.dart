import 'package:app_project/home/domain/entities/toneoRegister.dart';
import 'package:app_project/home/domain/entities/torneo.dart';

abstract class TorneoRepository {
  Future<void> createTorneo(RegisterTorneo registerTorneo);
  Future<Torneo> getTorneo(String id);
  Future<Torneo> updateTorneo(RegisterTorneo registerTorneo, String id);
  Future<Torneo> deleteTorneo(String id);
  Future<List<Torneo>> getTorneos();
}
