import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/domain/domain_enums.dart';
import '../../cadastros/domain/funcionario.dart';
import '../data/vistorias_mao_de_obra_repository.dart';
import '../data/vistorias_periodo_repository.dart';
import '../data/vistorias_servico_repository.dart';
import '../domain/vistoria_mao_de_obra.dart';
import '../domain/vistoria_periodo.dart';
import '../domain/vistoria_servico.dart';

final vistoriasServicoRepositoryProvider =
    Provider<VistoriasServicoRepository>((ref) {
  return DriftVistoriasServicoRepository(ref.watch(appDatabaseProvider));
});

final vistoriasServicoStreamProvider =
    StreamProvider.family.autoDispose<List<VistoriaServico>, String>(
  (ref, servicoId) {
    return ref
        .watch(vistoriasServicoRepositoryProvider)
        .watchVistoriasDoServico(servicoId);
  },
);

final fiscalizacoesControllerProvider =
    StateNotifierProvider<FiscalizacoesController, AsyncValue<void>>((ref) {
  return FiscalizacoesController(ref.watch(vistoriasServicoRepositoryProvider));
});

final vistoriasPeriodoRepositoryProvider =
    Provider<VistoriasPeriodoRepository>((ref) {
  return DriftVistoriasPeriodoRepository(ref.watch(appDatabaseProvider));
});

final periodosVistoriaStreamProvider =
    StreamProvider.family.autoDispose<List<VistoriaPeriodo>, String>(
  (ref, vistoriaServicoId) {
    return ref
        .watch(vistoriasPeriodoRepositoryProvider)
        .watchPeriodosDaVistoria(vistoriaServicoId);
  },
);

final periodosFiscalizacaoControllerProvider =
    StateNotifierProvider<PeriodosFiscalizacaoController, AsyncValue<void>>(
  (ref) {
    return PeriodosFiscalizacaoController(
      ref.watch(vistoriasPeriodoRepositoryProvider),
    );
  },
);

final vistoriasMaoDeObraRepositoryProvider =
    Provider<VistoriasMaoDeObraRepository>((ref) {
  return DriftVistoriasMaoDeObraRepository(ref.watch(appDatabaseProvider));
});

final maoDeObraVistoriaStreamProvider =
    StreamProvider.family.autoDispose<List<VistoriaMaoDeObra>, String>(
  (ref, vistoriaServicoId) {
    return ref
        .watch(vistoriasMaoDeObraRepositoryProvider)
        .watchMaoDeObraDaVistoria(vistoriaServicoId);
  },
);

final funcionariosMaoDeObraDisponiveisStreamProvider =
    StreamProvider.family.autoDispose<List<Funcionario>, String>(
  (ref, String vistoriaServicoId) {
    return ref
        .watch(vistoriasMaoDeObraRepositoryProvider)
        .watchFuncionariosDaEmpresaDaVistoria(vistoriaServicoId);
  },
);

final maoDeObraFiscalizacaoControllerProvider =
    StateNotifierProvider<MaoDeObraFiscalizacaoController, AsyncValue<void>>(
  (ref) {
    return MaoDeObraFiscalizacaoController(
      ref.watch(vistoriasMaoDeObraRepositoryProvider),
    );
  },
);

class FiscalizacoesController extends StateNotifier<AsyncValue<void>> {
  FiscalizacoesController(this._repository) : super(const AsyncData(null));

  final VistoriasServicoRepository _repository;

