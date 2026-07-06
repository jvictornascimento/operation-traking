import '../../etapas/domain/etapa.dart';
import '../../fiscalizacoes/domain/vistoria_servico.dart';
import 'obra.dart';

class ObraDetalhe {
  const ObraDetalhe({
    required this.obra,
    required this.etapas,
    required this.fiscalizacoesRecentes,
  });

  final Obra obra;
  final List<Etapa> etapas;
  final List<VistoriaServico> fiscalizacoesRecentes;
}
