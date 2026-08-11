class VistoriaMaoDeObra {
  const VistoriaMaoDeObra({
    required this.id,
    required this.vistoriaServicoId,
    required this.funcionarioId,
    this.funcionarioNomeSnapshot,
    this.funcionarioCargoSnapshot,
    this.funcionarioTelefoneSnapshot,
    this.funcaoNoDia,
    this.observacao,
  });

  final String id;
  final String vistoriaServicoId;
  final String funcionarioId;
  final String? funcionarioNomeSnapshot;
  final String? funcionarioCargoSnapshot;
  final String? funcionarioTelefoneSnapshot;
  final String? funcaoNoDia;
  final String? observacao;

  String get nomeParaHistorico {
    final nome = funcionarioNomeSnapshot?.trim();
    if (nome == null || nome.isEmpty) {
      return funcionarioId;
    }
    return nome;
  }
}
