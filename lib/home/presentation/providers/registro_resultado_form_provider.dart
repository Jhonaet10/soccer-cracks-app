import 'package:app_project/home/domain/entities/partido_detalle.dart';
import 'package:app_project/home/domain/repositories/resultado_partido_repository.dart';
import 'package:app_project/home/infrastructure/datasources/resultado_partido_datasource_impl.dart';
import 'package:app_project/home/infrastructure/repositories/resultado_partido_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider del repositorio
final resultadoPartidoRepositoryProvider =
    Provider<ResultadoPartidoRepository>((ref) {
  return ResultadoPartidoRepositoryImpl(ResultadoPartidoDatasourceImpl());
});

// Estado del formulario
class RegistroResultadoFormState {
  final bool isLoading;
  final String errorMessage;
  final String successMessage;
  final int golesEquipo1;
  final int golesEquipo2;
  final int yellowCardsTeam1;
  final int redCardsTeam1;
  final int yellowCardsTeam2;
  final int redCardsTeam2;
  final String observaciones;

  RegistroResultadoFormState({
    this.isLoading = false,
    this.errorMessage = '',
    this.successMessage = '',
    this.golesEquipo1 = 0,
    this.golesEquipo2 = 0,
    this.yellowCardsTeam1 = 0,
    this.redCardsTeam1 = 0,
    this.yellowCardsTeam2 = 0,
    this.redCardsTeam2 = 0,
    this.observaciones = '',
  });

  bool get isValid {
    return golesEquipo1 >= 0 && golesEquipo2 >= 0;
  }

  RegistroResultadoFormState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    int? golesEquipo1,
    int? golesEquipo2,
    int? yellowCardsTeam1,
    int? redCardsTeam1,
    int? yellowCardsTeam2,
    int? redCardsTeam2,
    String? observaciones,
  }) {
    return RegistroResultadoFormState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      golesEquipo1: golesEquipo1 ?? this.golesEquipo1,
      golesEquipo2: golesEquipo2 ?? this.golesEquipo2,
      yellowCardsTeam1: yellowCardsTeam1 ?? this.yellowCardsTeam1,
      redCardsTeam1: redCardsTeam1 ?? this.redCardsTeam1,
      yellowCardsTeam2: yellowCardsTeam2 ?? this.yellowCardsTeam2,
      redCardsTeam2: redCardsTeam2 ?? this.redCardsTeam2,
      observaciones: observaciones ?? this.observaciones,
    );
  }
}

// Provider del formulario
final registroResultadoFormProvider = StateNotifierProvider.autoDispose<
    RegistroResultadoFormNotifier, RegistroResultadoFormState>((ref) {
  final repository = ref.watch(resultadoPartidoRepositoryProvider);
  return RegistroResultadoFormNotifier(repository);
});

class RegistroResultadoFormNotifier
    extends StateNotifier<RegistroResultadoFormState> {
  final ResultadoPartidoRepository _repository;

  RegistroResultadoFormNotifier(this._repository)
      : super(RegistroResultadoFormState());

  void updateGolesEquipo1(String value) {
    final goles = int.tryParse(value) ?? 0;
    state = state.copyWith(golesEquipo1: goles);
  }

  void updateGolesEquipo2(String value) {
    final goles = int.tryParse(value) ?? 0;
    state = state.copyWith(golesEquipo2: goles);
  }

  void incrementYellowCardsTeam1() {
    state = state.copyWith(yellowCardsTeam1: state.yellowCardsTeam1 + 1);
  }

  void decrementYellowCardsTeam1() {
    if (state.yellowCardsTeam1 > 0) {
      state = state.copyWith(yellowCardsTeam1: state.yellowCardsTeam1 - 1);
    }
  }

  void incrementRedCardsTeam1() {
    state = state.copyWith(redCardsTeam1: state.redCardsTeam1 + 1);
  }

  void decrementRedCardsTeam1() {
    if (state.redCardsTeam1 > 0) {
      state = state.copyWith(redCardsTeam1: state.redCardsTeam1 - 1);
    }
  }

  void incrementYellowCardsTeam2() {
    state = state.copyWith(yellowCardsTeam2: state.yellowCardsTeam2 + 1);
  }

  void decrementYellowCardsTeam2() {
    if (state.yellowCardsTeam2 > 0) {
      state = state.copyWith(yellowCardsTeam2: state.yellowCardsTeam2 - 1);
    }
  }

  void incrementRedCardsTeam2() {
    state = state.copyWith(redCardsTeam2: state.redCardsTeam2 + 1);
  }

  void decrementRedCardsTeam2() {
    if (state.redCardsTeam2 > 0) {
      state = state.copyWith(redCardsTeam2: state.redCardsTeam2 - 1);
    }
  }

  void updateObservaciones(String value) {
    state = state.copyWith(observaciones: value);
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: '', successMessage: '');
  }

  Future<bool> submitResultado(PartidoDetalle partido) async {
    if (!state.isValid) return false;

    try {
      state =
          state.copyWith(isLoading: true, errorMessage: '', successMessage: '');

      await _repository.registrarResultado(
        partidoId: partido.id,
        torneoId: partido.torneoId,
        equipo1Id: partido.equipo1,
        equipo2Id: partido.equipo2,
        golesEquipo1: state.golesEquipo1,
        golesEquipo2: state.golesEquipo2,
        incidencias: {
          'tarjetasAmarillasEquipo1': state.yellowCardsTeam1,
          'tarjetasRojasEquipo1': state.redCardsTeam1,
          'tarjetasAmarillasEquipo2': state.yellowCardsTeam2,
          'tarjetasRojasEquipo2': state.redCardsTeam2,
          'observaciones': state.observaciones,
        },
      );

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Resultado registrado exitosamente',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
