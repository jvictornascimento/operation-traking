import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../domain/medicao.dart';

abstract class MedicoesRepository {
  Stream<List<Medicao>> watchMedicoesDoServico(String servicoId);

  Future<void> salvarMedicao(Medicao medicao);
}

class PercentualMedicaoInvalidoException implements Exception {
  const PercentualMedicaoInvalidoException(this.percentual);

  final double percentual;

  @override
  String toString() {
    return 'Percentual executado deve estar entre 0 e 100.';
  }
}

class DriftMedicoesRepository implements MedicoesRepository {
  const DriftMedicoesRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Medicao>> watchMedicoesDoServico(String servicoId) {
    final query = _database.select(_database.medicoes)
      ..where((table) => table.servicoId.equals(servicoId))
      ..orderBy([
        (table) => OrderingTerm.desc(table.data),
        (table) => OrderingTerm.desc(table.id),
      ]);

    return query.watch().map((rows) => rows.map(_mapMedicao).toList());
  }

  @override
  Future<void> salvarMedicao(Medicao medicao) {
    if (medicao.percentualExecutado < 0 || medicao.percentualExecutado > 100) {
      throw PercentualMedicaoInvalidoException(medicao.percentualExecutado);
    }

    return _database.into(_database.medicoes).insertOnConflictUpdate(
          db.MedicoesCompanion.insert(
            id: medicao.id,
            servicoId: medicao.servicoId,
            percentualExecutado: medicao.percentualExecutado,
            data: medicao.data,
            observacao: Value(medicao.observacao),
          ),
        );
  }

  Medicao _mapMedicao(db.Medicoe row) {
    return Medicao(
      id: row.id,
      servicoId: row.servicoId,
      percentualExecutado: row.percentualExecutado,
      observacao: row.observacao,
      data: row.data,
    );
  }
}