  Future<void> salvar({
    String? id,
    required String servicoId,
    required String obraId,
    required String contratanteId,
    required String responsavelId,
    String? numero,
    required DateTime data,
    StatusFiscalizacao? status,
    String? ocorrencia,
    String? comentario,
  }) async {
    final servicoIdNormalizado = servicoId.trim();
    final obraIdNormalizado = obraId.trim();
    final contratanteIdNormalizado = contratanteId.trim();
    final responsavelIdNormalizado = responsavelId.trim();
    final numeroNormalizado = _normalizarTextoOpcional(numero);

    if (servicoIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Servico da fiscalizacao e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    if (obraIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Obra da fiscalizacao e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    if (contratanteIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Contratante da fiscalizacao e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    if (responsavelIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Responsavel da fiscalizacao e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    final dataNormalizada = DateTime(data.year, data.month, data.day);
    final idFinal = id ?? _novoId();

    state = await AsyncValue.guard(() {
      return _repository.salvarVistoria(
        VistoriaServico(
          id: idFinal,
          servicoId: servicoIdNormalizado,
          obraId: obraIdNormalizado,
          contratanteId: contratanteIdNormalizado,
          responsavelId: responsavelIdNormalizado,
          numero: numeroNormalizado ?? _novoNumero(dataNormalizada),
          data: dataNormalizada,
          diaSemana: dataNormalizada.weekday,
          status: status ?? StatusFiscalizacao.emAndamento,
          ocorrencia: _normalizarTextoOpcional(ocorrencia),
          comentario: _normalizarTextoOpcional(comentario),
        ),
      );
    });
  }

  String _novoId() {
    return 'vistoria-${DateTime.now().microsecondsSinceEpoch}';
  }

  String _novoNumero(DateTime data) {
    final ano = data.year.toString().padLeft(4, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final dia = data.day.toString().padLeft(2, '0');
    final micros = DateTime.now().microsecondsSinceEpoch;
    return 'VS-$ano$mes$dia-$micros';
  }

  String? _normalizarTextoOpcional(String? value) {
    final texto = value?.trim();
    if (texto == null || texto.isEmpty) {
      return null;
    }
    return texto;
  }
}

class PeriodosFiscalizacaoController extends StateNotifier<AsyncValue<void>> {
  PeriodosFiscalizacaoController(this._repository)
      : super(const AsyncData(null));

  final VistoriasPeriodoRepository _repository;

  Future<void> salvar({
    String? id,
    required String vistoriaServicoId,
    required PeriodoDia periodo,
    required TempoPeriodo tempo,
    required CondicaoPeriodo condicao,
  }) async {
    final vistoriaServicoIdNormalizado = vistoriaServicoId.trim();

    if (vistoriaServicoIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Fiscalizacao do periodo e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _repository.salvarPeriodo(
        VistoriaPeriodo(
          id: id ?? _novoId(),
          vistoriaServicoId: vistoriaServicoIdNormalizado,
          periodo: periodo,
          tempo: tempo,
          condicao: condicao,
        ),
      );
    });
  }

  Future<void> remover({
    required String vistoriaServicoId,
    required PeriodoDia periodo,
  }) async {
    final vistoriaServicoIdNormalizado = vistoriaServicoId.trim();

    if (vistoriaServicoIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Fiscalizacao do periodo e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _repository.removerPeriodo(
        vistoriaServicoId: vistoriaServicoIdNormalizado,
        periodo: periodo,
      );
    });
  }

  String _novoId() {
    return 'periodo-${DateTime.now().microsecondsSinceEpoch}';
  }
}

class MaoDeObraFiscalizacaoController extends StateNotifier<AsyncValue<void>> {
  MaoDeObraFiscalizacaoController(this._repository)
      : super(const AsyncData(null));

  final VistoriasMaoDeObraRepository _repository;

  Future<void> salvar({
    String? id,
    required String vistoriaServicoId,
    required String funcionarioId,
    String? funcaoNoDia,
    String? observacao,
  }) async {
    final vistoriaServicoIdNormalizado = vistoriaServicoId.trim();
    final funcionarioIdNormalizado = funcionarioId.trim();

    if (vistoriaServicoIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Fiscalizacao da mao de obra e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    if (funcionarioIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Funcionario da mao de obra e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _repository.salvarMaoDeObra(
        VistoriaMaoDeObra(
          id: id ?? _novoId(),
          vistoriaServicoId: vistoriaServicoIdNormalizado,
          funcionarioId: funcionarioIdNormalizado,
          funcaoNoDia: _normalizarTextoOpcional(funcaoNoDia),
          observacao: _normalizarTextoOpcional(observacao),
        ),
      );
    });
  }

  Future<void> remover(String id) async {
    final idNormalizado = id.trim();

    if (idNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Mao de obra da fiscalizacao e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _repository.removerMaoDeObra(idNormalizado);
    });
  }

  String _novoId() {
    return 'mao-obra-${DateTime.now().microsecondsSinceEpoch}';
  }

  String? _normalizarTextoOpcional(String? value) {
    final texto = value?.trim();
    if (texto == null || texto.isEmpty) {
      return null;
    }
    return texto;
  }
}
