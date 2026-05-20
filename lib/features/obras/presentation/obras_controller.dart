import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/domain/domain_enums.dart';
import '../../../core/domain/prazo.dart';
import '../data/obras_repository.dart';
import '../domain/obra.dart';

final obrasRepositoryProvider = Provider<ObrasRepository>((ref) {
  return DriftObrasRepository(ref.watch(appDatabaseProvider));
});

final obrasStreamProvider = StreamProvider<List<Obra>>((ref) {
  return ref.watch(obrasRepositoryProvider).watchObras();
});

final obrasControllerProvider =
    StateNotifierProvider<ObrasController, AsyncValue<void>>((ref) {
  return ObrasController(ref.watch(obrasRepositoryProvider));
});

class ObrasController extends StateNotifier<AsyncValue<void>> {
  ObrasController(this._repository) : super(const AsyncData(null));

  final ObrasRepository _repository;

  Future<void> salvar({
    String? id,
    required String empresaId,
    required String enderecoId,
    required String nome,
    required DateTime dataInicio,
    required DateTime dataFim,
    StatusExecucao? status,
    DateTime? dataAtual,
  }) async {
    final empresaIdNormalizado = empresaId.trim();
    final enderecoIdNormalizado = enderecoId.trim();
    final nomeNormalizado = nome.trim();

    if (empresaIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Empresa da obra e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    if (enderecoIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Endereco da obra e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    if (nomeNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Nome da obra e obrigatorio.'),
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
      return _repository.salvarObra(
        Obra(
          id: id ?? _novoId(),
          empresaId: empresaIdNormalizado,
          enderecoId: enderecoIdNormalizado,
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
    return 'obra-${DateTime.now().microsecondsSinceEpoch}';
  }
}
