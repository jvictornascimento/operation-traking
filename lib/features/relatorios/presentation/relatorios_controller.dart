import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/database/database_provider.dart';
import '../data/relatorio_fiscalizacao_repository.dart';
import '../data/relatorio_obra_repository.dart';
import '../data/relatorio_pdf_generator.dart';
import '../domain/relatorio.dart';
import '../domain/relatorio_fiscalizacao_dados.dart';

final relatorioObraRepositoryProvider = Provider<RelatorioObraRepository>(
  (ref) => DriftRelatorioObraRepository(ref.watch(appDatabaseProvider)),
);

final relatorioFiscalizacaoRepositoryProvider =
    Provider<RelatorioFiscalizacaoRepository>(
  (ref) => DriftRelatorioFiscalizacaoRepository(ref.watch(appDatabaseProvider)),
);

final relatorioPdfGeneratorProvider = Provider<RelatorioPdfGenerator>(
  (ref) => const RelatorioPdfGenerator(),
);

final relatorioFiscalizacaoExistenteProvider =
    FutureProvider.family.autoDispose<Relatorio?, String>(
  (ref, fiscalizacaoId) {
    return buscarRelatorioFiscalizacaoExistente(fiscalizacaoId);
  },
);

final relatoriosControllerProvider =
    StateNotifierProvider<RelatoriosController, AsyncValue<Relatorio?>>((ref) {
  return RelatoriosController(
    obraRepository: ref.watch(relatorioObraRepositoryProvider),
    fiscalizacaoRepository: ref.watch(relatorioFiscalizacaoRepositoryProvider),
    generator: ref.watch(relatorioPdfGeneratorProvider),
  );
});

class RelatoriosController extends StateNotifier<AsyncValue<Relatorio?>> {
  RelatoriosController({
    required RelatorioObraRepository obraRepository,
    required RelatorioFiscalizacaoRepository fiscalizacaoRepository,
    required RelatorioPdfGenerator generator,
  })  : _obraRepository = obraRepository,
        _fiscalizacaoRepository = fiscalizacaoRepository,
        _generator = generator,
        super(const AsyncData(null));

  final RelatorioObraRepository _obraRepository;
  final RelatorioFiscalizacaoRepository _fiscalizacaoRepository;
  final RelatorioPdfGenerator _generator;

  Future<void> gerarRelatorioObra(String obraId) async {
    final obraIdNormalizado = obraId.trim();

    if (obraIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Obra do relatorio e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final dados = await _obraRepository.carregarDadosDaObra(
        obraIdNormalizado,
      );
      final bytes = await _generator.gerarRelatorioObra(dados);
      final criadoEm = DateTime.now();
      final id = 'relatorio-${criadoEm.microsecondsSinceEpoch}';
      final caminhoArquivo = await _salvarPdfLocal(
        id: id,
        bytes: bytes,
      );

      return Relatorio(
        id: id,
        obraId: obraIdNormalizado,
        criadoEm: criadoEm,
        caminhoArquivo: caminhoArquivo,
      );
    });
  }

  Future<void> gerarRelatorioFiscalizacao(String vistoriaServicoId) async {
    final vistoriaServicoIdNormalizado = vistoriaServicoId.trim();

    if (vistoriaServicoIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Fiscalizacao do relatorio e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final dados = await _fiscalizacaoRepository.carregarDadosDaFiscalizacao(
        vistoriaServicoIdNormalizado,
      );
      final bytes = await _generator.gerarRelatorioFiscalizacao(dados);
      final criadoEm = DateTime.now();
      final id = criarIdRelatorioFiscalizacao(
        dados: dados,
        criadoEm: criadoEm,
      );
      final nomeArquivoCompartilhamento =
          criarNomeArquivoCompartilhamentoFiscalizacao(
        dados: dados,
        criadoEm: criadoEm,
      );
      final caminhoArquivo = await _salvarPdfLocal(
        id: id,
        bytes: bytes,
      );

      return Relatorio(
        id: id,
        obraId: dados.obra.id,
        fiscalizacaoId: vistoriaServicoIdNormalizado,
        criadoEm: criadoEm,
        caminhoArquivo: caminhoArquivo,
        nomeArquivoCompartilhamento: nomeArquivoCompartilhamento,
      );
    });
  }

  Future<String> _salvarPdfLocal({
    required String id,
    required List<int> bytes,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final relatoriosDir = Directory(p.join(directory.path, 'relatorios'));

    if (!await relatoriosDir.exists()) {
      await relatoriosDir.create(recursive: true);
    }

    final file = File(p.join(relatoriosDir.path, '$id.pdf'));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }
}

