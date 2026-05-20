import '../../../core/domain/domain_enums.dart';

class Endereco {
  const Endereco({
    required this.id,
    required this.entidade,
    required this.entidadeId,
    required this.tipo,
    required this.cidade,
    required this.estado,
    this.cep,
    this.logradouro,
    this.numero,
    this.complemento,
    this.bairro,
    this.pais = 'Brasil',
  });

  final String id;
  final TipoEntidadeEndereco entidade;
  final String entidadeId;
  final String tipo;
  final String? cep;
  final String? logradouro;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String cidade;
  final String estado;
  final String pais;
}
