import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/domain/domain_enums.dart';
import '../../cadastros/domain/funcionario.dart';
import '../data/fotos_fiscalizacao_repository.dart';
import '../data/fotos_fiscalizacao_storage.dart';
import '../data/vistorias_mao_de_obra_repository.dart';
import '../data/vistorias_periodo_repository.dart';
import '../data/vistorias_servico_repository.dart';
import '../domain/foto_fiscalizacao.dart';
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

final vistoriasEtapaStreamProvider =
    StreamProvider.family.autoDispose<List<VistoriaServico>, String>(
  (ref, etapaId) {
    final repository = ref.watch(vistoriasServicoRepositoryProvider);
    if (repository is DriftVistoriasServicoRepository) {
      return repository.watchVistoriasDaEtapa(etapaId);
    }

    return repository.watchFiscalizacoes();
  },
);

final fiscalizacoesFiltroStreamProvider = StreamProvider.family
    .autoDispose<List<VistoriaServico>, FiscalizacoesFiltro>(
  (ref, filtro) {
    final repository = ref.watch(vistoriasServicoRepositoryProvider);
    final etapaId = filtro.etapaId?.trim();
    if (etapaId != null && etapaId.isNotEmpty) {
      if (repository is DriftVistoriasServicoRepository) {
        return repository.watchVistoriasDaEtapa(etapaId);
      }

      return repository.watchFiscalizacoes();
    }

    return repository.watchFiscalizacoes(
      servicoId: filtro.servicoId,
      numero: filtro.numero,
      status: filtro.status,
      data: filtro.data,
    );
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

final empresaIdDaVistoriaProvider = FutureProvider.family
    .autoDispose<String?, String>((ref, vistoriaServicoId) {
  return ref
      .watch(vistoriasMaoDeObraRepositoryProvider)
      .buscarEmpresaIdDaVistoria(vistoriaServicoId);
});

final maoDeObraFiscalizacaoControllerProvider =
    StateNotifierProvider<MaoDeObraFiscalizacaoController, AsyncValue<void>>(
  (ref) {
    return MaoDeObraFiscalizacaoController(
      ref.watch(vistoriasMaoDeObraRepositoryProvider),
    );
  },
);

final fotosFiscalizacaoRepositoryProvider =
    Provider<FotosFiscalizacaoRepository>((ref) {
  return DriftFotosFiscalizacaoRepository(ref.watch(appDatabaseProvider));
});

final fotosFiscalizacaoStorageProvider = Provider<FotosFiscalizacaoStorage>(
  (ref) => const LocalFotosFiscalizacaoStorage(),
);

final fotosFiscalizacaoStreamProvider =
    StreamProvider.family.autoDispose<List<FotoFiscalizacao>, String>(
  (ref, vistoriaServicoId) {
    return ref
        .watch(fotosFiscalizacaoRepositoryProvider)
        .watchFotosDaFiscalizacao(vistoriaServicoId);
  },
);

final fotosFiscalizacaoControllerProvider =
    StateNotifierProvider<FotosFiscalizacaoController, AsyncValue<void>>(
  (ref) {
    return FotosFiscalizacaoController(
      repository: ref.watch(fotosFiscalizacaoRepositoryProvider),
      storage: ref.watch(fotosFiscalizacaoStorageProvider),
    );
  },
);

class FiscalizacoesFiltro {
  const FiscalizacoesFiltro({
    this.etapaId,
    this.servicoId,
    this.numero,
    this.status,
    this.data,
  });

  final String? etapaId;
  final String? servicoId;
  final String? numero;
  final StatusFiscalizacao? status;
  final DateTime? data;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FiscalizacoesFiltro &&
            other.servicoId == servicoId &&
            other.etapaId == etapaId &&
            other.numero == numero &&
            other.status == status &&
            other.data == data;
  }

  @override
  int get hashCode => Object.hash(etapaId, servicoId, numero, status, data);
}

class FiscalizacoesController extends StateNotifier<AsyncValue<void>> {
  FiscalizacoesController(this._repository) : super(const AsyncData(null));

  final VistoriasServicoRepository _repository;

  Future<void> salvar({
    String? id,
    String? etapaId,
    String? servicoId,
    String? obraId,
    String? contratanteId,
    String? responsavelId,
    String? numero,
    required DateTime data,
    StatusFiscalizacao? status,
    String? atividade,
    String? ocorrencia,
    String? comentario,
  }) async {
    final etapaIdNormalizado = _normalizarTextoOpcional(etapaId);
    final servicoIdNormalizado = _normalizarTextoOpcional(servicoId);
    final numeroNormalizado = _normalizarTextoOpcional(numero);

    if (etapaIdNormalizado == null && servicoIdNormalizado == null) {
      state = AsyncError(
        ArgumentError('Etapa da fiscalizacao e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    ContextoFiscalizacaoServico? contexto;
    try {
      contexto = etapaIdNormalizado != null
          ? _repository is DriftVistoriasServicoRepository
              ? await _repository.buscarContextoDaEtapa(etapaIdNormalizado)
              : await _repository.buscarContextoDoServico(etapaIdNormalizado)
          : await _repository.buscarContextoDoServico(servicoIdNormalizado!);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return;
    }

    final obraIdNormalizado =
        _normalizarTextoOpcional(obraId) ?? contexto?.obraId;
    final contratanteIdNormalizado =
        _normalizarTextoOpcional(contratanteId) ?? contexto?.contratanteId;
    final responsavelIdNormalizado =
        _normalizarTextoOpcional(responsavelId) ?? contexto?.responsavelId;

    if (obraIdNormalizado == null || obraIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError(
          'Nao foi possivel iniciar a fiscalizacao: nao encontrei a obra da '
          'etapa. Abra a fiscalizacao a partir de uma etapa cadastrada dentro '
          'da obra.',
        ),
        StackTrace.current,
      );
      return;
    }

    if (contratanteIdNormalizado == null || contratanteIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError(
          'Nao foi possivel iniciar a fiscalizacao: a obra nao possui '
          'contratante selecionado. Edite a obra e escolha o contratante.',
        ),
        StackTrace.current,
      );
      return;
    }

    if (responsavelIdNormalizado == null || responsavelIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError(
          'Nao foi possivel iniciar a fiscalizacao: cadastre um funcionario '
          'no contratante da obra para ser responsavel.',
        ),
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
          servicoId: servicoIdNormalizado ?? '',
          etapaId: etapaIdNormalizado,
          obraId: obraIdNormalizado,
          contratanteId: contratanteIdNormalizado,
          responsavelId: responsavelIdNormalizado,
          numero: numeroNormalizado ?? _novoNumero(dataNormalizada),
          data: dataNormalizada,
          diaSemana: dataNormalizada.weekday,
          status: status ?? StatusFiscalizacao.emAndamento,
          atividade: _normalizarTextoOpcional(atividade),
          ocorrencia: _normalizarTextoOpcional(ocorrencia),
          comentario: _normalizarTextoOpcional(comentario),
        ),
      );
    });
  }

  Future<void> salvarTextos({
    required String id,
    String? ocorrencia,
    String? comentario,
  }) async {
    final idNormalizado = id.trim();

    if (idNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Fiscalizacao e obrigatoria para salvar textos.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _repository.atualizarTextosDaVistoria(
        id: idNormalizado,
        ocorrencia: _normalizarTextoOpcional(ocorrencia),
        comentario: _normalizarTextoOpcional(comentario),
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

class FotosFiscalizacaoController extends StateNotifier<AsyncValue<void>> {
  FotosFiscalizacaoController({
    required FotosFiscalizacaoRepository repository,
    required FotosFiscalizacaoStorage storage,
  })  : _repository = repository,
        _storage = storage,
        super(const AsyncData(null));

  final FotosFiscalizacaoRepository _repository;
  final FotosFiscalizacaoStorage _storage;

  Future<void> salvarArquivo({
    required String vistoriaServicoId,
    required String caminhoOrigem,
    String? legenda,
  }) async {
    final vistoriaServicoIdNormalizado = vistoriaServicoId.trim();
    final caminhoOrigemNormalizado = caminhoOrigem.trim();
    final legendaNormalizada = _normalizarTextoOpcional(legenda);

    if (vistoriaServicoIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Fiscalizacao da foto e obrigatoria.'),
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
      final caminhoArquivo = await _storage.salvarFotoFiscalizacao(
        vistoriaServicoId: vistoriaServicoIdNormalizado,
        caminhoOrigem: caminhoOrigemNormalizado,
      );

      await _repository.salvarFoto(
        FotoFiscalizacao(
          id: 'foto-fiscalizacao-${DateTime.now().microsecondsSinceEpoch}',
          vistoriaServicoId: vistoriaServicoIdNormalizado,
          caminhoArquivo: caminhoArquivo,
          legenda: legendaNormalizada,
        ),
      );
    });
  }

  Future<void> remover(String id) async {
    final idNormalizado = id.trim();
    if (idNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Foto da fiscalizacao e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return _repository.removerFoto(idNormalizado);
    });
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
