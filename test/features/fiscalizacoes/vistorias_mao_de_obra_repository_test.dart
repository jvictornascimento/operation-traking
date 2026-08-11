import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/database/app_database.dart' as db;
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/fiscalizacoes/data/vistorias_mao_de_obra_repository.dart';
import 'package:operational_tracking/features/fiscalizacoes/domain/vistoria_mao_de_obra.dart';
import 'package:sqlite3/open.dart';

void main() {
  late db.AppDatabase database;
  late DriftVistoriasMaoDeObraRepository repository;

  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
  });

  setUp(() async {
    database = db.AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftVistoriasMaoDeObraRepository(database);
    await _popularDadosBase(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Story 4.4 - VistoriasMaoDeObraRepository', () {
    test('lista somente funcionarios da empresa contratada da obra', () async {
      final funcionarios = await repository
          .watchFuncionariosDaEmpresaDaVistoria('vistoria-1')
          .first;

      expect(funcionarios.map((item) => item.id), [
        'funcionario-empresa-1',
        'funcionario-empresa-2',
      ]);
    });

    test('salva funcionario da empresa contratada como mao de obra', () async {
      await repository.salvarMaoDeObra(
        _maoDeObra(
          id: 'mao-obra-1',
          funcionarioId: 'funcionario-empresa-1',
          funcaoNoDia: 'Pedreiro',
          observacao: 'Frente norte',
        ),
      );

      final rows = await database.select(database.vistoriasMaoDeObra).get();

      expect(rows, hasLength(1));
      expect(rows.single.vistoriaServicoId, 'vistoria-1');
      expect(rows.single.funcionarioId, 'funcionario-empresa-1');
      expect(rows.single.funcionarioNomeSnapshot, 'Ana');
      expect(rows.single.funcionarioCargoSnapshot, 'Pedreira');
      expect(rows.single.funcaoNoDia, 'Pedreiro');
      expect(rows.single.observacao, 'Frente norte');
    });

    test('rejeita funcionario de contratante como mao de obra', () async {
      expect(
        () => repository.salvarMaoDeObra(
          _maoDeObra(
            id: 'mao-obra-1',
            funcionarioId: 'funcionario-contratante-1',
          ),
        ),
        throwsA(isA<MaoDeObraFuncionarioInvalidoException>()),
      );
    });

    test('rejeita funcionario de outra empresa', () async {
      expect(
        () => repository.salvarMaoDeObra(
          _maoDeObra(
            id: 'mao-obra-1',
            funcionarioId: 'funcionario-outra-empresa',
          ),
        ),
        throwsA(isA<MaoDeObraFuncionarioInvalidoException>()),
      );
    });

    test('rejeita funcionario inativo da empresa contratada', () async {
      expect(
        () => repository.salvarMaoDeObra(
          _maoDeObra(
            id: 'mao-obra-1',
            funcionarioId: 'funcionario-inativo',
          ),
        ),
        throwsA(isA<MaoDeObraFuncionarioInvalidoException>()),
      );
    });

    test('rejeita funcionario duplicado na mesma vistoria', () async {
      await repository.salvarMaoDeObra(
        _maoDeObra(
          id: 'mao-obra-1',
          funcionarioId: 'funcionario-empresa-1',
        ),
      );

      expect(
        () => repository.salvarMaoDeObra(
          _maoDeObra(
            id: 'mao-obra-2',
            funcionarioId: 'funcionario-empresa-1',
          ),
        ),
        throwsA(isA<MaoDeObraDuplicadaException>()),
      );
    });

    test('permite editar o mesmo registro de mao de obra', () async {
      await repository.salvarMaoDeObra(
        _maoDeObra(
          id: 'mao-obra-1',
          funcionarioId: 'funcionario-empresa-1',
          funcaoNoDia: 'Ajudante',
        ),
      );
      await repository.salvarMaoDeObra(
        _maoDeObra(
          id: 'mao-obra-1',
          funcionarioId: 'funcionario-empresa-1',
          funcaoNoDia: 'Pedreiro',
          observacao: 'Realocado',
        ),
      );

      final rows = await database.select(database.vistoriasMaoDeObra).get();
      expect(rows, hasLength(1));
      expect(rows.single.funcaoNoDia, 'Pedreiro');
      expect(rows.single.observacao, 'Realocado');
    });

    test('remove funcionario da lista de mao de obra', () async {
      await repository.salvarMaoDeObra(
        _maoDeObra(
          id: 'mao-obra-1',
          funcionarioId: 'funcionario-empresa-1',
        ),
      );

      await repository.removerMaoDeObra('mao-obra-1');

      final rows = await database.select(database.vistoriasMaoDeObra).get();
      expect(rows, isEmpty);
    });
  });
}

