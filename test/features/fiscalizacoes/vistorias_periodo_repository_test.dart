import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:belis_oversight/core/database/app_database.dart' as db;
import 'package:belis_oversight/core/domain/domain_enums.dart';
import 'package:belis_oversight/features/fiscalizacoes/data/vistorias_periodo_repository.dart';
import 'package:belis_oversight/features/fiscalizacoes/domain/vistoria_periodo.dart';
import 'package:sqlite3/open.dart';

void main() {
  late db.AppDatabase database;
  late DriftVistoriasPeriodoRepository repository;

  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
  });

  setUp(() async {
    database = db.AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftVistoriasPeriodoRepository(database);
    await _popularDadosBase(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Story 4.3 - VistoriasPeriodoRepository', () {
    test('salva periodo da vistoria', () async {
      await repository.salvarPeriodo(
        _periodo(
          id: 'periodo-1',
          periodo: PeriodoDia.manha,
          tempo: TempoPeriodo.claro,
          condicao: CondicaoPeriodo.praticavel,
        ),
      );

      final rows = await database.select(database.vistoriasPeriodo).get();

      expect(rows, hasLength(1));
      expect(rows.single.vistoriaServicoId, 'vistoria-1');
      expect(rows.single.periodo, PeriodoDia.manha.name);
      expect(rows.single.tempo, TempoPeriodo.claro.name);
      expect(rows.single.condicao, CondicaoPeriodo.praticavel.name);
    });

    test('rejeita periodo duplicado na mesma vistoria', () async {
      await repository.salvarPeriodo(
        _periodo(
          id: 'periodo-1',
          periodo: PeriodoDia.tarde,
          tempo: TempoPeriodo.nublado,
          condicao: CondicaoPeriodo.praticavel,
        ),
      );

      expect(
        () => repository.salvarPeriodo(
          _periodo(
            id: 'periodo-2',
            periodo: PeriodoDia.tarde,
            tempo: TempoPeriodo.chuvoso,
            condicao: CondicaoPeriodo.impraticavel,
          ),
        ),
        throwsA(isA<VistoriaPeriodoDuplicadoException>()),
      );
    });

    test('permite mesmo periodo em vistorias diferentes', () async {
      await _inserirVistoria(
        database,
        id: 'vistoria-2',
        numero: '002',
        data: DateTime(2026, 5, 21),
      );

      await repository.salvarPeriodo(
        _periodo(
          id: 'periodo-1',
          periodo: PeriodoDia.noite,
          tempo: TempoPeriodo.claro,
          condicao: CondicaoPeriodo.praticavel,
        ),
      );
      await repository.salvarPeriodo(
        const VistoriaPeriodo(
          id: 'periodo-2',
          vistoriaServicoId: 'vistoria-2',
          periodo: PeriodoDia.noite,
          tempo: TempoPeriodo.chuvoso,
          condicao: CondicaoPeriodo.impraticavel,
        ),
      );

      final rows = await database.select(database.vistoriasPeriodo).get();
      expect(rows, hasLength(2));
    });

    test('edita periodo existente sem acusar duplicidade', () async {
      await repository.salvarPeriodo(
        _periodo(
          id: 'periodo-1',
          periodo: PeriodoDia.manha,
          tempo: TempoPeriodo.claro,
          condicao: CondicaoPeriodo.praticavel,
        ),
      );
      await repository.salvarPeriodo(
        _periodo(
          id: 'periodo-1',
          periodo: PeriodoDia.manha,
          tempo: TempoPeriodo.chuvoso,
          condicao: CondicaoPeriodo.impraticavel,
        ),
      );

      final rows = await database.select(database.vistoriasPeriodo).get();
      expect(rows, hasLength(1));
      expect(rows.single.tempo, TempoPeriodo.chuvoso.name);
      expect(rows.single.condicao, CondicaoPeriodo.impraticavel.name);
    });

    test('remove periodo da vistoria', () async {
      await repository.salvarPeriodo(
        _periodo(
          id: 'periodo-1',
          periodo: PeriodoDia.tarde,
          tempo: TempoPeriodo.claro,
          condicao: CondicaoPeriodo.praticavel,
        ),
      );

      await repository.removerPeriodo(
        vistoriaServicoId: 'vistoria-1',
        periodo: PeriodoDia.tarde,
      );

      final rows = await database.select(database.vistoriasPeriodo).get();
      expect(rows, isEmpty);
    });

    test('banco impede periodo duplicado na mesma vistoria', () async {
      await repository.salvarPeriodo(
        _periodo(
          id: 'periodo-1',
          periodo: PeriodoDia.manha,
          tempo: TempoPeriodo.claro,
          condicao: CondicaoPeriodo.praticavel,
        ),
      );

      expect(
        () {
          return database.into(database.vistoriasPeriodo).insert(
                db.VistoriasPeriodoCompanion.insert(
                  id: 'periodo-2',
                  vistoriaServicoId: 'vistoria-1',
                  periodo: PeriodoDia.manha.name,
                  tempo: TempoPeriodo.nublado.name,
                  condicao: CondicaoPeriodo.impraticavel.name,
                ),
              );
        },
        throwsException,
      );
    });
  });
}

VistoriaPeriodo _periodo({
  required String id,
  required PeriodoDia periodo,
  required TempoPeriodo tempo,
  required CondicaoPeriodo condicao,
}) {
  return VistoriaPeriodo(
    id: id,
    vistoriaServicoId: 'vistoria-1',
    periodo: periodo,
    tempo: tempo,
    condicao: condicao,
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
          nome: 'Cliente Regis',
        ),
      );

  await database.into(database.funcionarios).insert(
        db.FuncionariosCompanion.insert(
          id: 'funcionario-1',
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

  await _inserirVistoria(
    database,
    id: 'vistoria-1',
    numero: '001',
    data: DateTime(2026, 5, 20),
  );
}

Future<void> _inserirVistoria(
  db.AppDatabase database, {
  required String id,
  required String numero,
  required DateTime data,
}) async {
  await database.into(database.vistoriasServico).insert(
        db.VistoriasServicoCompanion.insert(
          id: id,
          servicoId: 'servico-1',
          obraId: 'obra-1',
          contratanteId: 'contratante-1',
          responsavelId: 'funcionario-1',
          numero: numero,
          data: data,
          diaSemana: data.weekday,
          status: StatusFiscalizacao.emAndamento.name,
        ),
      );
}
