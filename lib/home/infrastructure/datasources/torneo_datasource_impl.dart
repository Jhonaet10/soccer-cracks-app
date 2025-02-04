import 'package:app_project/home/domain/datasource/torneo_datasource.dart';
import 'package:app_project/home/domain/entities/toneoRegister.dart';
import 'package:app_project/home/domain/entities/torneo.dart';
import 'package:app_project/home/infrastructure/mappers/torneo_mapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TorneoDatasourceImpl implements TorneoDatasource {
  final FirebaseFirestore _firestore;

  TorneoDatasourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createTorneo(RegisterTorneo registerTorneo) async {
    try {
      final torneoDoc = _firestore.collection('torneos').doc();
      final equiposCollection = _firestore.collection('equipos');

      // Crear cada equipo y almacenar los IDs
      List<String> equipoIds = [];

      for (var equipo in registerTorneo.equipos) {
        final equipoDoc = equiposCollection.doc();
        await equipoDoc.set({
          'id': equipoDoc.id,
          'nombre': equipo.nombre,
          'torneoId': torneoDoc.id, // Relacionar equipo con torneo
        });
        equipoIds.add(equipoDoc.id);
      }

      // Guardar el torneo con los IDs de los equipos
      await torneoDoc.set({
        ...registerTorneo.toJson(),
        'id': torneoDoc.id,
        'equipos': equipoIds, // Solo guardamos los IDs de los equipos
      });

      final torneoData = await torneoDoc.get();

      print('Torneo creado: ${torneoData.data()}');

      // Torneo torneo = TorneoMapper.torneoJsonToEntity({
      //   'id': torneoDoc.id,
      //   ...torneoData.data() as Map<String, dynamic>,
      // });
    } catch (e) {
      throw Exception('Error al crear el torneo y los equipos: $e');
    }
  }

  @override
  Future<Torneo> deleteTorneo(String id) {
    // TODO: implement deleteTorneo
    throw UnimplementedError();
  }

  @override
  Future<Torneo> getTorneo(String id) {
    // TODO: implement getTorneo
    throw UnimplementedError();
  }

  @override
  Future<List<Torneo>> getTorneos() {
    // TODO: implement getTorneos
    throw UnimplementedError();
  }

  @override
  Future<Torneo> updateTorneo(RegisterTorneo registerTorneo, String id) {
    // TODO: implement updateTorneo
    throw UnimplementedError();
  }
}
