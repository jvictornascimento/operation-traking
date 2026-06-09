import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/database/database_provider.dart';
import '../data/relatorio_obra_repository.dart';
import '../data/relatorio_pdf_generator.dart';
import '../domain/relatorio.dart';

final relatorioObraRepositoryProvider = Provider<RelatorioObraRepository>(
  (ref) => DriftRelatorioObraRepository(ref.watch(appDatabaseProvider)),
);

final relatorioPdfGeneratorProvider = Provider<RelatorioPdfGenerator>(
  (ref) => const RelatorioPdfGenerator(),
);

final relatoriosControllerProvider =
    StateNotifierProvider<RelatoriosController, AsyncValue<Relatorio?>>((ref) {
  return RelatoriosController(
    repository: ref.watch(relatorioObraRepositoryProvider),
    generator: ref.watch(relatorioPdfGeneratorProvider),
  );
});

class RelatoriosController extends StateNotifier<AsyncValue<Relatorio?>> {
  RelatoriosController({
    required RelatorioObraRepository repository,
    required RelatorioPdfGenerator generator,
  })  : _repository = repository,
        _generator = generator,
        super(const AsyncData(null));

  final RelatorioObraRepository _repository;
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
      final dados = await _repository.carregarDadosDaObra(obraIdNormalizado);
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
