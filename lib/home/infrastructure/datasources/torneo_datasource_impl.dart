import 'package:app_project/home/domain/datasource/torneo_datasource.dart';
import 'package:app_project/home/domain/entities/equipo.dart';
import 'package:app_project/home/domain/entities/jugador.dart';
import 'package:app_project/home/domain/entities/partido.dart';
import 'package:app_project/home/domain/entities/tabla_posicion.dart';
import 'package:app_project/home/domain/entities/toneoRegister.dart';
import 'package:app_project/home/domain/entities/torneo.dart';
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

  @override
  Future<Torneo?> getTorneoByOrganizadorId(String organizadorId) async {
    try {
      final querySnapshot = await _firestore
          .collection('torneos')
          .where('organizadorId', isEqualTo: organizadorId)
          .limit(1) // Solo obtenemos un torneo
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final torneoData = querySnapshot.docs.first.data();
      torneoData['id'] =
          querySnapshot.docs.first.id; // Asegurar que el ID esté presente

      // Obtener los equipos del torneo
      List<Equipo> equipos = [];

      if (torneoData['equipos'] != null && torneoData['equipos'] is List) {
        for (String equipoId in torneoData['equipos']) {
          final equipoDoc =
              await _firestore.collection('equipos').doc(equipoId).get();
          if (equipoDoc.exists) {
            final equipoData = equipoDoc.data()!;
            List<Jugador> jugadores = [];

            // Obtener jugadores del equipo
            if (equipoData['jugadores'] != null &&
                equipoData['jugadores'] is List) {
              for (String jugadorId in equipoData['jugadores']) {
                final jugadorDoc = await _firestore
                    .collection('jugadores')
                    .doc(jugadorId)
                    .get();
                if (jugadorDoc.exists) {
                  final jugadorData = jugadorDoc.data()!;
                  jugadores.add(Jugador(
                    nombre: jugadorData['nombre'] ?? '',
                    numero: jugadorData['numero'] ?? 0,
                  ));
                }
              }
            }

            equipos.add(Equipo(
              id: equipoDoc.id,
              nombre: equipoData['nombre'] ?? '',
              jugadores: jugadores,
            ));
          }
        }
      }

      // Crear el torneo con equipos y jugadores cargados
      return Torneo(
        id: torneoData['id'],
        estado: torneoData['estado'] ?? 'Sin Empezar',
        nombre: torneoData['nombre'] ?? '',
        formato: torneoData['formato'] ?? '',
        fechaInicio: DateTime.parse(torneoData['fechaInicio']),
        equipos: equipos, // Ahora contiene los equipos con jugadores
        organizadorId: torneoData['organizadorId'] ?? '',
        codigoAccesoJugador: torneoData['codigoAccesoJugador'] ?? '',
        codigoAccesoArbitro: torneoData['codigoAccesoArbitro'] ?? '',
      );
    } catch (e) {
      throw Exception("Error al obtener el torneo del organizador: $e");
    }
  }

  @override
  Future<void> iniciarCampeonato(
      String torneoId, List<String> equipoIds) async {
    try {
      // Cambiar estado del torneo a "En curso"
      await _firestore.collection('torneos').doc(torneoId).update({
        'estado': "En curso",
      });

      // Crear tabla de posiciones
      List<TablaPosicion> tablaPosiciones = equipoIds.map((equipoId) {
        return TablaPosicion(
          equipoId: equipoId,
          pj: 0,
          g: 0,
          e: 0,
          p: 0,
          dg: 0,
          pts: 0,
        );
      }).toList();

      await _firestore.collection('tabla_posiciones').doc(torneoId).set({
        'torneoId': torneoId,
        'equipos': tablaPosiciones.map((e) => e.toJson()).toList(),
      });

      // Generar partidos
      List<Partido> partidos = [];
      for (var i = 0; i < equipoIds.length; i++) {
        for (var j = i + 1; j < equipoIds.length; j++) {
          partidos.add(Partido(
            id: _firestore.collection('partidos').doc().id,
            torneoId: torneoId,
            equipo1: equipoIds[i],
            equipo2: equipoIds[j],
            fecha: DateTime.now().add(Duration(days: i * 3)),
          ));
          partidos.add(Partido(
            id: _firestore.collection('partidos').doc().id,
            torneoId: torneoId,
            equipo1: equipoIds[j],
            equipo2: equipoIds[i],
            fecha: DateTime.now().add(Duration(days: (i * 3) + 7)),
          ));
        }
      }

      // Guardar los partidos en Firestore
      for (var partido in partidos) {
        await _firestore
            .collection('partidos')
            .doc(partido.id)
            .set(partido.toJson());
      }

      print("Campeonato iniciado correctamente.");
    } catch (e) {
      throw Exception("Error al iniciar el campeonato: $e");
    }
  }

  @override
  Future<List<TablaPosicion>> getTablaPosiciones(String torneoId) async {
    try {
      final doc =
          await _firestore.collection('tabla_posiciones').doc(torneoId).get();

      if (!doc.exists) return [];

      final data = doc.data()!;
      final List<TablaPosicion> tabla = (data['equipos'] as List)
          .map((e) => TablaPosicion.fromJson(e))
          .toList();
      print("Tabla de posiciones obtenida");

      // 🔹 Obtener los IDs de los equipos desde el torneo
      final torneoDoc =
          await _firestore.collection('torneos').doc(torneoId).get();
      if (!torneoDoc.exists) return tabla;

      print("Equipos del torneo encontrados");

      final List<String> equipoIds =
          List<String>.from(torneoDoc.data()?['equipos'] ?? []);

      // 🔹 Obtener los nombres de los equipos desde la colección 'equipos'
      final equipoDocs = await _firestore
          .collection('equipos')
          .where(FieldPath.documentId, whereIn: equipoIds)
          .get();

      final Map<String, String> equiposMap = {
        for (var doc in equipoDocs.docs)
          doc.id: doc.data()['nombre'] ?? "Desconocido"
      };

      print("Mapa de equipos creado: $equiposMap");

      // 🔹 Reemplazar equipoId con el nombre real del equipo
      final tablaConNombres = tabla.map((posicion) {
        final nombreEquipo = equiposMap[posicion.equipoId] ?? "Desconocido";
        return posicion.copyWith(nombreEquipo: nombreEquipo);
      }).toList();

      print("Tabla de posiciones actualizada con nombres de equipos");
      return tablaConNombres;
    } catch (e) {
      throw Exception("Error al obtener la tabla de posiciones: $e");
    }
  }

  @override
  Future<void> actualizarTablaPosiciones(String torneoId, String equipoGanador,
      String equipoPerdedor, int golesGanador, int golesPerdedor) async {
    try {
      final tablaRef = _firestore.collection('tabla_posiciones').doc(torneoId);
      final doc = await tablaRef.get();

      if (!doc.exists) {
        throw Exception("No se encontró la tabla de posiciones.");
      }

      List<TablaPosicion> equipos = (doc.data()!['equipos'] as List)
          .map((e) => TablaPosicion.fromJson(e))
          .toList();

      // Crear nueva lista con los valores actualizados
      List<TablaPosicion> nuevaTabla = equipos.map((equipo) {
        if (equipo.equipoId == equipoGanador) {
          return equipo.copyWith(
            g: equipo.g + 1,
            pj: equipo.pj + 1,
            pts: equipo.pts + 3,
            dg: equipo.dg + (golesGanador - golesPerdedor),
          );
        } else if (equipo.equipoId == equipoPerdedor) {
          return equipo.copyWith(
            p: equipo.p + 1,
            pj: equipo.pj + 1,
            dg: equipo.dg + (golesPerdedor - golesGanador),
          );
        } else {
          return equipo;
        }
      }).toList();

      // Guardar la nueva tabla en Firestore
      await tablaRef.update({
        'equipos': nuevaTabla.map((e) => e.toJson()).toList(),
      });

      print("Tabla de posiciones actualizada.");
    } catch (e) {
      throw Exception("Error al actualizar la tabla de posiciones: $e");
    }
  }
}
