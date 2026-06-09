import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/domain/domain_enums.dart';
import '../domain/vistoria_periodo.dart';

abstract class VistoriasPeriodoRepository {
  Stream<List<VistoriaPeriodo>> watchPeriodosDaVistoria(
    String vistoriaServicoId,
  );

  Future<void> salvarPeriodo(VistoriaPeriodo periodo);

  Future<void> removerPeriodo({
    required String vistoriaServicoId,
    required PeriodoDia periodo,
  });
}

class VistoriaPeriodoDuplicadoException implements Exception {
  const VistoriaPeriodoDuplicadoException(
    this.vistoriaServicoId,
    this.periodo,
  );

  final String vistoriaServicoId;
  final PeriodoDia periodo;

  @override
  String toString() {
    return 'Ja existe periodo ${periodo.name} para esta fiscalizacao.';
  }
}

class DriftVistoriasPeriodoRepository implements VistoriasPeriodoRepository {
  const DriftVistoriasPeriodoRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<VistoriaPeriodo>> watchPeriodosDaVistoria(
    String vistoriaServicoId,
  ) {
    final query = _database.select(_database.vistoriasPeriodo)
      ..where((table) => table.vistoriaServicoId.equals(vistoriaServicoId))
      ..orderBy([(table) => OrderingTerm.asc(table.periodo)]);

    return query.watch().map((rows) => rows.map(_mapPeriodo).toList());
  }

  @override
  Future<void> salvarPeriodo(VistoriaPeriodo periodo) {
    return _database.transaction(() async {
      await _garantirPeriodoUnico(
        id: periodo.id,
        vistoriaServicoId: periodo.vistoriaServicoId,
        periodo: periodo.periodo,
      );

      final existente = await (_database.select(_database.vistoriasPeriodo)
            ..where((table) => table.id.equals(periodo.id)))
          .getSingleOrNull();

      final companion = db.VistoriasPeriodoCompanion(
        id: Value(periodo.id),
        vistoriaServicoId: Value(periodo.vistoriaServicoId),
        periodo: Value(periodo.periodo.name),
        tempo: Value(periodo.tempo.name),
        condicao: Value(periodo.condicao.name),
      );

      if (existente == null) {
        await _database.into(_database.vistoriasPeriodo).insert(companion);
        return;
      }

      await (_database.update(_database.vistoriasPeriodo)
            ..where((table) => table.id.equals(periodo.id)))
          .write(companion);
    });
  }

  @override
  Future<void> removerPeriodo({
    required String vistoriaServicoId,
    required PeriodoDia periodo,
  }) {
    return (_database.delete(_database.vistoriasPeriodo)
          ..where((table) {
            return table.vistoriaServicoId.equals(vistoriaServicoId) &
                table.periodo.equals(periodo.name);
          }))
        .go();
  }

  Future<void> _garantirPeriodoUnico({
    required String id,
    required String vistoriaServicoId,
    required PeriodoDia periodo,
  }) async {
    final duplicado = await (_database.select(_database.vistoriasPeriodo)
          ..where((table) {
            return table.vistoriaServicoId.equals(vistoriaServicoId) &
                table.periodo.equals(periodo.name) &
                table.id.equals(id).not();
          }))
        .getSingleOrNull();

    if (duplicado != null) {
      throw VistoriaPeriodoDuplicadoException(vistoriaServicoId, periodo);
    }
  }

  VistoriaPeriodo _mapPeriodo(db.VistoriasPeriodoData row) {
    return VistoriaPeriodo(
      id: row.id,
      vistoriaServicoId: row.vistoriaServicoId,
      periodo: PeriodoDia.values.byName(row.periodo),
      tempo: TempoPeriodo.values.byName(row.tempo),
      condicao: CondicaoPeriodo.values.byName(row.condicao),
    );
  }
}
