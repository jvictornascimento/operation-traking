import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/domain/domain_enums.dart';
import '../domain/vistoria_servico.dart';

abstract class VistoriasServicoRepository {
  Stream<List<VistoriaServico>> watchVistoriasDoServico(String servicoId);

  Future<List<VistoriaServico>> listarVistoriasDoServico(String servicoId);

  Future<void> salvarVistoria(VistoriaServico vistoria);
}

class DriftVistoriasServicoRepository implements VistoriasServicoRepository {
  const DriftVistoriasServicoRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<VistoriaServico>> watchVistoriasDoServico(String servicoId) {
    final query = _database.select(_database.vistoriasServico)
      ..where((table) => table.servicoId.equals(servicoId))
      ..orderBy([(table) => OrderingTerm.desc(table.data)]);

    return query.watch().map((rows) => rows.map(_mapVistoria).toList());
  }

  @override
  Future<List<VistoriaServico>> listarVistoriasDoServico(String servicoId) {
    final query = _database.select(_database.vistoriasServico)
      ..where((table) => table.servicoId.equals(servicoId));

    return query.get().then((rows) => rows.map(_mapVistoria).toList());
  }

  @override
  Future<void> salvarVistoria(VistoriaServico vistoria) {
    return _database.into(_database.vistoriasServico).insertOnConflictUpdate(
          db.VistoriasServicoCompanion.insert(
            id: vistoria.id,
            servicoId: vistoria.servicoId,
            obraId: vistoria.obraId,
            contratanteId: vistoria.contratanteId,
            responsavelId: vistoria.responsavelId,
            numero: vistoria.numero,
            data: vistoria.data,
            diaSemana: vistoria.diaSemana,
            status: vistoria.status.name,
            ocorrencia: Value(vistoria.ocorrencia),
            comentario: Value(vistoria.comentario),
          ),
        );
  }

  VistoriaServico _mapVistoria(db.VistoriasServicoData row) {
    return VistoriaServico(
      id: row.id,
      servicoId: row.servicoId,
      obraId: row.obraId,
      contratanteId: row.contratanteId,
      responsavelId: row.responsavelId,
      numero: row.numero,
      data: row.data,
      diaSemana: row.diaSemana,
      status: StatusFiscalizacao.values.byName(row.status),
      ocorrencia: row.ocorrencia,
      comentario: row.comentario,
    );
  }
}
