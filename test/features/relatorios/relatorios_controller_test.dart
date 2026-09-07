import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/relatorios/domain/relatorio_fiscalizacao_dados.dart';
import 'package:operational_tracking/features/relatorios/domain/relatorio_obra_dados.dart';
import 'package:operational_tracking/features/relatorios/presentation/relatorios_controller.dart';

void main() {
  group('Issue 27 - RelatoriosController', () {
    test('gera nome amigavel para relatorio de fiscalizacao', () {
      final id = criarIdRelatorioFiscalizacao(
        dados: RelatorioFiscalizacaoDados(
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
        ),
        criadoEm: DateTime(2026, 5, 20, 14, 35),
      );

      expect(
        id,
        'Obra-Regis-Centro-20-05-2026-14-35-fiscalizacao-vistoria-1',
      );
    });
  });
}
