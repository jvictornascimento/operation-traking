class Medicao {
  const Medicao({
    required this.id,
    required this.servicoId,
    required this.percentualExecutado,
    required this.data,
    this.observacao,
  }) : assert(
          percentualExecutado >= 0 && percentualExecutado <= 100,
          'Percentual executado deve estar entre 0 e 100.',
        );

  final String id;
  final String servicoId;
  final double percentualExecutado;
  final DateTime data;
  final String? observacao;
}
