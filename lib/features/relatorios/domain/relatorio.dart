class Relatorio {
  const Relatorio({
    required this.id,
    required this.obraId,
    required this.criadoEm,
    required this.caminhoArquivo,
  });

  final String id;
  final String obraId;
  final DateTime criadoEm;
  final String caminhoArquivo;
}
