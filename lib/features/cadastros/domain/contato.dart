import '../../../core/domain/domain_enums.dart';

class Contato {
  const Contato({
    required this.id,
    required this.entidade,
    required this.entidadeId,
    required this.tipo,
    required this.valor,
    this.observacao,
  });

  final String id;
  final TipoEntidadeContato entidade;
  final String entidadeId;
  final TipoContato tipo;
  final String valor;
  final String? observacao;
}
