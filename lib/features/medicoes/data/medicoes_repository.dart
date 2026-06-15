import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../domain/medicao.dart';

abstract class MedicoesRepository {
  Stream<List<Medicao>> watchMedicoesDoServico(String servicoId);

  Stream<List<Medicao>> watchMedicoesDaFiscalizacao(String vistoriaServicoId);

  Future<String?> buscarServicoIdDaFiscalizacao(String vistoriaServicoId);

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
  Stream<List<Medicao>> watchMedicoesDaFiscalizacao(String vistoriaServicoId) {
    final query = _database.select(_database.medicoes)
      ..where((table) => table.vistoriaServicoId.equals(vistoriaServicoId))
      ..orderBy([
        (table) => OrderingTerm.desc(table.data),
        (table) => OrderingTerm.desc(table.id),
      ]);

    return query.watch().map((rows) => rows.map(_mapMedicao).toList());
  }

  @override
  Future<String?> buscarServicoIdDaFiscalizacao(
      String vistoriaServicoId) async {
    final vistoria = await (_database.select(_database.vistoriasServico)
          ..where((table) => table.id.equals(vistoriaServicoId)))
        .getSingleOrNull();

    return vistoria?.servicoId;
  }

  @override
  Future<void> salvarMedicao(Medicao medicao) {
    if (medicao.percentualExecutado < 0 || medicao.percentualExecutado > 100) {
      throw PercentualMedicaoInvalidoException(medicao.percentualExecutado);
    }

    return _database.transaction(() async {
      final existente = await (_database.select(_database.medicoes)
            ..where((table) => table.id.equals(medicao.id)))
          .getSingleOrNull();

      await _database.into(_database.medicoes).insertOnConflictUpdate(
            db.MedicoesCompanion.insert(
              id: medicao.id,
              servicoId: medicao.servicoId,
              percentualExecutado: medicao.percentualExecutado,
              data: medicao.data,
              vistoriaServicoId: Value(medicao.vistoriaServicoId),
              observacao: Value(medicao.observacao),
            ),
          );

      if (existente == null ||
          existente.percentualExecutado == medicao.percentualExecutado) {
        return;
      }

      await _database.into(_database.historicosAlteracao).insert(
            db.HistoricosAlteracaoCompanion.insert(
              id: _novoHistoricoId(),
              entidade: 'medicao',
              entidadeId: medicao.id,
              campo: 'percentualExecutado',
              valorAnterior: Value(
                _formatarPercentual(existente.percentualExecutado),
              ),
              valorNovo:
                  Value(_formatarPercentual(medicao.percentualExecutado)),
              data: DateTime.now(),
              usuario: const Value('local'),
            ),
          );
    });
  }

  Medicao _mapMedicao(db.Medicoe row) {
    return Medicao(
      id: row.id,
      servicoId: row.servicoId,
      vistoriaServicoId: row.vistoriaServicoId,
      percentualExecutado: row.percentualExecutado,
      observacao: row.observacao,
      data: row.data,
    );
  }

  String _novoHistoricoId() {
    return 'historico-${DateTime.now().microsecondsSinceEpoch}-medicao';
  }

  String _formatarPercentual(double value) {
    return value.toStringAsFixed(2);
  }
}
