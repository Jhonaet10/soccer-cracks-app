import 'package:app_project/home/domain/datasource/torneo_datasource.dart';
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
  Future<Torneo> getTorneo(String id) {
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
}
