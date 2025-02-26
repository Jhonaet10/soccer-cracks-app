import 'package:app_project/home/domain/entities/tabla_posicion.dart';
import 'package:app_project/home/domain/repositories/torneo_repository.dart';
import 'package:app_project/home/presentation/providers/torneo_form_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tablaCargadaProvider = StateProvider<bool>((ref) => false);

final tablaPosicionesProvider =
    StateNotifierProvider<TablaPosicionesNotifier, List<TablaPosicion>>((ref) {
  final torneoRepository = ref.watch(torneoRepositoryProvider);
  return TablaPosicionesNotifier(torneoRepository);
});

class TablaPosicionesNotifier extends StateNotifier<List<TablaPosicion>> {
  final TorneoRepository torneoRepository;

  TablaPosicionesNotifier(this.torneoRepository) : super([]);

  Future<void> cargarTabla(String torneoId) async {
    if (torneoId.isEmpty) return;
    final tabla = await torneoRepository.getTablaPosiciones(torneoId);
    state = tabla;
  }

  /// 🔹 Método para actualizar la tabla cuando un partido finaliza
  Future<void> actualizarPosiciones(String torneoId, String equipoGanador,
      String equipoPerdedor, int golesGanador, int golesPerdedor) async {
    if (torneoId.isEmpty) return;
    await torneoRepository.actualizarTablaPosiciones(
        torneoId, equipoGanador, equipoPerdedor, golesGanador, golesPerdedor);
    cargarTabla(torneoId); // Recargar la tabla después de actualizar
  }
}
