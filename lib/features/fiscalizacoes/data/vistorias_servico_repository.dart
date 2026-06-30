import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/domain/domain_enums.dart';
import '../../historico/data/historicos_repository.dart';
import '../domain/vistoria_servico.dart';

abstract class VistoriasServicoRepository {
  Stream<List<VistoriaServico>> watchVistoriasDoServico(String servicoId);

  Stream<List<VistoriaServico>> watchFiscalizacoes({
    String? servicoId,
    String? numero,
    StatusFiscalizacao? status,
    DateTime? data,
  });

  Future<String?> buscarObraIdDoServico(String servicoId);

  Future<ContextoFiscalizacaoServico?> buscarContextoDoServico(
    String servicoId,
  );

  Future<void> salvarVistoria(VistoriaServico vistoria);

  Future<void> atualizarTextosDaVistoria({
    required String id,
    String? ocorrencia,
    String? comentario,
  });
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

class ContextoFiscalizacaoServico {
  const ContextoFiscalizacaoServico({
    required this.obraId,
    required this.contratanteId,
    required this.responsavelId,
  });

  final String obraId;
  final String contratanteId;
  final String responsavelId;
}

class ContextoFiscalizacaoIncompletoException implements Exception {
  const ContextoFiscalizacaoIncompletoException(this.servicoId);

  final String servicoId;

  @override
  String toString() {
    return 'Nao foi possivel iniciar a fiscalizacao. Verifique se o servico '
        'esta dentro de uma etapa com obra, se a obra possui contratante e se '
        'existe um funcionario cadastrado para esse contratante.';
  }
}

class DriftVistoriasServicoRepository implements VistoriasServicoRepository {
  const DriftVistoriasServicoRepository(this._database);

  final db.AppDatabase _database;

  DriftHistoricosRepository get _historicosRepository {
    return DriftHistoricosRepository(_database);
  }

  @override
  Stream<List<VistoriaServico>> watchVistoriasDoServico(String servicoId) {
    return watchFiscalizacoes(servicoId: servicoId);
  }

  @override
  Stream<List<VistoriaServico>> watchFiscalizacoes({
    String? servicoId,
    String? numero,
    StatusFiscalizacao? status,
    DateTime? data,
  }) {
    final query = _database.select(_database.vistoriasServico)
      ..orderBy([(table) => OrderingTerm.desc(table.data)]);

    final servicoIdNormalizado = servicoId?.trim();
    if (servicoIdNormalizado != null && servicoIdNormalizado.isNotEmpty) {
      query.where((table) => table.servicoId.equals(servicoIdNormalizado));
    }

    final numeroNormalizado = numero?.trim();
    if (numeroNormalizado != null && numeroNormalizado.isNotEmpty) {
      query.where((table) => table.numero.like('%$numeroNormalizado%'));
    }

    if (status != null) {
      query.where((table) => table.status.equals(status.name));
    }

    if (data != null) {
      query.where((table) => table.data.equals(_normalizarData(data)));
    }

    return query.watch().map((rows) => rows.map(_mapVistoria).toList());
  }

  @override
  Future<String?> buscarObraIdDoServico(String servicoId) async {
    final contexto = await buscarContextoDoServico(servicoId);
    return contexto?.obraId;
  }

  @override
  Future<ContextoFiscalizacaoServico?> buscarContextoDoServico(
    String servicoId,
  ) async {
    final servico = await (_database.select(_database.servicos)
          ..where((table) => table.id.equals(servicoId)))
        .getSingleOrNull();

    if (servico == null) {
      return null;
    }

    final etapa = await (_database.select(_database.etapas)
          ..where((table) => table.id.equals(servico.etapaId)))
        .getSingleOrNull();

    if (etapa == null) {
      return null;
    }

    final obra = await (_database.select(_database.obras)
          ..where((table) => table.id.equals(etapa.obraId)))
        .getSingleOrNull();

    final contratanteId = obra?.contratanteId;
    if (obra == null || contratanteId == null || contratanteId.isEmpty) {
      return null;
    }

    final responsavel = await (_database.select(_database.funcionarios)
          ..where((table) => table.contratanteId.equals(contratanteId))
          ..orderBy([(table) => OrderingTerm.asc(table.nome)]))
        .getSingleOrNull();

    if (responsavel == null) {
      throw ContextoFiscalizacaoIncompletoException(servicoId);
    }

    return ContextoFiscalizacaoServico(
      obraId: obra.id,
      contratanteId: contratanteId,
      responsavelId: responsavel.id,
    );
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

      if (existente.status != vistoria.status.name) {
        await _historicosRepository.registrarAlteracao(
          entidade: 'fiscalizacao',
          entidadeId: vistoria.id,
          campo: 'status',
          valorAnterior: existente.status,
          valorNovo: vistoria.status.name,
        );
      }

      await _historicosRepository.registrarAlteracaoSeMudou(
        entidade: 'fiscalizacao',
        entidadeId: vistoria.id,
        campo: 'ocorrencia',
        valorAnterior: existente.ocorrencia,
        valorNovo: vistoria.ocorrencia,
      );
      await _historicosRepository.registrarAlteracaoSeMudou(
        entidade: 'fiscalizacao',
        entidadeId: vistoria.id,
        campo: 'comentario',
        valorAnterior: existente.comentario,
        valorNovo: vistoria.comentario,
      );
    });
  }

  @override
  Future<void> atualizarTextosDaVistoria({
    required String id,
    String? ocorrencia,
    String? comentario,
  }) {
    return _database.transaction(() async {
      final existente = await (_database.select(_database.vistoriasServico)
            ..where((table) => table.id.equals(id)))
          .getSingleOrNull();

      if (existente == null) {
        throw VistoriaServicoNaoEncontradaException(id);
      }

      await (_database.update(_database.vistoriasServico)
            ..where((table) => table.id.equals(id)))
          .write(
        db.VistoriasServicoCompanion(
          ocorrencia: Value(ocorrencia),
          comentario: Value(comentario),
        ),
      );

      await _historicosRepository.registrarAlteracaoSeMudou(
        entidade: 'fiscalizacao',
        entidadeId: id,
        campo: 'ocorrencia',
        valorAnterior: existente.ocorrencia,
        valorNovo: ocorrencia,
      );
      await _historicosRepository.registrarAlteracaoSeMudou(
        entidade: 'fiscalizacao',
        entidadeId: id,
        campo: 'comentario',
        valorAnterior: existente.comentario,
        valorNovo: comentario,
      );
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

class VistoriaServicoNaoEncontradaException implements Exception {
  const VistoriaServicoNaoEncontradaException(this.id);

  final String id;

  @override
  String toString() {
    return 'Fiscalizacao $id nao encontrada.';
  }
}
