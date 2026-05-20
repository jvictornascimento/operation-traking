import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/domain/domain_enums.dart';
import '../../../core/domain/prazo.dart';
import '../data/etapas_repository.dart';
import '../domain/etapa.dart';

final etapasRepositoryProvider = Provider<EtapasRepository>((ref) {
  return DriftEtapasRepository(ref.watch(appDatabaseProvider));
});

final etapasObraStreamProvider =
    StreamProvider.family.autoDispose<List<Etapa>, String>((ref, obraId) {
  return ref.watch(etapasRepositoryProvider).watchEtapasDaObra(obraId);
});

final etapasControllerProvider =
    StateNotifierProvider<EtapasController, AsyncValue<void>>((ref) {
  return EtapasController(ref.watch(etapasRepositoryProvider));
});

class EtapasController extends StateNotifier<AsyncValue<void>> {
  EtapasController(this._repository) : super(const AsyncData(null));

  final EtapasRepository _repository;

  Future<void> salvar({
    String? id,
    required String obraId,
    required String nome,
    required DateTime dataInicio,
    required DateTime dataFim,
    StatusExecucao? status,
    DateTime? dataAtual,
  }) async {
    final obraIdNormalizado = obraId.trim();
    final nomeNormalizado = nome.trim();

    if (obraIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Obra da etapa e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    if (nomeNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Nome da etapa e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    if (dataFim.isBefore(dataInicio)) {
      state = AsyncError(
        ArgumentError('Data final nao pode ser anterior a data inicial.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    final prazoDias = Prazo.calcularDias(
      dataFim: dataFim,
      dataAtual: dataAtual ?? DateTime.now(),
    );
    final statusBase = status ?? StatusExecucao.naoComecou;
    final statusCalculado = Prazo.aplicarStatusAtrasado(
      statusAtual: statusBase,
      progressoPrazoDias: prazoDias,
    );

    state = await AsyncValue.guard(() {
      return _repository.salvarEtapa(
        Etapa(
          id: id ?? _novoId(),
          obraId: obraIdNormalizado,
          nome: nomeNormalizado,
          dataInicio: dataInicio,
          dataFim: dataFim,
          status: statusCalculado,
          progressoFisico: 0,
          progressoPrazoDias: prazoDias,
        ),
      );
    });
  }

  String _novoId() {
    return 'etapa-${DateTime.now().microsecondsSinceEpoch}';
  }
}
