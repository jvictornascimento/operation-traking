class Relatorio {
  const Relatorio({
    required this.id,
    required this.obraId,
    required this.criadoEm,
    required this.caminhoArquivo,
    this.fiscalizacaoId,
    this.nomeArquivoCompartilhamento,
  });

  final String id;
  final String obraId;
  final DateTime criadoEm;
  final String caminhoArquivo;
  final String? fiscalizacaoId;
  final String? nomeArquivoCompartilhamento;
}
