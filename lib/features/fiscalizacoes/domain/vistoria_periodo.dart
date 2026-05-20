import '../../../core/domain/domain_enums.dart';

class VistoriaPeriodo {
  const VistoriaPeriodo({
    required this.id,
    required this.vistoriaServicoId,
    required this.periodo,
    required this.tempo,
    required this.condicao,
  });

  final String id;
  final String vistoriaServicoId;
  final PeriodoDia periodo;
  final TempoPeriodo tempo;
  final CondicaoPeriodo condicao;
}
