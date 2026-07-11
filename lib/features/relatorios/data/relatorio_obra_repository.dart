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
    final funcionariosPorId = await _buscarFuncionariosPorId(
      maoDeObra.map((item) => item.funcionarioId),
    );

    final fotos = fiscalizacaoIds.isEmpty
        ? <db.VistoriasFoto>[]
        : await (_database.select(_database.vistoriasFotos)
              ..where((table) => table.vistoriaServicoId.isIn(fiscalizacaoIds))
              ..orderBy([(table) => OrderingTerm.asc(table.id)]))
            .get();
    final responsavel = fiscalizacoes.isEmpty
        ? null
        : await _buscarFuncionario(fiscalizacoes.first.responsavelId);

    return RelatorioObraDados(
      obra: _mapObra(obra),
      servicos: const [],
      medicoes: const [],
      fiscalizacoes: fiscalizacoes.map(_mapFiscalizacao).toList(),
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

  Future<Map<String, String>> _buscarFuncionariosPorId(
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
      for (final funcionario in funcionarios) funcionario.id: funcionario.nome,
    };
  }

  Future<db.Funcionario?> _buscarFuncionario(String funcionarioId) {
    return (_database.select(_database.funcionarios)
          ..where((table) => table.id.equals(funcionarioId)))
        .getSingleOrNull();
  }

  RelatorioMaoDeObraInfo _mapMaoDeObra(
    db.VistoriasMaoDeObraData row,
    Map<String, String> funcionariosPorId,
  ) {
    return RelatorioMaoDeObraInfo(
      vistoriaServicoId: row.vistoriaServicoId,
      funcionarioId: row.funcionarioId,
      funcionarioNome: funcionariosPorId[row.funcionarioId],
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
