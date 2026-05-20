import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/domain/domain_enums.dart';
import '../domain/etapa.dart';

abstract class EtapasRepository {
  Stream<List<Etapa>> watchEtapasDaObra(String obraId);

  Future<void> salvarEtapa(Etapa etapa);
}

class DriftEtapasRepository implements EtapasRepository {
  const DriftEtapasRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Etapa>> watchEtapasDaObra(String obraId) {
    final query = _database.select(_database.etapas)
      ..where((table) => table.obraId.equals(obraId))
      ..orderBy([(table) => OrderingTerm.asc(table.nome)]);

    return query.watch().map((rows) => rows.map(_mapEtapa).toList());
  }

  @override
  Future<void> salvarEtapa(Etapa etapa) {
    return _database.into(_database.etapas).insertOnConflictUpdate(
          db.EtapasCompanion.insert(
            id: etapa.id,
            obraId: etapa.obraId,
            nome: etapa.nome,
            dataInicio: etapa.dataInicio,
            dataFim: etapa.dataFim,
            status: etapa.status.name,
            progressoFisico: Value(etapa.progressoFisico),
            progressoPrazoDias: Value(etapa.progressoPrazoDias),
          ),
        );
  }

  Etapa _mapEtapa(db.Etapa row) {
    return Etapa(
      id: row.id,
      obraId: row.obraId,
      nome: row.nome,
      dataInicio: row.dataInicio,
      dataFim: row.dataFim,
      status: StatusExecucao.values.byName(row.status),
      progressoFisico: row.progressoFisico,
      progressoPrazoDias: row.progressoPrazoDias,
    );
  }
}
