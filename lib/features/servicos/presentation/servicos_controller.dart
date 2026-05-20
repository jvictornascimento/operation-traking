import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/domain/domain_enums.dart';
import '../../../core/domain/prazo.dart';
import '../data/servicos_repository.dart';
import '../domain/servico.dart';

final servicosRepositoryProvider = Provider<ServicosRepository>((ref) {
  return DriftServicosRepository(ref.watch(appDatabaseProvider));
});

final servicosEtapaStreamProvider =
    StreamProvider.family.autoDispose<List<Servico>, String>((ref, etapaId) {
  return ref.watch(servicosRepositoryProvider).watchServicosDaEtapa(etapaId);
});

final servicosControllerProvider =
    StateNotifierProvider<ServicosController, AsyncValue<void>>((ref) {
  return ServicosController(ref.watch(servicosRepositoryProvider));
});

class ServicosController extends StateNotifier<AsyncValue<void>> {
  ServicosController(this._repository) : super(const AsyncData(null));

  final ServicosRepository _repository;

  Future<void> salvar({
    String? id,
    required String etapaId,
    required String nome,
    required double precoTotal,
    required String unidade,
    required double quantidade,
    required DateTime dataInicio,
    required DateTime dataFim,
    StatusExecucao? status,
    DateTime? dataAtual,
  }) async {
    final etapaIdNormalizado = etapaId.trim();
    final nomeNormalizado = nome.trim();
    final unidadeNormalizada = unidade.trim();

    if (etapaIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Etapa do servico e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    if (nomeNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Nome do servico e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    if (unidadeNormalizada.isEmpty) {
      state = AsyncError(
        ArgumentError('Unidade do servico e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    if (precoTotal < 0 || quantidade < 0) {
      state = AsyncError(
        ArgumentError('Preco total e quantidade nao podem ser negativos.'),
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
      return _repository.salvarServico(
        Servico(
          id: id ?? _novoId(),
          etapaId: etapaIdNormalizado,
          nome: nomeNormalizado,
          precoTotal: precoTotal,
          unidade: unidadeNormalizada,
          quantidade: quantidade,
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
    return 'servico-${DateTime.now().microsecondsSinceEpoch}';
  }
}
