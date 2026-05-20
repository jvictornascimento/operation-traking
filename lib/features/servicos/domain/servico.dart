import '../../../core/domain/domain_enums.dart';

class Servico {
  const Servico({
    required this.id,
    required this.etapaId,
    required this.nome,
    required this.precoTotal,
    required this.unidade,
    required this.quantidade,
    required this.dataInicio,
    required this.dataFim,
    required this.status,
    required this.progressoFisico,
    required this.progressoPrazoDias,
  });

  final String id;
  final String etapaId;
  final String nome;
  final double precoTotal;
  final String unidade;
  final double quantidade;
  final DateTime dataInicio;
  final DateTime dataFim;
  final StatusExecucao status;
  final double progressoFisico;
  final int progressoPrazoDias;
}
