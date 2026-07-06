class DashboardResumo {
  const DashboardResumo({
    required this.totalObras,
    required this.totalFiscalizacoes,
    required this.totalFotos,
    required this.obrasAtrasadas,
    required this.progressoMedioObras,
  });

  final int totalObras;
  final int totalFiscalizacoes;
  final int totalFotos;
  final int obrasAtrasadas;
  final double progressoMedioObras;

  @Deprecated('Servico foi removido do fluxo principal.')
  int get totalServicos => 0;

  @Deprecated('Medicao foi removida do fluxo principal.')
  int get totalMedicoes => 0;
}
