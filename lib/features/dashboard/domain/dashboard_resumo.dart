class DashboardResumo {
  const DashboardResumo({
    required this.totalObras,
    required this.totalServicos,
    required this.totalFiscalizacoes,
    required this.totalMedicoes,
    required this.totalFotos,
    required this.obrasAtrasadas,
    required this.progressoMedioObras,
  });

  final int totalObras;
  final int totalServicos;
  final int totalFiscalizacoes;
  final int totalMedicoes;
  final int totalFotos;
  final int obrasAtrasadas;
  final double progressoMedioObras;
}
