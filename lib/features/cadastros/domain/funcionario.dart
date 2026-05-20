class Funcionario {
  const Funcionario({
    required this.id,
    required this.nome,
    required this.cargo,
    this.empresaId,
    this.contratanteId,
    this.cpf,
  }) : assert(
          (empresaId == null) != (contratanteId == null),
          'Funcionario deve pertencer a uma empresa ou a um contratante.',
        );

  final String id;
  final String? empresaId;
  final String? contratanteId;
  final String nome;
  final String? cpf;
  final String cargo;

  bool get pertenceAEmpresa => empresaId != null;

  bool get pertenceAContratante => contratanteId != null;
}
