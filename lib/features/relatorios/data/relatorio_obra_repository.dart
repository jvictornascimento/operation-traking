import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/domain/domain_enums.dart';
import '../domain/relatorio_obra_dados.dart';

abstract class RelatorioObraRepository {
  Future<RelatorioObraDados> carregarDadosDaObra(String obraId);
}

class ObraRelatorioNaoEncontradaException implements Exception {
  const ObraRelatorioNaoEncontradaException(this.obraId);

  final String obraId;

  @override
  String toString() {
    return 'Obra $obraId nao encontrada para geracao do relatorio.';
  }
}

class DriftRelatorioObraRepository implements RelatorioObraRepository {
  const DriftRelatorioObraRepository(this._database);

  final db.AppDatabase _database;

  @override
  Future<RelatorioObraDados> carregarDadosDaObra(String obraId) async {
    final obra = await (_database.select(_database.obras)
          ..where((table) => table.id.equals(obraId)))
        .getSingleOrNull();

    if (obra == null) {
      throw ObraRelatorioNaoEncontradaException(obraId);
    }

    final fiscalizacoes = await (_database.select(_database.vistoriasServico)
          ..where((table) => table.obraId.equals(obraId))
          ..orderBy([(table) => OrderingTerm.desc(table.data)]))
        .get();
    final fiscalizacaoIds =
        fiscalizacoes.map((fiscalizacao) => fiscalizacao.id).toList();

    final maoDeObra = fiscalizacaoIds.isEmpty
        ? <db.VistoriasMaoDeObraData>[]
        : await (_database.select(_database.vistoriasMaoDeObra)
              ..where((table) => table.vistoriaServicoId.isIn(fiscalizacaoIds))
              ..orderBy([(table) => OrderingTerm.asc(table.funcionarioId)]))
            .get();

    final fotos = fiscalizacaoIds.isEmpty
        ? <db.VistoriasFoto>[]
        : await (_database.select(_database.vistoriasFotos)
              ..where((table) => table.vistoriaServicoId.isIn(fiscalizacaoIds))
              ..orderBy([(table) => OrderingTerm.asc(table.id)]))
            .get();

    return RelatorioObraDados(
      obra: _mapObra(obra),
      servicos: const [],
      medicoes: const [],
      fiscalizacoes: fiscalizacoes.map(_mapFiscalizacao).toList(),
      maoDeObra: maoDeObra.map(_mapMaoDeObra).toList(),
      fotos: fotos.map(_mapFoto).toList(),
    );
  }

  RelatorioObraInfo _mapObra(db.Obra row) {
    return RelatorioObraInfo(
      id: row.id,
      nome: row.nome,
      status: StatusExecucao.values.byName(row.status),
      progressoFisico: row.progressoFisico,
      progressoPrazoDias: row.progressoPrazoDias,
      dataInicio: row.dataInicio,
      dataFim: row.dataFim,
    );
  }

  RelatorioFiscalizacaoInfo _mapFiscalizacao(db.VistoriasServicoData row) {
    return RelatorioFiscalizacaoInfo(
      id: row.id,
      numero: row.numero,
      etapaId: row.etapaId,
      servicoId: row.servicoId,
      data: row.data,
      status: StatusFiscalizacao.values.byName(row.status),
      atividade: row.atividade,
      ocorrencia: row.ocorrencia,
      comentario: row.comentario,
    );
  }

  RelatorioMaoDeObraInfo _mapMaoDeObra(db.VistoriasMaoDeObraData row) {
    return RelatorioMaoDeObraInfo(
      vistoriaServicoId: row.vistoriaServicoId,
      funcionarioId: row.funcionarioId,
      funcaoNoDia: row.funcaoNoDia,
      observacao: row.observacao,
    );
  }

  RelatorioFotoInfo _mapFoto(db.VistoriasFoto row) {
    return RelatorioFotoInfo(
      vistoriaServicoId: row.vistoriaServicoId,
      caminhoArquivo: row.caminhoArquivo,
    );
  }
}
