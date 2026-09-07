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
    final responsavel = await _buscarFuncionario(fiscalizacao.responsavelId);
    final funcionariosPorId = await _buscarFuncionariosPorId(
      maoDeObra.map((item) => item.funcionarioId),
    );

    return RelatorioFiscalizacaoDados(
      obra: _mapObra(obra),
      etapa: _mapEtapa(etapa),
      fiscalizacao: _mapFiscalizacao(fiscalizacao),
      periodos: periodos.map(_mapPeriodo).toList(),
      maoDeObra: maoDeObra
          .map((item) => _mapMaoDeObra(item, funcionariosPorId))
          .toList(),
      fotos: fotos.map(_mapFoto).toList(),
      assinatura: _mapAssinatura(responsavel),
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

  Future<Map<String, db.Funcionario>> _buscarFuncionariosPorId(
    Iterable<String> funcionarioIds,
  ) async {
    final ids = funcionarioIds.toSet().toList();
    if (ids.isEmpty) {
      return const {};
    }

    final funcionarios = await (_database.select(_database.funcionarios)
          ..where((table) => table.id.isIn(ids)))
        .get();

    return {
      for (final funcionario in funcionarios) funcionario.id: funcionario,
    };
  }

  Future<db.Funcionario?> _buscarFuncionario(String funcionarioId) {
    return (_database.select(_database.funcionarios)
          ..where((table) => table.id.equals(funcionarioId)))
        .getSingleOrNull();
  }

  RelatorioMaoDeObraInfo _mapMaoDeObra(
    db.VistoriasMaoDeObraData row,
    Map<String, db.Funcionario> funcionariosPorId,
  ) {
    final funcionario = funcionariosPorId[row.funcionarioId];

    return RelatorioMaoDeObraInfo(
      vistoriaServicoId: row.vistoriaServicoId,
      funcionarioId: row.funcionarioId,
      funcionarioNome: row.funcionarioNomeSnapshot ?? funcionario?.nome,
      funcionarioCargo: row.funcionarioCargoSnapshot ?? funcionario?.cargo,
      funcionarioTelefone:
          row.funcionarioTelefoneSnapshot ?? funcionario?.telefone,
      funcaoNoDia: row.funcaoNoDia,
      observacao: row.observacao,
    );
  }

  RelatorioFotoInfo _mapFoto(db.VistoriasFoto row) {
    return RelatorioFotoInfo(
      vistoriaServicoId: row.vistoriaServicoId,
      caminhoArquivo: row.caminhoArquivo,
      uriGaleria: row.uriGaleria,
      legenda: row.legenda,
    );
  }

  RelatorioAssinaturaInfo? _mapAssinatura(db.Funcionario? row) {
    if (row == null) {
      return null;
    }

    return RelatorioAssinaturaInfo(
      nome: row.nome,
      assinaturaPath: row.assinaturaPath,
    );
  }
}
