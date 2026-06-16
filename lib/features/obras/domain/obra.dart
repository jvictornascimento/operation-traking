import '../../../core/domain/domain_enums.dart';

class Obra {
  const Obra({
    required this.id,
    required this.empresaId,
    this.contratanteId,
    required this.enderecoId,
    required this.nome,
    this.responsavelNome,
    this.responsavelContato,
    required this.dataInicio,
    required this.dataFim,
    required this.status,
    required this.progressoFisico,
    required this.progressoPrazoDias,
  });

  final String id;
  final String empresaId;
  final String? contratanteId;
  final String enderecoId;
  final String nome;
  final String? responsavelNome;
  final String? responsavelContato;
  final DateTime dataInicio;
  final DateTime dataFim;
  final StatusExecucao status;
  final double progressoFisico;
  final int progressoPrazoDias;
}
