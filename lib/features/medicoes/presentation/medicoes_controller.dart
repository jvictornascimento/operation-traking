import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/domain/progresso_fisico.dart';
import '../../servicos/data/servicos_repository.dart';
import '../../servicos/presentation/servicos_controller.dart';
import '../data/medicoes_repository.dart';
import '../domain/medicao.dart';

final medicoesRepositoryProvider = Provider<MedicoesRepository>((ref) {
  return DriftMedicoesRepository(ref.watch(appDatabaseProvider));
});

final medicoesServicoStreamProvider =
    StreamProvider.family.autoDispose<List<Medicao>, String>((ref, servicoId) {
  return ref
      .watch(medicoesRepositoryProvider)
      .watchMedicoesDoServico(servicoId);
});

final medicoesControllerProvider =
    StateNotifierProvider<MedicoesController, AsyncValue<void>>((ref) {
  return MedicoesController(
    medicoesRepository: ref.watch(medicoesRepositoryProvider),
    servicosRepository: ref.watch(servicosRepositoryProvider),
  );
});

class MedicoesController extends StateNotifier<AsyncValue<void>> {
  MedicoesController({
    required MedicoesRepository medicoesRepository,
    required ServicosRepository servicosRepository,
  })  : _medicoesRepository = medicoesRepository,
        _servicosRepository = servicosRepository,
        super(const AsyncData(null));

  final MedicoesRepository _medicoesRepository;
  final ServicosRepository _servicosRepository;

  Future<void> salvar({
    String? id,
    required String servicoId,
    required double percentualExecutado,
    String? observacao,
    required DateTime data,
  }) async {
    final servicoIdNormalizado = servicoId.trim();

    if (servicoIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Servico da medicao e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    if (percentualExecutado < 0 || percentualExecutado > 100) {
      state = AsyncError(
        ArgumentError('Percentual executado deve estar entre 0 e 100.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final dataNormalizada = DateTime(data.year, data.month, data.day);
      await _medicoesRepository.salvarMedicao(
        Medicao(
          id: id ?? _novoId(),
          servicoId: servicoIdNormalizado,
          percentualExecutado: _arredondar(percentualExecutado),
          observacao: _normalizarTextoOpcional(observacao),
          data: dataNormalizada,
        ),
      );

      final medicoes = await _medicoesRepository
          .watchMedicoesDoServico(servicoIdNormalizado)
          .first;
      final progresso = ProgressoFisico.calcularServicoPorMedicoes(medicoes);

      await _servicosRepository.atualizarProgressoFisico(
        id: servicoIdNormalizado,
        progressoFisico: progresso,
      );
    });
  }

  String _novoId() {
    return 'medicao-${DateTime.now().microsecondsSinceEpoch}';
  }

  double _arredondar(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  String? _normalizarTextoOpcional(String? value) {
    final texto = value?.trim();
    if (texto == null || texto.isEmpty) {
      return null;
    }
    return texto;
  }
}
