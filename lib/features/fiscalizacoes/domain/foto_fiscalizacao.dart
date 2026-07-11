class FotoFiscalizacao {
  const FotoFiscalizacao({
    required this.id,
    required this.vistoriaServicoId,
    required this.caminhoArquivo,
    this.legenda,
  });

  final String id;
  final String vistoriaServicoId;
  final String caminhoArquivo;
  final String? legenda;
}
