import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../../cadastros/domain/funcionario.dart';
import '../domain/vistoria_mao_de_obra.dart';

abstract class VistoriasMaoDeObraRepository {
  Stream<List<VistoriaMaoDeObra>> watchMaoDeObraDaVistoria(
    String vistoriaServicoId,
  );

  Stream<List<Funcionario>> watchFuncionariosDaEmpresaDaVistoria(
    String vistoriaServicoId,
  );

  Future<String?> buscarEmpresaIdDaVistoria(String vistoriaServicoId);

  Future<void> salvarMaoDeObra(VistoriaMaoDeObra maoDeObra);

  Future<void> removerMaoDeObra(String id);
}

class MaoDeObraFuncionarioInvalidoException implements Exception {
  const MaoDeObraFuncionarioInvalidoException(this.funcionarioId);

  final String funcionarioId;

  @override
  String toString() {
    return 'Funcionario $funcionarioId nao pertence a empresa contratada.';
  }
}

class MaoDeObraDuplicadaException implements Exception {
  const MaoDeObraDuplicadaException(this.funcionarioId);

  final String funcionarioId;

  @override
  String toString() {
    return 'Funcionario $funcionarioId ja esta na mao de obra desta vistoria.';
  }
}

class DriftVistoriasMaoDeObraRepository
    implements VistoriasMaoDeObraRepository {
  const DriftVistoriasMaoDeObraRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<VistoriaMaoDeObra>> watchMaoDeObraDaVistoria(
    String vistoriaServicoId,
  ) {
    final query = _database.select(_database.vistoriasMaoDeObra)
      ..where((table) => table.vistoriaServicoId.equals(vistoriaServicoId))
      ..orderBy([(table) => OrderingTerm.asc(table.funcionarioId)]);

    return query.watch().map((rows) => rows.map(_mapMaoDeObra).toList());
  }

  @override
  Stream<List<Funcionario>> watchFuncionariosDaEmpresaDaVistoria(
    String vistoriaServicoId,
  ) async* {
    final empresaId = await _empresaIdDaVistoria(vistoriaServicoId);
    if (empresaId == null) {
      yield const <Funcionario>[];
      return;
    }

    final query = _database.select(_database.funcionarios)
      ..where((table) => table.empresaId.equals(empresaId))
      ..orderBy([(table) => OrderingTerm.asc(table.nome)]);

    yield* query.watch().map((rows) => rows.map(_mapFuncionario).toList());
  }

  @override
  Future<String?> buscarEmpresaIdDaVistoria(String vistoriaServicoId) {
    return _empresaIdDaVistoria(vistoriaServicoId);
  }

  @override
  Future<void> salvarMaoDeObra(VistoriaMaoDeObra maoDeObra) {
    return _database.transaction(() async {
      await _validarFuncionarioDaEmpresaContratada(maoDeObra);
      await _garantirFuncionarioUnicoNaVistoria(maoDeObra);

      final existente = await (_database.select(_database.vistoriasMaoDeObra)
            ..where((table) => table.id.equals(maoDeObra.id)))
          .getSingleOrNull();

      final companion = db.VistoriasMaoDeObraCompanion(
        id: Value(maoDeObra.id),
        vistoriaServicoId: Value(maoDeObra.vistoriaServicoId),
        funcionarioId: Value(maoDeObra.funcionarioId),
        funcaoNoDia: Value(maoDeObra.funcaoNoDia),
        observacao: Value(maoDeObra.observacao),
      );

      if (existente == null) {
        await _database.into(_database.vistoriasMaoDeObra).insert(companion);
        return;
      }

      await (_database.update(_database.vistoriasMaoDeObra)
            ..where((table) => table.id.equals(maoDeObra.id)))
          .write(companion);
    });
  }

  @override
  Future<void> removerMaoDeObra(String id) {
    return (_database.delete(_database.vistoriasMaoDeObra)
          ..where((table) => table.id.equals(id)))
        .go();
  }

  Future<void> _validarFuncionarioDaEmpresaContratada(
    VistoriaMaoDeObra maoDeObra,
  ) async {
    final empresaId = await _empresaIdDaVistoria(maoDeObra.vistoriaServicoId);
    final funcionario = await (_database.select(_database.funcionarios)
          ..where((table) => table.id.equals(maoDeObra.funcionarioId)))
        .getSingleOrNull();

    if (empresaId == null ||
        funcionario == null ||
        funcionario.empresaId != empresaId) {
      throw MaoDeObraFuncionarioInvalidoException(maoDeObra.funcionarioId);
    }
  }

  Future<void> _garantirFuncionarioUnicoNaVistoria(
    VistoriaMaoDeObra maoDeObra,
  ) async {
    final duplicada = await (_database.select(_database.vistoriasMaoDeObra)
          ..where((table) {
            return table.vistoriaServicoId.equals(maoDeObra.vistoriaServicoId) &
                table.funcionarioId.equals(maoDeObra.funcionarioId) &
                table.id.equals(maoDeObra.id).not();
          }))
        .getSingleOrNull();

    if (duplicada != null) {
      throw MaoDeObraDuplicadaException(maoDeObra.funcionarioId);
    }
  }

  Future<String?> _empresaIdDaVistoria(String vistoriaServicoId) async {
    final vistoria = await (_database.select(_database.vistoriasServico)
          ..where((table) => table.id.equals(vistoriaServicoId)))
        .getSingleOrNull();

    if (vistoria == null) {
      return null;
    }

    final obra = await (_database.select(_database.obras)
          ..where((table) => table.id.equals(vistoria.obraId)))
        .getSingleOrNull();

    return obra?.empresaId;
  }

  VistoriaMaoDeObra _mapMaoDeObra(db.VistoriasMaoDeObraData row) {
    return VistoriaMaoDeObra(
      id: row.id,
      vistoriaServicoId: row.vistoriaServicoId,
      funcionarioId: row.funcionarioId,
      funcaoNoDia: row.funcaoNoDia,
      observacao: row.observacao,
    );
  }

  Funcionario _mapFuncionario(db.Funcionario row) {
    return Funcionario(
      id: row.id,
      empresaId: row.empresaId,
      contratanteId: row.contratanteId,
      nome: row.nome,
      cpf: row.cpf,
      telefone: row.telefone,
      cargo: row.cargo,
      tipo: row.tipo,
      assinaturaPath: row.assinaturaPath,
    );
  }
}
