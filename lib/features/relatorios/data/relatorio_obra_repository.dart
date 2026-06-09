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

    final etapas = await (_database.select(_database.etapas)
          ..where((table) => table.obraId.equals(obraId)))
        .get();
    final etapaIds = etapas.map((etapa) => etapa.id).toList();

    final servicos = etapaIds.isEmpty
        ? <db.Servico>[]
        : await (_database.select(_database.servicos)
              ..where((table) => table.etapaId.isIn(etapaIds))
              ..orderBy([(table) => OrderingTerm.asc(table.nome)]))
            .get();
    final servicoIds = servicos.map((servico) => servico.id).toList();

    final medicoes = servicoIds.isEmpty
        ? <db.Medicoe>[]
        : await (_database.select(_database.medicoes)
              ..where((table) => table.servicoId.isIn(servicoIds))
              ..orderBy([(table) => OrderingTerm.desc(table.data)]))
            .get();
    final medicaoIds = medicoes.map((medicao) => medicao.id).toList();

    final fotos = medicaoIds.isEmpty
        ? <db.Foto>[]
        : await (_database.select(_database.fotos)
              ..where((table) => table.medicaoId.isIn(medicaoIds))
              ..orderBy([(table) => OrderingTerm.asc(table.id)]))
            .get();

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

    return RelatorioObraDados(
      obra: _mapObra(obra),
      servicos: servicos.map(_mapServico).toList(),
      medicoes: medicoes.map(_mapMedicao).toList(),
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

  RelatorioServicoInfo _mapServico(db.Servico row) {
    return RelatorioServicoInfo(
      id: row.id,
      nome: row.nome,
      status: StatusExecucao.values.byName(row.status),
      progressoFisico: row.progressoFisico,
      quantidade: row.quantidade,
      unidade: row.unidade,
      precoTotal: row.precoTotal,
    );
  }

  RelatorioMedicaoInfo _mapMedicao(db.Medicoe row) {
    return RelatorioMedicaoInfo(
      id: row.id,
      servicoId: row.servicoId,
      percentualExecutado: row.percentualExecutado,
      data: row.data,
      observacao: row.observacao,
    );
  }

  RelatorioFiscalizacaoInfo _mapFiscalizacao(db.VistoriasServicoData row) {
    return RelatorioFiscalizacaoInfo(
      id: row.id,
      numero: row.numero,
      servicoId: row.servicoId,
      data: row.data,
      status: StatusFiscalizacao.values.byName(row.status),
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

  RelatorioFotoInfo _mapFoto(db.Foto row) {
    return RelatorioFotoInfo(
      medicaoId: row.medicaoId,
      caminhoArquivo: row.caminhoArquivo,
    );
  }
}
