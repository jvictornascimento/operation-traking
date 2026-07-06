import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/domain/domain_enums.dart';
import '../domain/relatorio_fiscalizacao_dados.dart';
import '../domain/relatorio_obra_dados.dart';

abstract class RelatorioFiscalizacaoRepository {
  Future<RelatorioFiscalizacaoDados> carregarDadosDaFiscalizacao(
    String vistoriaServicoId,
  );
}

class FiscalizacaoRelatorioNaoEncontradaException implements Exception {
  const FiscalizacaoRelatorioNaoEncontradaException(this.vistoriaServicoId);

  final String vistoriaServicoId;

  @override
  String toString() {
    return 'Fiscalizacao $vistoriaServicoId nao encontrada para geracao do relatorio.';
  }
}

class DriftRelatorioFiscalizacaoRepository
    implements RelatorioFiscalizacaoRepository {
  const DriftRelatorioFiscalizacaoRepository(this._database);

  final db.AppDatabase _database;

  @override
  Future<RelatorioFiscalizacaoDados> carregarDadosDaFiscalizacao(
    String vistoriaServicoId,
  ) async {
    final fiscalizacao = await (_database.select(_database.vistoriasServico)
          ..where((table) => table.id.equals(vistoriaServicoId)))
        .getSingleOrNull();

    if (fiscalizacao == null) {
      throw FiscalizacaoRelatorioNaoEncontradaException(vistoriaServicoId);
    }

    final obra = await (_database.select(_database.obras)
          ..where((table) => table.id.equals(fiscalizacao.obraId)))
        .getSingle();
    final etapa = await (_database.select(_database.etapas)
          ..where((table) => table.id.equals(fiscalizacao.etapaId ?? '')))
        .getSingle();

    final fotos = await (_database.select(_database.vistoriasFotos)
          ..where((table) => table.vistoriaServicoId.equals(vistoriaServicoId))
          ..orderBy([(table) => OrderingTerm.asc(table.id)]))
        .get();

    final periodos = await (_database.select(_database.vistoriasPeriodo)
          ..where((table) => table.vistoriaServicoId.equals(vistoriaServicoId))
          ..orderBy([(table) => OrderingTerm.asc(table.periodo)]))
        .get();

    final maoDeObra = await (_database.select(_database.vistoriasMaoDeObra)
          ..where((table) => table.vistoriaServicoId.equals(vistoriaServicoId))
          ..orderBy([(table) => OrderingTerm.asc(table.funcionarioId)]))
        .get();

    return RelatorioFiscalizacaoDados(
      obra: _mapObra(obra),
      etapa: _mapEtapa(etapa),
      fiscalizacao: _mapFiscalizacao(fiscalizacao),
      periodos: periodos.map(_mapPeriodo).toList(),
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

  RelatorioEtapaInfo _mapEtapa(db.Etapa row) {
    return RelatorioEtapaInfo(
      id: row.id,
      nome: row.nome,
      status: StatusExecucao.values.byName(row.status),
      progressoFisico: row.progressoFisico,
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

  RelatorioPeriodoInfo _mapPeriodo(db.VistoriasPeriodoData row) {
    return RelatorioPeriodoInfo(
      periodo: PeriodoDia.values.byName(row.periodo),
      tempo: TempoPeriodo.values.byName(row.tempo),
      condicao: CondicaoPeriodo.values.byName(row.condicao),
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
