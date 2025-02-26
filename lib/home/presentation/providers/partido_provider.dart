import 'package:app_project/home/domain/entities/partido_detalle.dart';
import 'package:app_project/home/domain/repositories/torneo_repository.dart';
import 'package:app_project/home/presentation/providers/torneo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final partidosProvider =
    StateNotifierProvider<PartidosNotifier, List<PartidoDetalle>>((ref) {
  final torneoRepository = ref.watch(torneoRepositoryProvider);
  final torneoState = ref.watch(torneoProvider);
  final torneoId = torneoState.selectedTorneo?.id;

  return PartidosNotifier(torneoRepository, torneoId);
});

class PartidosNotifier extends StateNotifier<List<PartidoDetalle>> {
  final TorneoRepository torneoRepository;
  final String? torneoId;

  PartidosNotifier(this.torneoRepository, this.torneoId) : super([]) {
    _cargarPartidos();
  }

  Future<void> _cargarPartidos() async {
    if (torneoId == null) return;
    final partidos = await torneoRepository.getPartidos(torneoId!);
    state = partidos;
  }
}
