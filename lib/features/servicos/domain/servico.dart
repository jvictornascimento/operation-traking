class Servico {
  const Servico({
    required this.id,
    required this.etapaId,
    required this.nome,
    required this.precoTotal,
    required this.progresso,
    required this.unidade,
    required this.quantidade,
  });

  final String id;
  final String etapaId;
  final String nome;
  final double precoTotal;
  final double progresso;
  final String unidade;
  final double quantidade;
}
