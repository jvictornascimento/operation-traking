import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../domain/historico_alteracao.dart';

abstract class HistoricosRepository {
  Stream<List<HistoricoAlteracao>> watchHistoricosDaEntidade({
    required String entidade,
    required String entidadeId,
  });

  Future<void> registrarAlteracao({
    required String entidade,
    required String entidadeId,
    required String campo,
    String? valorAnterior,
    String? valorNovo,
  });

  Future<void> registrarAlteracaoSeMudou({
    required String entidade,
    required String entidadeId,
    required String campo,
    String? valorAnterior,
    String? valorNovo,
  });
}

class DriftHistoricosRepository implements HistoricosRepository {
  const DriftHistoricosRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<HistoricoAlteracao>> watchHistoricosDaEntidade({
    required String entidade,
    required String entidadeId,
  }) {
    final query = _database.select(_database.historicosAlteracao)
      ..where((table) {
        return table.entidade.equals(entidade) &
            table.entidadeId.equals(entidadeId);
      })
      ..orderBy([(table) => OrderingTerm.desc(table.data)]);

    return query.watch().map((rows) => rows.map(_mapHistorico).toList());
  }

  @override
  Future<void> registrarAlteracao({
    required String entidade,
    required String entidadeId,
    required String campo,
    String? valorAnterior,
    String? valorNovo,
  }) {
    return _database.into(_database.historicosAlteracao).insert(
          db.HistoricosAlteracaoCompanion.insert(
            id: _novoId(campo),
            entidade: entidade,
            entidadeId: entidadeId,
            campo: campo,
            valorAnterior: Value(valorAnterior),
            valorNovo: Value(valorNovo),
            data: DateTime.now(),
            usuario: const Value('local'),
          ),
        );
  }

  @override
  Future<void> registrarAlteracaoSeMudou({
    required String entidade,
    required String entidadeId,
    required String campo,
    String? valorAnterior,
    String? valorNovo,
  }) {
    if (valorAnterior == valorNovo) {
      return Future.value();
    }

    return registrarAlteracao(
      entidade: entidade,
      entidadeId: entidadeId,
      campo: campo,
      valorAnterior: valorAnterior,
      valorNovo: valorNovo,
    );
  }

  HistoricoAlteracao _mapHistorico(db.HistoricosAlteracaoData row) {
    return HistoricoAlteracao(
      id: row.id,
      entidade: row.entidade,
      entidadeId: row.entidadeId,
      campo: row.campo,
      valorAnterior: row.valorAnterior,
      valorNovo: row.valorNovo,
      data: row.data,
      usuario: row.usuario,
    );
  }

  String _novoId(String campo) {
    return 'historico-${DateTime.now().microsecondsSinceEpoch}-$campo';
  }
}
