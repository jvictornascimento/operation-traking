class VistoriaMaoDeObra {
  const VistoriaMaoDeObra({
    required this.id,
    required this.vistoriaServicoId,
    required this.funcionarioId,
    this.funcaoNoDia,
    this.observacao,
  });

  final String id;
  final String vistoriaServicoId;
  final String funcionarioId;
  final String? funcaoNoDia;
  final String? observacao;
}
