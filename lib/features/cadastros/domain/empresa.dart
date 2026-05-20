class Empresa {
  const Empresa({
    required this.id,
    required this.nome,
    this.cnpj,
    this.ie,
  });

  final String id;
  final String nome;
  final String? cnpj;
  final String? ie;
}
