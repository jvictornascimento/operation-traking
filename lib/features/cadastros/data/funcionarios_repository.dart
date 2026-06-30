import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../domain/funcionario.dart';

abstract class FuncionariosRepository {
  Stream<List<Funcionario>> watchFuncionariosDaEmpresa(String empresaId);

  Stream<List<Funcionario>> watchFuncionariosDoContratante(
    String contratanteId,
  );

  Future<void> salvarFuncionario(Funcionario funcionario);

  Future<void> removerFuncionario(String id);
}

class DriftFuncionariosRepository implements FuncionariosRepository {
  const DriftFuncionariosRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Funcionario>> watchFuncionariosDaEmpresa(String empresaId) {
    final query = _database.select(_database.funcionarios)
      ..where((table) => table.empresaId.equals(empresaId))
      ..orderBy([(table) => OrderingTerm.asc(table.nome)]);

    return query.watch().map((rows) => rows.map(_mapFuncionario).toList());
  }

  @override
  Stream<List<Funcionario>> watchFuncionariosDoContratante(
    String contratanteId,
  ) {
    final query = _database.select(_database.funcionarios)
      ..where((table) => table.contratanteId.equals(contratanteId))
      ..orderBy([(table) => OrderingTerm.asc(table.nome)]);

    return query.watch().map((rows) => rows.map(_mapFuncionario).toList());
  }

  @override
  Future<void> salvarFuncionario(Funcionario funcionario) {
    return _database.into(_database.funcionarios).insertOnConflictUpdate(
          db.FuncionariosCompanion.insert(
            id: funcionario.id,
            empresaId: Value(funcionario.empresaId),
            contratanteId: Value(funcionario.contratanteId),
            nome: funcionario.nome,
            cpf: Value(funcionario.cpf),
            telefone: Value(funcionario.telefone),
            cargo: funcionario.cargo,
            tipo: Value(funcionario.tipo),
            assinaturaPath: Value(funcionario.assinaturaPath),
          ),
        );
  }

  @override
  Future<void> removerFuncionario(String id) {
    return (_database.delete(_database.funcionarios)
          ..where((table) => table.id.equals(id)))
        .go();
  }

  Funcionario _mapFuncionario(db.Funcionario row) {
    return Funcionario(
      id: row.id,
      empresaId: row.empresaId,
      contratanteId: row.contratanteId,
      nome: row.nome,
      cpf: row.cpf,
      telefone: row.telefone,
      cargo: row.cargo,
      tipo: row.tipo,
      assinaturaPath: row.assinaturaPath,
    );
  }
}
