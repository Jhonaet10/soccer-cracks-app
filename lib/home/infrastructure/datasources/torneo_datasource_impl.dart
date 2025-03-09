import 'package:app_project/home/domain/datasource/torneo_datasource.dart';
import 'package:app_project/home/domain/entities/equipo.dart';
import 'package:app_project/home/domain/entities/jugador.dart';
import 'package:app_project/home/domain/entities/partido.dart';
import 'package:app_project/home/domain/entities/partido_detalle.dart';
import 'package:app_project/home/domain/entities/tabla_posicion.dart';
import 'package:app_project/home/domain/entities/toneoRegister.dart';
import 'package:app_project/home/domain/entities/torneo.dart';
import 'package:app_project/shared/infrastructure/errors/handle_error.dart';
import 'package:app_project/shared/infrastructure/errors/custom_error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:app_project/home/infrastructure/mappers/equipo_mapper.dart';
import 'package:app_project/home/infrastructure/mappers/jugador_mapper.dart';
import 'package:app_project/home/infrastructure/mappers/torneo_mapper.dart';

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
      final jugadoresCollection = _firestore.collection('jugadores');

      // Crear cada equipo y almacenar los IDs
      List<String> equipoIds = [];

      for (var equipo in registerTorneo.equipos) {
        final equipoDoc = equiposCollection.doc();
        List<String> jugadorIds = [];

        // Crear documentos para cada jugador
        for (var jugador in equipo.jugadores) {
          final jugadorDoc = jugadoresCollection.doc();
          await jugadorDoc.set({
            'id': jugadorDoc.id,
            'nombre': jugador.nombre,
            'numero': jugador.numero,
            'equipoId': equipoDoc.id,
            'torneoId': torneoDoc.id,
          });
          jugadorIds.add(jugadorDoc.id);
        }

        // Guardar el equipo con la referencia a sus jugadores
        await equipoDoc.set({
          'id': equipoDoc.id,
          'nombre': equipo.nombre,
          'torneoId': torneoDoc.id,
          'jugadores': jugadorIds,
        });
        equipoIds.add(equipoDoc.id);
      }

      // Guardar el torneo con los IDs de los equipos
      await torneoDoc.set({
        ...registerTorneo.toJson(),
        'id': torneoDoc.id,
        'equipos': equipoIds,
      });

      print('Torneo creado: ${torneoDoc.id}');
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseException(e);
    } on PlatformException catch (e) {
      throw FirebaseErrorHandler.handlePlatformException(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleGenericException(e);
    }
  }

  @override
  Future<Torneo> deleteTorneo(String id) {
    // TODO: implement deleteTorneo
    throw UnimplementedError();
  }

  @override
  Future<Torneo> getTorneo(String id) async {
    try {
      final torneoDoc = await _firestore.collection('torneos').doc(id).get();
      if (!torneoDoc.exists) throw Exception('Torneo no encontrado');

      final torneoData = torneoDoc.data()!;
      final equiposIds = List<String>.from(torneoData['equipos'] ?? []);
      final equipos = await Future.wait(equiposIds.map((equipoId) async {
        final equipoDoc =
            await _firestore.collection('equipos').doc(equipoId).get();
        if (!equipoDoc.exists) return null;

        final equipoData = equipoDoc.data()!;
        final jugadoresIds = List<String>.from(equipoData['jugadores'] ?? []);

        // Obtener los jugadores
        final jugadores = await Future.wait(jugadoresIds.map((jugadorId) async {
          final jugadorDoc =
              await _firestore.collection('jugadores').doc(jugadorId).get();
          if (!jugadorDoc.exists) return null;
          return JugadorMapper.jugadorJsonToEntity(jugadorDoc.data()!);
        }));

        // Filtrar jugadores nulos y crear el equipo
        return EquipoMapper.equipoJsonToEntity({
          ...equipoData,
          'jugadores': jugadores.where((j) => j != null).toList(),
        });
      }));

      // Filtrar equipos nulos
      final equiposValidos = equipos.where((e) => e != null).toList();

      return TorneoMapper.torneoJsonToEntity({
        ...torneoData,
        'equipos': equiposValidos,
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

      // Generar partidos de ida y vuelta
      List<Partido> partidos = [];
      int diasEntreFechas = 7; // Una semana entre cada fecha
      DateTime fechaBase = DateTime.now();

      // Partidos de ida
      for (var i = 0; i < equipoIds.length - 1; i++) {
        for (var j = i + 1; j < equipoIds.length; j++) {
          partidos.add(Partido(
            id: _firestore.collection('partidos').doc().id,
            torneoId: torneoId,
            equipo1: equipoIds[i],
            equipo2: equipoIds[j],
            fecha: fechaBase
                .add(Duration(days: partidos.length * diasEntreFechas)),
          ));
        }
      }

      // Partidos de vuelta (invirtiendo local y visitante)
      int partidosIda = partidos.length;
      for (var i = 0; i < partidosIda; i++) {
        partidos.add(Partido(
          id: _firestore.collection('partidos').doc().id,
          torneoId: torneoId,
          equipo1: partidos[i].equipo2, // Invertimos local y visitante
          equipo2: partidos[i].equipo1,
          fecha: fechaBase
              .add(Duration(days: (partidosIda + i) * diasEntreFechas)),
        ));
      }

      // Guardar los partidos en Firestore
      for (var partido in partidos) {
        await _firestore
            .collection('partidos')
            .doc(partido.id)
            .set(partido.toJson());
      }

      print(
          "Campeonato iniciado correctamente con ${partidos.length} partidos generados.");
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

      // Validación de que el equipo ganador realmente tiene más goles
      if (golesGanador < golesPerdedor) {
        throw Exception(
            "Error en la lógica: El equipo ganador tiene menos goles que el perdedor.");
      }

      // Crear nueva lista con los valores actualizados
      List<TablaPosicion> nuevaTabla = equipos.map((equipo) {
        if (equipo.equipoId == equipoGanador) {
          return equipo.copyWith(
            g: equipo.g + 1, // Suma 1 victoria
            pj: equipo.pj + 1, // Suma 1 partido jugado
            pts: equipo.pts + 3, // Suma 3 puntos por la victoria
            dg: equipo.dg +
                (golesGanador - golesPerdedor), // Diferencia de goles sumada
          );
        } else if (equipo.equipoId == equipoPerdedor) {
          return equipo.copyWith(
            p: equipo.p + 1, // Suma 1 derrota
            pj: equipo.pj + 1, // Suma 1 partido jugado
            dg: equipo.dg -
                (golesGanador -
                    golesPerdedor), // Restamos correctamente la diferencia
          );
        } else {
          return equipo;
        }
      }).toList();

      // Guardar la nueva tabla en Firestore
      await tablaRef.update({
        'equipos': nuevaTabla.map((e) => e.toJson()).toList(),
      });

      print("Tabla de posiciones actualizada correctamente.");
    } catch (e) {
      throw Exception("Error al actualizar la tabla de posiciones: $e");
    }
  }

  @override
  Future<List<PartidoDetalle>> getPartidos(String torneoId) async {
    try {
      final querySnapshot = await _firestore
          .collection('partidos')
          .where('torneoId', isEqualTo: torneoId)
          .get();

      if (querySnapshot.docs.isEmpty) return [];

      // 🔹 Obtener los datos de los partidos
      List<Partido> partidos = querySnapshot.docs
          .map((doc) => Partido.fromJson(doc.data()))
          .toList();

      // 🔹 Obtener los nombres de los equipos desde la colección de equipos
      final equiposSnapshot = await _firestore.collection('equipos').get();
      Map<String, String> equiposMap = {
        for (var doc in equiposSnapshot.docs) doc.id: doc.data()['nombre']
      };

      // 🔹 Convertir `Partido` en `PartidoDetalle` con los nombres de los equipos
      List<PartidoDetalle> partidosDetallados = partidos.map((partido) {
        return PartidoDetalle(
          id: partido.id,
          torneoId: partido.torneoId,
          equipo1: partido.equipo1,
          equipo2: partido.equipo2,
          fecha: partido.fecha,
          resultado: partido.resultado,
          estado: partido.estado,
          equipo1Nombre: equiposMap[partido.equipo1] ?? "Desconocido",
          equipo2Nombre: equiposMap[partido.equipo2] ?? "Desconocido",
        );
      }).toList();

      return partidosDetallados;
    } catch (e) {
      throw Exception("Error al obtener los partidos: $e");
    }
  }

  @override
  Future<Torneo?> getTorneoByCode(String code, String role) async {
    try {
      // Normalizar el código eliminando espacios y guiones
      final normalizedCode = code.replaceAll(RegExp(r'[\s-]'), '');
      print('Código normalizado para búsqueda: $normalizedCode');
      print("Role: $role");
      final querySnapshot = await _firestore
          .collection('torneos')
          .where(
            role == 'Árbitro' ? 'codigoAccesoArbitro' : 'codigoAccesoJugador',
            isEqualTo: normalizedCode,
          )
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No se encontró torneo con el código: $normalizedCode');
        throw CustomError(
            'El código de acceso ingresado no corresponde a ningún torneo activo',
            code: 'invalid-code');
      }

      print('Torneo encontrado con el código proporcionado');
      final torneoDoc = querySnapshot.docs.first;
      final torneoData = torneoDoc.data();
      torneoData['id'] = torneoDoc.id;

      // Obtener los equipos del torneo
      List<Equipo> equipos = [];
      if (torneoData['equipos'] != null && torneoData['equipos'] is List) {
        final equipoIds = List<String>.from(torneoData['equipos']);
        for (String equipoId in equipoIds) {
          final equipoDoc =
              await _firestore.collection('equipos').doc(equipoId).get();
          if (equipoDoc.exists && equipoDoc.data() != null) {
            final equipoData = equipoDoc.data()!;
            equipos.add(Equipo(
              id: equipoDoc.id,
              nombre: equipoData['nombre'] ?? '',
              jugadores: [], // Inicialmente vacío, se puede cargar si es necesario
            ));
          }
        }
      }

      return Torneo(
        id: torneoData['id'],
        estado: torneoData['estado'] ?? 'Sin Empezar',
        nombre: torneoData['nombre'] ?? '',
        formato: torneoData['formato'] ?? '',
        fechaInicio: DateTime.parse(torneoData['fechaInicio']),
        equipos: equipos,
        organizadorId: torneoData['organizadorId'] ?? '',
        codigoAccesoJugador: torneoData['codigoAccesoJugador'] ?? '',
        codigoAccesoArbitro: torneoData['codigoAccesoArbitro'] ?? '',
      );
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseException(e);
    } on PlatformException catch (e) {
      throw FirebaseErrorHandler.handlePlatformException(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleGenericException(e);
    }
  }

  @override
  Future<void> assignTournamentToUser(String userId, String torneoId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      await userRef.update({
        'torneos': FieldValue.arrayUnion([torneoId])
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
  Future<void> registrarResultadoPartido({
    required String partidoId,
    required String resultado,
    required Map<String, dynamic> incidencias,
  }) async {
    try {
      await _firestore.collection('partidos').doc(partidoId).update({
        'resultado': resultado,
        'incidencias': incidencias,
        'estado': 'Finalizado',
      });
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseException(e);
    } on PlatformException catch (e) {
      throw FirebaseErrorHandler.handlePlatformException(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleGenericException(e);
    }
  }
}
