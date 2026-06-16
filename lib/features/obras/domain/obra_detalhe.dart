import '../../etapas/domain/etapa.dart';
import '../../fiscalizacoes/domain/vistoria_servico.dart';
import '../../servicos/domain/servico.dart';
import 'obra.dart';

class ObraDetalhe {
  const ObraDetalhe({
    required this.obra,
    required this.etapas,
    required this.servicosPorEtapa,
    required this.fiscalizacoesRecentes,
  });

  final Obra obra;
  final List<Etapa> etapas;
  final Map<String, List<Servico>> servicosPorEtapa;
  final List<VistoriaServico> fiscalizacoesRecentes;
}
