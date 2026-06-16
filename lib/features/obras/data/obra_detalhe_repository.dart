import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/domain/domain_enums.dart';
import '../../etapas/domain/etapa.dart';
import '../../fiscalizacoes/domain/vistoria_servico.dart';
import '../../servicos/domain/servico.dart';
import '../domain/obra.dart';
import '../domain/obra_detalhe.dart';

abstract class ObraDetalheRepository {
  Stream<ObraDetalhe?> watchDetalheDaObra(String obraId);
}

class DriftObraDetalheRepository implements ObraDetalheRepository {
  const DriftObraDetalheRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<ObraDetalhe?> watchDetalheDaObra(String obraId) {
    final trigger = _database.customSelect(
      '''
      SELECT o.id
      FROM obras o
      LEFT JOIN etapas e ON e.obra_id = o.id
      LEFT JOIN servicos s ON s.etapa_id = e.id
      LEFT JOIN vistorias_servico vs ON vs.obra_id = o.id
      WHERE o.id = ?
      GROUP BY o.id
      ''',
      variables: [Variable<String>(obraId)],
      readsFrom: {
        _database.obras,
        _database.etapas,
        _database.servicos,
        _database.vistoriasServico,
      },
    );

    return trigger.watch().asyncMap((_) => _carregarDetalhe(obraId));
  }

  Future<ObraDetalhe?> _carregarDetalhe(String obraId) async {
    final obraRow = await (_database.select(_database.obras)
          ..where((table) => table.id.equals(obraId)))
        .getSingleOrNull();

    if (obraRow == null) {
      return null;
    }

    final etapasRows = await (_database.select(_database.etapas)
          ..where((table) => table.obraId.equals(obraId))
          ..orderBy([(table) => OrderingTerm.asc(table.nome)]))
        .get();

    final etapaIds = etapasRows.map((etapa) => etapa.id).toList();
    final servicosRows = etapaIds.isEmpty
        ? <db.Servico>[]
        : await (_database.select(_database.servicos)
              ..where((table) => table.etapaId.isIn(etapaIds))
              ..orderBy([(table) => OrderingTerm.asc(table.nome)]))
            .get();

    final fiscalizacoesRows =
        await (_database.select(_database.vistoriasServico)
              ..where((table) => table.obraId.equals(obraId))
              ..orderBy([(table) => OrderingTerm.desc(table.data)])
              ..limit(5))
            .get();

    final servicosPorEtapa = <String, List<Servico>>{};
    for (final row in servicosRows) {
      servicosPorEtapa.putIfAbsent(row.etapaId, () => []).add(_mapServico(row));
    }

    return ObraDetalhe(
      obra: _mapObra(obraRow),
      etapas: etapasRows.map(_mapEtapa).toList(),
      servicosPorEtapa: servicosPorEtapa,
      fiscalizacoesRecentes: fiscalizacoesRows.map(_mapVistoria).toList(),
    );
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

  Etapa _mapEtapa(db.Etapa row) {
    return Etapa(
      id: row.id,
      obraId: row.obraId,
      nome: row.nome,
      dataInicio: row.dataInicio,
      dataFim: row.dataFim,
      status: StatusExecucao.values.byName(row.status),
      progressoFisico: row.progressoFisico,
      progressoPrazoDias: row.progressoPrazoDias,
    );
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
