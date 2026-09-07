class FotoFiscalizacao {
  const FotoFiscalizacao({
    required this.id,
    required this.vistoriaServicoId,
    required this.caminhoArquivo,
    this.uriGaleria,
    this.legenda,
  });

  final String id;
  final String vistoriaServicoId;
  final String caminhoArquivo;
  final String? uriGaleria;
  final String? legenda;
}
