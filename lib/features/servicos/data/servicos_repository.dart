import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/domain/domain_enums.dart';
import '../../historico/data/historicos_repository.dart';
import '../domain/servico.dart';

abstract class ServicosRepository {
  Stream<List<Servico>> watchServicosDaEtapa(String etapaId);

  Future<void> salvarServico(Servico servico);

  Future<void> atualizarProgressoFisico({
    required String id,
    required double progressoFisico,
  });
}

class DriftServicosRepository implements ServicosRepository {
  const DriftServicosRepository(this._database);

  final db.AppDatabase _database;

  DriftHistoricosRepository get _historicosRepository {
    return DriftHistoricosRepository(_database);
  }

  @override
  Stream<List<Servico>> watchServicosDaEtapa(String etapaId) {
    final query = _database.select(_database.servicos)
      ..where((table) => table.etapaId.equals(etapaId))
      ..orderBy([(table) => OrderingTerm.asc(table.nome)]);

    return query.watch().map((rows) => rows.map(_mapServico).toList());
  }

  @override
  Future<void> salvarServico(Servico servico) {
    return _database.into(_database.servicos).insertOnConflictUpdate(
          db.ServicosCompanion.insert(
            id: servico.id,
            etapaId: servico.etapaId,
            nome: servico.nome,
            precoTotal: servico.precoTotal,
            unidade: servico.unidade,
            quantidade: servico.quantidade,
            dataInicio: servico.dataInicio,
            dataFim: servico.dataFim,
            status: servico.status.name,
            progressoFisico: Value(servico.progressoFisico),
            progressoPrazoDias: Value(servico.progressoPrazoDias),
          ),
        );
  }

  @override
  Future<void> atualizarProgressoFisico({
    required String id,
    required double progressoFisico,
  }) {
    return _database.transaction(() async {
      final existente = await (_database.select(_database.servicos)
            ..where((table) => table.id.equals(id)))
          .getSingleOrNull();

      await (_database.update(_database.servicos)
            ..where((table) => table.id.equals(id)))
          .write(
        db.ServicosCompanion(
          progressoFisico: Value(progressoFisico),
        ),
      );

      if (existente == null || existente.progressoFisico == progressoFisico) {
        return;
      }

      await _historicosRepository.registrarAlteracao(
        entidade: 'servico',
        entidadeId: id,
        campo: 'progressoFisico',
        valorAnterior: _formatarPercentual(existente.progressoFisico),
        valorNovo: _formatarPercentual(progressoFisico),
      );
    });
  }

  Servico _mapServico(db.Servico row) {
    return Servico(
      id: row.id,
      etapaId: row.etapaId,
      nome: row.nome,
      precoTotal: row.precoTotal,
      unidade: row.unidade,
      quantidade: row.quantidade,
      dataInicio: row.dataInicio,
      dataFim: row.dataFim,
      status: StatusExecucao.values.byName(row.status),
      progressoFisico: row.progressoFisico,
      progressoPrazoDias: row.progressoPrazoDias,
    );
  }

  String _formatarPercentual(double value) {
    return value.toStringAsFixed(2);
  }
}
