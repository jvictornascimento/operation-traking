import '../../../core/domain/domain_enums.dart';

class Etapa {
  const Etapa({
    required this.id,
    required this.obraId,
    required this.nome,
    required this.dataInicio,
    required this.dataFim,
    required this.status,
    required this.progressoFisico,
    required this.progressoPrazoDias,
  });

  final String id;
  final String obraId;
  final String nome;
  final DateTime dataInicio;
  final DateTime dataFim;
  final StatusExecucao status;
  final double progressoFisico;
  final int progressoPrazoDias;
}
