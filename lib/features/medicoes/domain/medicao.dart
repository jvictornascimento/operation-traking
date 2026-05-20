class Medicao {
  const Medicao({
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
