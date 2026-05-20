import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/domain/domain_enums.dart';
import '../domain/contato.dart';

abstract class ContatosRepository {
  Stream<List<Contato>> watchContatos({
    required TipoEntidadeContato entidade,
    required String entidadeId,
  });

  Future<void> salvarContato(Contato contato);
}

class DriftContatosRepository implements ContatosRepository {
  const DriftContatosRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Contato>> watchContatos({
    required TipoEntidadeContato entidade,
    required String entidadeId,
  }) {
    final query = _database.select(_database.contatos)
      ..where((table) {
        return table.entidade.equals(entidade.name) &
            table.entidadeId.equals(entidadeId);
      })
      ..orderBy([(table) => OrderingTerm.asc(table.tipo)]);

    return query.watch().map((rows) => rows.map(_mapContato).toList());
  }

  @override
  Future<void> salvarContato(Contato contato) {
    return _database.into(_database.contatos).insertOnConflictUpdate(
          db.ContatosCompanion.insert(
            id: contato.id,
            entidade: contato.entidade.name,
            entidadeId: contato.entidadeId,
            tipo: contato.tipo.name,
            valor: contato.valor,
            observacao: Value(contato.observacao),
          ),
        );
  }

  Contato _mapContato(db.Contato row) {
    return Contato(
      id: row.id,
      entidade: TipoEntidadeContato.values.byName(row.entidade),
      entidadeId: row.entidadeId,
      tipo: TipoContato.values.byName(row.tipo),
      valor: row.valor,
      observacao: row.observacao,
    );
  }
}