VistoriaMaoDeObra _maoDeObra({
  required String id,
  required String funcionarioId,
  String? funcaoNoDia,
  String? observacao,
}) {
  return VistoriaMaoDeObra(
    id: id,
    vistoriaServicoId: 'vistoria-1',
    funcionarioId: funcionarioId,
    funcaoNoDia: funcaoNoDia,
    observacao: observacao,
  );
}

Future<void> _popularDadosBase(db.AppDatabase database) async {
  await database.into(database.empresas).insert(
        db.EmpresasCompanion.insert(
          id: 'empresa-1',
          nome: 'Construtora Regis',
        ),
      );
  await database.into(database.empresas).insert(
        db.EmpresasCompanion.insert(
          id: 'empresa-2',
          nome: 'Outra Construtora',
        ),
      );

  await database.into(database.contratantes).insert(
        db.ContratantesCompanion.insert(
          id: 'contratante-1',
          nome: 'Cliente Regis',
        ),
      );

  await database.into(database.funcionarios).insert(
        db.FuncionariosCompanion.insert(
          id: 'funcionario-empresa-2',
          empresaId: const Value('empresa-1'),
          nome: 'Bruno',
          cargo: 'Carpinteiro',
        ),
      );
  await database.into(database.funcionarios).insert(
        db.FuncionariosCompanion.insert(
          id: 'funcionario-empresa-1',
          empresaId: const Value('empresa-1'),
          nome: 'Ana',
          cargo: 'Pedreira',
        ),
      );
  await database.into(database.funcionarios).insert(
        db.FuncionariosCompanion.insert(
          id: 'funcionario-outra-empresa',
          empresaId: const Value('empresa-2'),
          nome: 'Carlos',
          cargo: 'Ajudante',
        ),
      );
  await database.into(database.funcionarios).insert(
        db.FuncionariosCompanion.insert(
          id: 'funcionario-inativo',
          empresaId: const Value('empresa-1'),
          nome: 'Davi',
          cargo: 'Eletricista',
          ativo: const Value(false),
          excluidoEm: Value(DateTime(2026, 5, 2)),
        ),
      );
  await database.into(database.funcionarios).insert(
        db.FuncionariosCompanion.insert(
          id: 'funcionario-contratante-1',
          contratanteId: const Value('contratante-1'),
          nome: 'Regis',
          cargo: 'Fiscal',
        ),
      );

  await database.into(database.enderecos).insert(
        db.EnderecosCompanion.insert(
          id: 'endereco-1',
          entidade: TipoEntidadeEndereco.obra.name,
          entidadeId: 'obra-1',
          tipo: 'Principal',
          cidade: 'Campinas',
          estado: 'SP',
        ),
      );

  await database.into(database.obras).insert(
        db.ObrasCompanion.insert(
          id: 'obra-1',
          empresaId: 'empresa-1',
          enderecoId: 'endereco-1',
          nome: 'Obra Regis',
          dataInicio: DateTime(2026, 5, 1),
          dataFim: DateTime(2026, 6, 1),
          status: StatusExecucao.emAndamento.name,
        ),
      );

  await database.into(database.etapas).insert(
        db.EtapasCompanion.insert(
          id: 'etapa-1',
          obraId: 'obra-1',
          nome: 'Fundacao',
          dataInicio: DateTime(2026, 5, 1),
          dataFim: DateTime(2026, 5, 15),
          status: StatusExecucao.emAndamento.name,
        ),
      );

  await database.into(database.servicos).insert(
        db.ServicosCompanion.insert(
          id: 'servico-1',
          etapaId: 'etapa-1',
          nome: 'Escavacao',
          precoTotal: 1000,
          unidade: 'm3',
          quantidade: 10,
          dataInicio: DateTime(2026, 5, 1),
          dataFim: DateTime(2026, 5, 10),
          status: StatusExecucao.emAndamento.name,
        ),
      );

  await database.into(database.vistoriasServico).insert(
        db.VistoriasServicoCompanion.insert(
          id: 'vistoria-1',
          servicoId: 'servico-1',
          obraId: 'obra-1',
          contratanteId: 'contratante-1',
          responsavelId: 'funcionario-contratante-1',
          numero: '001',
          data: DateTime(2026, 5, 20),
          diaSemana: DateTime.wednesday,
          status: StatusFiscalizacao.emAndamento.name,
        ),
      );
}
