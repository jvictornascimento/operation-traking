import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/relatorios/domain/relatorio_fiscalizacao_dados.dart';
import 'package:operational_tracking/features/relatorios/domain/relatorio_obra_dados.dart';
import 'package:operational_tracking/features/relatorios/presentation/relatorios_controller.dart';

void main() {
  group('Issue 29 - RelatoriosController', () {
    test('mantem id tecnico para localizar relatorio de fiscalizacao', () {
      final id = criarIdRelatorioFiscalizacao(
        dados: _dadosFiscalizacao(),
        criadoEm: DateTime(2026, 5, 20, 14, 35),
      );

      expect(
        id,
        'Obra-Regis-Centro-20-05-2026-14-35-fiscalizacao-vistoria-1',
      );
    });

    test('gera nome amigavel para compartilhar relatorio de fiscalizacao', () {
      final nomeArquivo = criarNomeArquivoCompartilhamentoFiscalizacao(
        dados: _dadosFiscalizacao(),
        criadoEm: DateTime(2026, 5, 20, 14, 35),
      );

      expect(nomeArquivo, 'Obra-Regis-Centro - 20-05-2026 14-35.pdf');
    });
  });
}

RelatorioFiscalizacaoDados _dadosFiscalizacao() {
  return RelatorioFiscalizacaoDados(
    obra: RelatorioObraInfo(
      id: 'obra-1',
      nome: 'Obra Regis Centro',
      status: StatusExecucao.emAndamento,
      progressoFisico: 0,
      progressoPrazoDias: 0,
      dataInicio: DateTime(2026, 5),
      dataFim: DateTime(2026, 6),
      numeroContrato: 'CTR-001',
    ),
    fiscalizacao: RelatorioFiscalizacaoInfo(
      id: 'vistoria-1',
      numero: '001',
      data: DateTime(2026, 5, 20),
      status: StatusFiscalizacao.emAndamento,
    ),
    periodos: const [],
    maoDeObra: const [],
    fotos: const [],
  );
}
