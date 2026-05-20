import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/domain/domain_enums.dart';
import '../domain/obra.dart';

abstract class ObrasRepository {
  Stream<List<Obra>> watchObras();

  Future<void> salvarObra(Obra obra);
}

class DriftObrasRepository implements ObrasRepository {
  const DriftObrasRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Obra>> watchObras() {
    final query = _database.select(_database.obras)
      ..orderBy([(table) => OrderingTerm.asc(table.nome)]);

    return query.watch().map((rows) => rows.map(_mapObra).toList());
  }

  @override
  Future<void> salvarObra(Obra obra) {
    return _database.into(_database.obras).insertOnConflictUpdate(
          db.ObrasCompanion.insert(
            id: obra.id,
            empresaId: obra.empresaId,
            enderecoId: obra.enderecoId,
            nome: obra.nome,
            dataInicio: obra.dataInicio,
            dataFim: obra.dataFim,
            status: obra.status.name,
            progressoFisico: Value(obra.progressoFisico),
            progressoPrazoDias: Value(obra.progressoPrazoDias),
          ),
        );
  }

  Obra _mapObra(db.Obra row) {
    return Obra(
      id: row.id,
      empresaId: row.empresaId,
      enderecoId: row.enderecoId,
      nome: row.nome,
      dataInicio: row.dataInicio,
      dataFim: row.dataFim,
      status: StatusExecucao.values.byName(row.status),
      progressoFisico: row.progressoFisico,
      progressoPrazoDias: row.progressoPrazoDias,
    );
  }
}
