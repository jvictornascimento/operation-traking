import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/domain/progresso_fisico.dart';
import '../../servicos/data/servicos_repository.dart';
import '../../servicos/presentation/servicos_controller.dart';
import '../data/fotos_medicao_repository.dart';
import '../data/fotos_medicao_storage.dart';
import '../domain/foto_medicao.dart';
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

final medicoesFiscalizacaoStreamProvider =
    StreamProvider.family.autoDispose<List<Medicao>, String>(
  (ref, vistoriaServicoId) {
    return ref
        .watch(medicoesRepositoryProvider)
        .watchMedicoesDaFiscalizacao(vistoriaServicoId);
  },
);

final medicoesControllerProvider =
    StateNotifierProvider<MedicoesController, AsyncValue<void>>((ref) {
  return MedicoesController(
    medicoesRepository: ref.watch(medicoesRepositoryProvider),
    servicosRepository: ref.watch(servicosRepositoryProvider),
  );
});

final fotosMedicaoRepositoryProvider = Provider<FotosMedicaoRepository>((ref) {
  return DriftFotosMedicaoRepository(ref.watch(appDatabaseProvider));
});

final fotosMedicaoStorageProvider = Provider<FotosMedicaoStorage>((ref) {
  return const LocalFotosMedicaoStorage();
});

final fotosMedicaoStreamProvider =
    StreamProvider.family.autoDispose<List<FotoMedicao>, String>(
  (ref, medicaoId) {
    return ref.watch(fotosMedicaoRepositoryProvider).watchFotosDaMedicao(
          medicaoId,
        );
  },
);

final fotosMedicaoControllerProvider =
    StateNotifierProvider<FotosMedicaoController, AsyncValue<void>>((ref) {
  return FotosMedicaoController(
    repository: ref.watch(fotosMedicaoRepositoryProvider),
    storage: ref.watch(fotosMedicaoStorageProvider),
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
          vistoriaServicoId: null,
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

  Future<void> salvarDaFiscalizacao({
    String? id,
    required String vistoriaServicoId,
    required double percentualExecutado,
    String? observacao,
    required DateTime data,
  }) async {
    final vistoriaServicoIdNormalizado = vistoriaServicoId.trim();

    if (vistoriaServicoIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Fiscalizacao da medicao e obrigatoria.'),
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
      final servicoId = await _medicoesRepository.buscarServicoIdDaFiscalizacao(
        vistoriaServicoIdNormalizado,
      );

      if (servicoId == null) {
        throw ArgumentError('Fiscalizacao da medicao nao encontrada.');
      }

      final dataNormalizada = DateTime(data.year, data.month, data.day);
      await _medicoesRepository.salvarMedicao(
        Medicao(
          id: id ?? _novoId(),
          servicoId: servicoId,
          vistoriaServicoId: vistoriaServicoIdNormalizado,
          percentualExecutado: _arredondar(percentualExecutado),
          observacao: _normalizarTextoOpcional(observacao),
          data: dataNormalizada,
        ),
      );

      final medicoes =
          await _medicoesRepository.watchMedicoesDoServico(servicoId).first;
      final progresso = ProgressoFisico.calcularServicoPorMedicoes(medicoes);

      await _servicosRepository.atualizarProgressoFisico(
        id: servicoId,
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

class FotosMedicaoController extends StateNotifier<AsyncValue<void>> {
  FotosMedicaoController({
    required FotosMedicaoRepository repository,
    required FotosMedicaoStorage storage,
  })  : _repository = repository,
        _storage = storage,
        super(const AsyncData(null));

  final FotosMedicaoRepository _repository;
  final FotosMedicaoStorage _storage;

  Future<void> salvarArquivo({
    required String medicaoId,
    required String caminhoOrigem,
  }) async {
    final medicaoIdNormalizado = medicaoId.trim();
    final caminhoOrigemNormalizado = caminhoOrigem.trim();

    if (medicaoIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Medicao da foto e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    if (caminhoOrigemNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Arquivo da foto e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final caminhoArquivo = await _storage.salvarFotoMedicao(
        medicaoId: medicaoIdNormalizado,
        caminhoOrigem: caminhoOrigemNormalizado,
      );

      await _repository.salvarFoto(
        FotoMedicao(
          id: _novoId(),
          medicaoId: medicaoIdNormalizado,
          caminhoArquivo: caminhoArquivo,
        ),
      );
    });
  }

  Future<void> remover(String id) async {
    final idNormalizado = id.trim();

    if (idNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Foto da medicao e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _repository.removerFoto(idNormalizado);
    });
  }

  String _novoId() {
    return 'foto-${DateTime.now().microsecondsSinceEpoch}';
  }
}
