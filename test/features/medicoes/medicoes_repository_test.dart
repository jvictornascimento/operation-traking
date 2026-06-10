import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/database/app_database.dart' as db;
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/medicoes/data/medicoes_repository.dart';
import 'package:operational_tracking/features/medicoes/domain/medicao.dart';
import 'package:sqlite3/open.dart';

void main() {
  late db.AppDatabase database;
  late DriftMedicoesRepository repository;

  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
  });

  setUp(() async {
    database = db.AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftMedicoesRepository(database);
    await _popularDadosBase(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Story 5.1 - MedicoesRepository', () {
    test('salva medicao do servico', () async {
      await repository.salvarMedicao(
        _medicao(
          id: 'medicao-1',
          percentualExecutado: 55,
          observacao: 'Concretagem parcial',
        ),
      );

      final rows = await database.select(database.medicoes).get();

      expect(rows, hasLength(1));
      expect(rows.single.servicoId, 'servico-1');
      expect(rows.single.percentualExecutado, 55);
      expect(rows.single.observacao, 'Concretagem parcial');
    });

    test('lista medicoes do servico da mais recente para a mais antiga',
        () async {
      await repository.salvarMedicao(
        _medicao(
          id: 'medicao-1',
          percentualExecutado: 20,
          data: DateTime(2026, 5, 20),
        ),
      );
      await repository.salvarMedicao(
        _medicao(
          id: 'medicao-2',
          percentualExecutado: 40,
          data: DateTime(2026, 5, 21),
        ),
      );

      final medicoes =
          await repository.watchMedicoesDoServico('servico-1').first;

      expect(medicoes.map((item) => item.id), ['medicao-2', 'medicao-1']);
    });

    test('edita medicao existente', () async {
      await repository.salvarMedicao(
        _medicao(
          id: 'medicao-1',
          percentualExecutado: 25,
        ),
      );
      await repository.salvarMedicao(
        _medicao(
          id: 'medicao-1',
          percentualExecutado: 60,
          observacao: 'Revisado',
        ),
      );

      final rows = await database.select(database.medicoes).get();
      expect(rows, hasLength(1));
      expect(rows.single.percentualExecutado, 60);
      expect(rows.single.observacao, 'Revisado');
    });

    test('salva e lista medicao vinculada a fiscalizacao', () async {
      await repository.salvarMedicao(
        _medicao(
          id: 'medicao-1',
          percentualExecutado: 30,
          data: DateTime(2026, 5, 20),
          vistoriaServicoId: 'vistoria-1',
        ),
      );
      await repository.salvarMedicao(
        _medicao(
          id: 'medicao-2',
          percentualExecutado: 50,
          data: DateTime(2026, 5, 21),
          vistoriaServicoId: 'vistoria-1',
        ),
      );

      final medicoes =
          await repository.watchMedicoesDaFiscalizacao('vistoria-1').first;

      expect(medicoes.map((item) => item.id), ['medicao-2', 'medicao-1']);
      expect(medicoes.every((item) => item.servicoId == 'servico-1'), isTrue);
      expect(
        medicoes.every((item) => item.vistoriaServicoId == 'vistoria-1'),
        isTrue,
      );
    });

    test('busca servico vinculado a fiscalizacao', () async {
      final servicoId =
          await repository.buscarServicoIdDaFiscalizacao('vistoria-1');

      expect(servicoId, 'servico-1');
    });

    test('rejeita percentual menor que zero', () async {
      expect(
        () => repository.salvarMedicao(
          _medicao(
            id: 'medicao-1',
            percentualExecutado: -1,
          ),
        ),
        throwsA(
          anyOf(
            isA<AssertionError>(),
            isA<PercentualMedicaoInvalidoException>(),
          ),
        ),
      );
    });

    test('rejeita percentual maior que cem', () async {
      expect(
        () => repository.salvarMedicao(
          _medicao(
            id: 'medicao-1',
            percentualExecutado: 100.01,
          ),
        ),
        throwsA(
          anyOf(
            isA<AssertionError>(),
            isA<PercentualMedicaoInvalidoException>(),
          ),
        ),
      );
    });
  });
}

Medicao _medicao({
  required String id,
  required double percentualExecutado,
  DateTime? data,
  String? observacao,
  String? vistoriaServicoId,
}) {
  return Medicao(
    id: id,
    servicoId: 'servico-1',
    vistoriaServicoId: vistoriaServicoId,
    percentualExecutado: percentualExecutado,
    observacao: observacao,
    data: data ?? DateTime(2026, 5, 20),
  );
}

Future<void> _popularDadosBase(db.AppDatabase database) async {
  await database.into(database.empresas).insert(
        db.EmpresasCompanion.insert(
          id: 'empresa-1',
          nome: 'Construtora Regis',
        ),
      );

  await database.into(database.contratantes).insert(
        db.ContratantesCompanion.insert(
          id: 'contratante-1',
          nome: 'Prefeitura',
        ),
      );

  await database.into(database.funcionarios).insert(
        db.FuncionariosCompanion.insert(
          id: 'responsavel-1',
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
          responsavelId: 'responsavel-1',
          numero: 'VS-001',
          data: DateTime(2026, 5, 20),
          diaSemana: DateTime.wednesday,
          status: StatusFiscalizacao.emAndamento.name,
        ),
      );
}
