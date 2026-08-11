class Funcionario {
  const Funcionario({
    required this.id,
    required this.nome,
    required this.cargo,
    required this.tipo,
    this.empresaId,
    this.contratanteId,
    this.cpf,
    this.telefone,
    this.assinaturaPath,
    this.ativo = true,
    this.excluidoEm,
    this.motivoInativacao,
  }) : assert(
          (empresaId == null) != (contratanteId == null),
          'Funcionario deve pertencer a uma empresa ou a um contratante.',
        );

  final String id;
  final String? empresaId;
  final String? contratanteId;
  final String nome;
  final String? cpf;
  final String? telefone;
  final String cargo;
  final String tipo;
  final String? assinaturaPath;
  final bool ativo;
  final DateTime? excluidoEm;
  final String? motivoInativacao;

  bool get pertenceAEmpresa => empresaId != null;

  bool get pertenceAContratante => contratanteId != null;

  bool get inativo => !ativo;
}
