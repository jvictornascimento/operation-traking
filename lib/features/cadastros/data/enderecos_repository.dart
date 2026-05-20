import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/domain/domain_enums.dart';
import '../domain/endereco.dart';

abstract class EnderecosRepository {
  Stream<List<Endereco>> watchEnderecos({
    required TipoEntidadeEndereco entidade,
    required String entidadeId,
  });

  Future<void> salvarEndereco(Endereco endereco);
}

class DriftEnderecosRepository implements EnderecosRepository {
  const DriftEnderecosRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Endereco>> watchEnderecos({
    required TipoEntidadeEndereco entidade,
    required String entidadeId,
  }) {
    final query = _database.select(_database.enderecos)
      ..where((table) {
        return table.entidade.equals(entidade.name) &
            table.entidadeId.equals(entidadeId);
      })
      ..orderBy([(table) => OrderingTerm.asc(table.tipo)]);

    return query.watch().map((rows) => rows.map(_mapEndereco).toList());
  }

  @override
  Future<void> salvarEndereco(Endereco endereco) {
    return _database.into(_database.enderecos).insertOnConflictUpdate(
          db.EnderecosCompanion.insert(
            id: endereco.id,
            entidade: endereco.entidade.name,
            entidadeId: endereco.entidadeId,
            tipo: endereco.tipo,
            cep: Value(endereco.cep),
            logradouro: Value(endereco.logradouro),
            numero: Value(endereco.numero),
            complemento: Value(endereco.complemento),
            bairro: Value(endereco.bairro),
            cidade: endereco.cidade,
            estado: endereco.estado,
            pais: Value(endereco.pais),
          ),
        );
  }

  Endereco _mapEndereco(db.Endereco row) {
    return Endereco(
      id: row.id,
      entidade: TipoEntidadeEndereco.values.byName(row.entidade),
      entidadeId: row.entidadeId,
      tipo: row.tipo,
      cep: row.cep,
      logradouro: row.logradouro,
      numero: row.numero,
      complemento: row.complemento,
      bairro: row.bairro,
      cidade: row.cidade,
      estado: row.estado,
      pais: row.pais,
    );
  }
}
