import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/domain/domain_enums.dart';
import '../domain/vistoria_servico.dart';

abstract class VistoriasServicoRepository {
  Stream<List<VistoriaServico>> watchVistoriasDoServico(String servicoId);

  Future<void> salvarVistoria(VistoriaServico vistoria);
}

class VistoriaServicoDuplicadaException implements Exception {
  const VistoriaServicoDuplicadaException(this.servicoId, this.data);

  final String servicoId;
  final DateTime data;

  @override
  String toString() {
    return 'Ja existe fiscalizacao para o servico $servicoId '
        'na data ${data.day}/${data.month}/${data.year}.';
  }
}

class NumeroVistoriaDuplicadoException implements Exception {
  const NumeroVistoriaDuplicadoException(this.numero);

  final String numero;

  @override
  String toString() {
    return 'Ja existe fiscalizacao com o numero $numero.';
  }
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
  Future<void> salvarVistoria(VistoriaServico vistoria) {
    return _database.transaction(() async {
      final dataNormalizada = _normalizarData(vistoria.data);
      await _garantirVistoriaUnica(
        id: vistoria.id,
        servicoId: vistoria.servicoId,
        data: dataNormalizada,
      );
      await _garantirNumeroUnico(
        id: vistoria.id,
        numero: vistoria.numero,
      );

      final existente = await (_database.select(_database.vistoriasServico)
            ..where((table) => table.id.equals(vistoria.id)))
          .getSingleOrNull();

      final companion = db.VistoriasServicoCompanion(
        id: Value(vistoria.id),
        servicoId: Value(vistoria.servicoId),
        obraId: Value(vistoria.obraId),
        contratanteId: Value(vistoria.contratanteId),
        responsavelId: Value(vistoria.responsavelId),
        numero: Value(vistoria.numero),
        data: Value(dataNormalizada),
        diaSemana: Value(dataNormalizada.weekday),
        status: Value(vistoria.status.name),
        ocorrencia: Value(vistoria.ocorrencia),
        comentario: Value(vistoria.comentario),
      );

      if (existente == null) {
        await _database.into(_database.vistoriasServico).insert(companion);
        return;
      }

      await (_database.update(_database.vistoriasServico)
            ..where((table) => table.id.equals(vistoria.id)))
          .write(companion);
    });
  }

  Future<void> _garantirVistoriaUnica({
    required String id,
    required String servicoId,
    required DateTime data,
  }) async {
    final duplicada = await (_database.select(_database.vistoriasServico)
          ..where((table) {
            return table.servicoId.equals(servicoId) &
                table.data.equals(data) &
                table.id.equals(id).not();
          }))
        .getSingleOrNull();

    if (duplicada != null) {
      throw VistoriaServicoDuplicadaException(servicoId, data);
    }
  }

  Future<void> _garantirNumeroUnico({
    required String id,
    required String numero,
  }) async {
    final duplicada = await (_database.select(_database.vistoriasServico)
          ..where((table) {
            return table.numero.equals(numero) & table.id.equals(id).not();
          }))
        .getSingleOrNull();

    if (duplicada != null) {
      throw NumeroVistoriaDuplicadoException(numero);
    }
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

  DateTime _normalizarData(DateTime data) {
    return DateTime(data.year, data.month, data.day);
  }
}
