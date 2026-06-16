import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/domain/domain_enums.dart';
import '../../cadastros/domain/endereco.dart';
import '../domain/obra.dart';

abstract class ObrasRepository {
  Stream<List<Obra>> watchObras();

  Future<void> salvarObra(Obra obra);

  Future<void> salvarObraComEndereco({
    required Obra obra,
    required Endereco endereco,
  });
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
            contratanteId: Value(obra.contratanteId),
            enderecoId: obra.enderecoId,
            nome: obra.nome,
            responsavelNome: Value(obra.responsavelNome),
            responsavelContato: Value(obra.responsavelContato),
            dataInicio: obra.dataInicio,
            dataFim: obra.dataFim,
            status: obra.status.name,
            progressoFisico: Value(obra.progressoFisico),
            progressoPrazoDias: Value(obra.progressoPrazoDias),
          ),
        );
  }

  @override
  Future<void> salvarObraComEndereco({
    required Obra obra,
    required Endereco endereco,
  }) {
    return _database.transaction(() async {
      await _database.into(_database.enderecos).insertOnConflictUpdate(
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

      await salvarObra(obra);
    });
  }

  Obra _mapObra(db.Obra row) {
    return Obra(
      id: row.id,
      empresaId: row.empresaId,
      contratanteId: row.contratanteId,
      enderecoId: row.enderecoId,
      nome: row.nome,
      responsavelNome: row.responsavelNome,
      responsavelContato: row.responsavelContato,
      dataInicio: row.dataInicio,
      dataFim: row.dataFim,
      status: StatusExecucao.values.byName(row.status),
      progressoFisico: row.progressoFisico,
      progressoPrazoDias: row.progressoPrazoDias,
    );
  }
}
