class HistoricoAlteracao {
  const HistoricoAlteracao({
    required this.id,
    required this.entidade,
    required this.entidadeId,
    required this.campo,
    required this.valorAnterior,
    required this.valorNovo,
    required this.data,
    this.usuario,
  });

  final String id;
  final String entidade;
  final String entidadeId;
  final String campo;
  final String? valorAnterior;
  final String? valorNovo;
  final DateTime data;
  final String? usuario;
}
