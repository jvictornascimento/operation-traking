import '../../../core/domain/domain_enums.dart';

class VistoriaServico {
  const VistoriaServico({
    required this.id,
    required this.servicoId,
    required this.obraId,
    required this.contratanteId,
    required this.responsavelId,
    required this.numero,
    required this.data,
    required this.diaSemana,
    this.status = StatusFiscalizacao.emAndamento,
    this.ocorrencia,
    this.comentario,
  });

  final String id;
  final String servicoId;
  final String obraId;
  final String contratanteId;
  final String responsavelId;
  final String numero;
  final DateTime data;
  final int diaSemana;
  final StatusFiscalizacao status;
  final String? ocorrencia;
  final String? comentario;
}
