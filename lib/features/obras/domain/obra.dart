class Obra {
  const Obra({
    required this.id,
    required this.nome,
    required this.cliente,
    required this.status,
    this.endereco,
    this.dataInicio,
    this.dataFim,
  });

  final String id;
  final String nome;
  final String cliente;
  final String status;
  final String? endereco;
  final DateTime? dataInicio;
  final DateTime? dataFim;
}
