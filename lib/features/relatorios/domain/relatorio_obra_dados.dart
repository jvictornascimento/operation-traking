import '../../../core/domain/domain_enums.dart';

class RelatorioObraDados {
  const RelatorioObraDados({
    required this.obra,
    required this.servicos,
    required this.medicoes,
    required this.fiscalizacoes,
    required this.maoDeObra,
    required this.fotos,
    this.assinatura,
  });

  final RelatorioObraInfo obra;
  final List<RelatorioServicoInfo> servicos;
  final List<RelatorioMedicaoInfo> medicoes;
  final List<RelatorioFiscalizacaoInfo> fiscalizacoes;
  final List<RelatorioMaoDeObraInfo> maoDeObra;
  final List<RelatorioFotoInfo> fotos;
  final RelatorioAssinaturaInfo? assinatura;
}

class RelatorioObraInfo {
  const RelatorioObraInfo({
    required this.id,
    required this.nome,
    required this.status,
    required this.progressoFisico,
    required this.progressoPrazoDias,
    required this.dataInicio,
    required this.dataFim,
  });

  final String id;
  final String nome;
  final StatusExecucao status;
  final double progressoFisico;
  final int progressoPrazoDias;
  final DateTime dataInicio;
  final DateTime dataFim;
}

class RelatorioServicoInfo {
  const RelatorioServicoInfo({
    required this.id,
    required this.nome,
    required this.status,
    required this.progressoFisico,
    required this.quantidade,
    required this.unidade,
    required this.precoTotal,
  });

  final String id;
  final String nome;
  final StatusExecucao status;
  final double progressoFisico;
  final double quantidade;
  final String unidade;
  final double precoTotal;
}

class RelatorioMedicaoInfo {
  const RelatorioMedicaoInfo({
    required this.id,
    required this.servicoId,
    required this.percentualExecutado,
    required this.data,
    this.observacao,
  });

  final String id;
  final String servicoId;
  final double percentualExecutado;
  final DateTime data;
  final String? observacao;
}

class RelatorioFiscalizacaoInfo {
  const RelatorioFiscalizacaoInfo({
    required this.id,
    required this.numero,
    required this.data,
    required this.status,
    this.etapaId,
    this.servicoId,
    this.atividade,
    this.ocorrencia,
    this.comentario,
  });

  final String id;
  final String numero;
  final String? etapaId;
  final String? servicoId;
  final DateTime data;
  final StatusFiscalizacao status;
  final String? atividade;
  final String? ocorrencia;
  final String? comentario;
}

class RelatorioMaoDeObraInfo {
  const RelatorioMaoDeObraInfo({
    required this.vistoriaServicoId,
    required this.funcionarioId,
    this.funcionarioNome,
    this.funcionarioCargo,
    this.funcionarioTelefone,
    this.funcaoNoDia,
    this.observacao,
  });

  final String vistoriaServicoId;
  final String funcionarioId;
  final String? funcionarioNome;
  final String? funcionarioCargo;
  final String? funcionarioTelefone;
  final String? funcaoNoDia;
  final String? observacao;
}

class RelatorioFotoInfo {
  const RelatorioFotoInfo({
    required this.caminhoArquivo,
    this.medicaoId,
    this.vistoriaServicoId,
    this.uriGaleria,
    this.legenda,
  });

  final String? medicaoId;
  final String? vistoriaServicoId;
  final String caminhoArquivo;
  final String? uriGaleria;
  final String? legenda;
}

class RelatorioAssinaturaInfo {
  const RelatorioAssinaturaInfo({
    required this.nome,
    this.assinaturaPath,
  });

  final String nome;
  final String? assinaturaPath;
}
