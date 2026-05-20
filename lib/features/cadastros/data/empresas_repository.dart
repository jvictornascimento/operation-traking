import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../domain/empresa.dart';

abstract class EmpresasRepository {
  Stream<List<Empresa>> watchEmpresas();

  Future<void> salvarEmpresa(Empresa empresa);
}

class DriftEmpresasRepository implements EmpresasRepository {
  const DriftEmpresasRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Empresa>> watchEmpresas() {
    final query = _database.select(_database.empresas)
      ..orderBy([(table) => OrderingTerm.asc(table.nome)]);

    return query.watch().map((rows) => rows.map(_mapEmpresa).toList());
  }

  @override
  Future<void> salvarEmpresa(Empresa empresa) {
    return _database.into(_database.empresas).insertOnConflictUpdate(
          db.EmpresasCompanion.insert(
            id: empresa.id,
            nome: empresa.nome,
            cnpj: Value(empresa.cnpj),
            ie: Value(empresa.ie),
          ),
        );
  }

  Empresa _mapEmpresa(db.Empresa row) {
    return Empresa(
      id: row.id,
      nome: row.nome,
      cnpj: row.cnpj,
      ie: row.ie,
    );
  }
}
