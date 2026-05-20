import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../domain/contratante.dart';

abstract class ContratantesRepository {
  Stream<List<Contratante>> watchContratantes();

  Future<void> salvarContratante(Contratante contratante);
}

class DriftContratantesRepository implements ContratantesRepository {
  const DriftContratantesRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Contratante>> watchContratantes() {
    final query = _database.select(_database.contratantes)
      ..orderBy([(table) => OrderingTerm.asc(table.nome)]);

    return query.watch().map((rows) => rows.map(_mapContratante).toList());
  }

  @override
  Future<void> salvarContratante(Contratante contratante) {
    return _database.into(_database.contratantes).insertOnConflictUpdate(
          db.ContratantesCompanion.insert(
            id: contratante.id,
            nome: contratante.nome,
            cnpj: Value(contratante.cnpj),
            ie: Value(contratante.ie),
          ),
        );
  }

  Contratante _mapContratante(db.Contratante row) {
    return Contratante(
      id: row.id,
      nome: row.nome,
      cnpj: row.cnpj,
      ie: row.ie,
    );
  }
}
