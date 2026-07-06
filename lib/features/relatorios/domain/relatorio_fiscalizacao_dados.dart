import '../../../core/domain/domain_enums.dart';
import 'relatorio_obra_dados.dart';

class RelatorioFiscalizacaoDados {
  const RelatorioFiscalizacaoDados({
    required this.obra,
    required this.fiscalizacao,
    required this.periodos,
    required this.maoDeObra,
    required this.fotos,
    RelatorioEtapaInfo? etapa,
    RelatorioServicoInfo? servico,
    this.medicoes = const [],
  })  : _etapa = etapa,
        _servico = servico;

  final RelatorioObraInfo obra;
  final RelatorioEtapaInfo? _etapa;
  final RelatorioServicoInfo? _servico;
  final RelatorioFiscalizacaoInfo fiscalizacao;
  final List<RelatorioPeriodoInfo> periodos;
  final List<RelatorioMaoDeObraInfo> maoDeObra;
  final List<RelatorioFotoInfo> fotos;
  final List<RelatorioMedicaoInfo> medicoes;

  RelatorioEtapaInfo get etapa {
    final etapa = _etapa;
    if (etapa != null) {
      return etapa;
    }

    final servico = _servico;
    return RelatorioEtapaInfo(
      id: servico?.id ?? '',
      nome: servico?.nome ?? '',
      status: servico?.status ?? StatusExecucao.naoComecou,
      progressoFisico: servico?.progressoFisico ?? 0,
    );
  }

  RelatorioServicoInfo get servico {
    final servico = _servico;
    if (servico != null) {
      return servico;
    }

    final etapa = _etapa;
    return RelatorioServicoInfo(
      id: etapa?.id ?? '',
      nome: etapa?.nome ?? '',
      status: etapa?.status ?? StatusExecucao.naoComecou,
      progressoFisico: etapa?.progressoFisico ?? 0,
      quantidade: 0,
      unidade: '',
      precoTotal: 0,
    );
  }
}

class RelatorioEtapaInfo {
  const RelatorioEtapaInfo({
    required this.id,
    required this.nome,
    required this.status,
    required this.progressoFisico,
  });

  final String id;
  final String nome;
  final StatusExecucao status;
  final double progressoFisico;
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
