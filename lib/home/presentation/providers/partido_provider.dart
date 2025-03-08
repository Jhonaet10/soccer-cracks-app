import 'package:app_project/home/domain/entities/partido_detalle.dart';
import 'package:app_project/home/domain/repositories/torneo_repository.dart';
import 'package:app_project/home/infrastructure/repositories/torneo_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final torneoRepositoryProvider = Provider<TorneoRepository>((ref) {
  return TorneoRepositoryImpl();
});

final partidosProvider =
    StateNotifierProvider<PartidosNotifier, List<PartidoDetalle>>((ref) {
  final torneoRepository = ref.watch(torneoRepositoryProvider);
  return PartidosNotifier(torneoRepository);
});

class PartidosNotifier extends StateNotifier<List<PartidoDetalle>> {
  final TorneoRepository _torneoRepository;

  PartidosNotifier(this._torneoRepository) : super([]);

  Future<void> cargarPartidos(String torneoId) async {
    try {
      final partidos = await _torneoRepository.getPartidos(torneoId);
      state = partidos;
    } catch (e) {
      throw Exception('Error al cargar los partidos: $e');
    }
  }

  Future<void> registrarResultado({
    required String partidoId,
    required String resultado,
    required Map<String, dynamic> incidencias,
  }) async {
    try {
      // Registrar el resultado en el repositorio
      await _torneoRepository.registrarResultadoPartido(
        partidoId: partidoId,
        resultado: resultado,
        incidencias: incidencias,
      );

      // Actualizar el estado local
      state = state.map((partido) {
        if (partido.id == partidoId) {
          return partido.copyWith(
            resultado: resultado,
            estado: 'Finalizado',
            incidencias: incidencias,
          );
        }
        return partido;
      }).toList();
    } catch (e) {
      throw Exception('Error al registrar el resultado: $e');
    }
  }
}
