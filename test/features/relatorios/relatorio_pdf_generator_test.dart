import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/relatorios/data/relatorio_pdf_generator.dart';
import 'package:operational_tracking/features/relatorios/domain/relatorio_obra_dados.dart';

void main() {
  group('Story 7.1 - RelatorioPdfGenerator', () {
    test('gera bytes de PDF para relatorio de obra', () async {
      const generator = RelatorioPdfGenerator();

      final bytes = await generator.gerarRelatorioObra(_dados());

      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });
  });
}

RelatorioObraDados _dados() {
  return RelatorioObraDados(
    obra: RelatorioObraInfo(
      id: 'obra-1',
      nome: 'Obra Regis',
      status: StatusExecucao.emAndamento,
      progressoFisico: 60,
      progressoPrazoDias: 5,
      dataInicio: DateTime(2026, 5, 1),
      dataFim: DateTime(2026, 6, 1),
    ),
    servicos: const [
      RelatorioServicoInfo(
        id: 'servico-1',
        nome: 'Escavacao',
        status: StatusExecucao.emAndamento,
        progressoFisico: 60,
        quantidade: 10,
        unidade: 'm3',
        precoTotal: 1000,
      ),
    ],
    medicoes: [
      RelatorioMedicaoInfo(
        id: 'medicao-1',
        servicoId: 'servico-1',
        percentualExecutado: 60,
        data: DateTime(2026, 5, 20),
        observacao: 'Frente norte',
      ),
    ],
    fiscalizacoes: [
      RelatorioFiscalizacaoInfo(
        id: 'vistoria-1',
        numero: '001',
        servicoId: 'servico-1',
        data: DateTime(2026, 5, 20),
        status: StatusFiscalizacao.emAndamento,
        ocorrencia: 'Sem ocorrencias',
        comentario: 'Dia produtivo',
      ),
    ],
    maoDeObra: const [
      RelatorioMaoDeObraInfo(
        vistoriaServicoId: 'vistoria-1',
        funcionarioId: 'funcionario-1',
        funcaoNoDia: 'Pedreiro',
      ),
    ],
    fotos: const [
      RelatorioFotoInfo(
        medicaoId: 'medicao-1',
        caminhoArquivo: '/arquivo/nao/existe.jpg',
      ),
    ],
  );
}
