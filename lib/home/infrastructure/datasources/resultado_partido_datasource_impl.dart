import 'package:app_project/home/domain/datasource/resultado_partido_datasource.dart';
import 'package:app_project/home/domain/entities/resultado_partido.dart';
import 'package:app_project/shared/infrastructure/errors/handle_error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ResultadoPartidoDatasourceImpl implements ResultadoPartidoDatasource {
  final FirebaseFirestore _firestore;

  ResultadoPartidoDatasourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<ResultadoPartido> registrarResultado({
    required String partidoId,
    required String torneoId,
    required String equipo1Id,
    required String equipo2Id,
    required int golesEquipo1,
    required int golesEquipo2,
    required Map<String, dynamic> incidencias,
  }) async {
    try {
      final resultadoDoc = _firestore.collection('resultado_partidos').doc();

      final resultado = ResultadoPartido(
        id: resultadoDoc.id,
        partidoId: partidoId,
        torneoId: torneoId,
        equipo1Id: equipo1Id,
        equipo2Id: equipo2Id,
        golesEquipo1: golesEquipo1,
        golesEquipo2: golesEquipo2,
        incidencias: incidencias,
        fechaRegistro: DateTime.now(),
      );

      await resultadoDoc.set(resultado.toJson());

      // Actualizar el estado del partido
      await _firestore.collection('partidos').doc(partidoId).update(
          {'resultado': '$golesEquipo1-$golesEquipo2', 'estado': 'Finalizado'});

      return resultado;
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseException(e);
    } on PlatformException catch (e) {
      throw FirebaseErrorHandler.handlePlatformException(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleGenericException(e);
    }
  }

  @override
  Future<ResultadoPartido?> getResultadoByPartidoId(String partidoId) async {
    try {
      final querySnapshot = await _firestore
          .collection('resultado_partidos')
          .where('partidoId', isEqualTo: partidoId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      return ResultadoPartido.fromJson({
        'id': doc.id,
        ...doc.data(),
      });
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseException(e);
    } on PlatformException catch (e) {
      throw FirebaseErrorHandler.handlePlatformException(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleGenericException(e);
    }
  }

  @override
  Future<List<ResultadoPartido>> getResultadosByTorneoId(
      String torneoId) async {
    try {
      final querySnapshot = await _firestore
          .collection('resultado_partidos')
          .where('torneoId', isEqualTo: torneoId)
          .get();

      return querySnapshot.docs
          .map((doc) => ResultadoPartido.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseException(e);
    } on PlatformException catch (e) {
      throw FirebaseErrorHandler.handlePlatformException(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleGenericException(e);
    }
  }
}
