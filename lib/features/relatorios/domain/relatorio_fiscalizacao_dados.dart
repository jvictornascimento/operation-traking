import '../../../core/domain/domain_enums.dart';
import 'relatorio_obra_dados.dart';

class RelatorioFiscalizacaoDados {
  const RelatorioFiscalizacaoDados({
    required this.obra,
    required this.servico,
    required this.fiscalizacao,
    required this.periodos,
    required this.medicoes,
    required this.maoDeObra,
    required this.fotos,
  });

  final RelatorioObraInfo obra;
  final RelatorioServicoInfo servico;
  final RelatorioFiscalizacaoInfo fiscalizacao;
  final List<RelatorioPeriodoInfo> periodos;
  final List<RelatorioMedicaoInfo> medicoes;
  final List<RelatorioMaoDeObraInfo> maoDeObra;
  final List<RelatorioFotoInfo> fotos;
}

class RelatorioPeriodoInfo {
  const RelatorioPeriodoInfo({
    required this.periodo,
    required this.tempo,
    required this.condicao,
  });

  final PeriodoDia periodo;
  final TempoPeriodo tempo;
  final CondicaoPeriodo condicao;
}