Future<Relatorio?> buscarRelatorioFiscalizacaoExistente(
  String fiscalizacaoId,
) async {
  final fiscalizacaoIdNormalizado = fiscalizacaoId.trim();
  if (fiscalizacaoIdNormalizado.isEmpty) {
    return null;
  }

  final directory = await getApplicationDocumentsDirectory();
  final relatoriosDir = Directory(p.join(directory.path, 'relatorios'));
  if (!await relatoriosDir.exists()) {
    return null;
  }

  final sufixoNovo = '-fiscalizacao-'
      '${_normalizarNomeArquivo(fiscalizacaoIdNormalizado)}.pdf';
  final prefixoAntigo = 'relatorio-fiscalizacao-'
      '${_normalizarNomeArquivo(fiscalizacaoIdNormalizado)}-';
  final arquivos = await relatoriosDir
      .list()
      .where((entity) {
        if (entity is! File) {
          return false;
        }

        final nome = p.basename(entity.path);
        return nome.endsWith(sufixoNovo) ||
            (nome.startsWith(prefixoAntigo) && nome.endsWith('.pdf'));
      })
      .cast<File>()
      .toList();

  if (arquivos.isEmpty) {
    return null;
  }

  arquivos.sort((a, b) {
    return b.lastModifiedSync().compareTo(a.lastModifiedSync());
  });

  final arquivo = arquivos.first;
  final criadoEm = arquivo.lastModifiedSync();
  final id = p.basenameWithoutExtension(arquivo.path);

  return Relatorio(
    id: id,
    obraId: '',
    fiscalizacaoId: fiscalizacaoIdNormalizado,
    criadoEm: criadoEm,
    caminhoArquivo: arquivo.path,
  );
}

String _normalizarNomeArquivo(String value) {
  final normalizado = value
      .trim()
      .replaceAll(RegExp(r'[^A-Za-z0-9_-]+'), '-')
      .replaceAll(RegExp('-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');

  return normalizado.isEmpty ? 'relatorio' : normalizado;
}

String criarIdRelatorioFiscalizacao({
  required RelatorioFiscalizacaoDados dados,
  required DateTime criadoEm,
}) {
  final obra = _normalizarNomeArquivo(dados.obra.nome);
  final data = _formatarDataArquivo(dados.fiscalizacao.data);
  final horario = _formatarHorarioArquivo(criadoEm);
  final fiscalizacaoId = _normalizarNomeArquivo(dados.fiscalizacao.id);

  return '$obra-$data-$horario-fiscalizacao-$fiscalizacaoId';
}

String criarNomeArquivoCompartilhamentoFiscalizacao({
  required RelatorioFiscalizacaoDados dados,
  required DateTime criadoEm,
}) {
  final obra = _normalizarNomeArquivo(dados.obra.nome);
  final data = _formatarDataArquivo(dados.fiscalizacao.data);
  final horario = _formatarHorarioArquivo(criadoEm);

  return '$obra - $data $horario.pdf';
}

String _formatarDataArquivo(DateTime data) {
  return '${data.day.toString().padLeft(2, '0')}-'
      '${data.month.toString().padLeft(2, '0')}-'
      '${data.year.toString().padLeft(4, '0')}';
}

String _formatarHorarioArquivo(DateTime data) {
  return '${data.hour.toString().padLeft(2, '0')}-'
      '${data.minute.toString().padLeft(2, '0')}';
}
