import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/database/app_database.dart' as db;
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/servicos/data/servicos_repository.dart';
import 'package:sqlite3/open.dart';

void main() {
  late db.AppDatabase database;
  late DriftServicosRepository repository;

  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
  });

  setUp(() async {
    database = db.AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftServicosRepository(database);
    await _popularDadosBase(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Story 9.1 - ServicosRepository historico', () {
    test('registra historico quando progresso fisico muda', () async {
      await repository.atualizarProgressoFisico(
        id: 'servico-1',
        progressoFisico: 35.5,
      );

      final historicos =
          await database.select(database.historicosAlteracao).get();

      expect(historicos, hasLength(1));
      expect(historicos.single.entidade, 'servico');
      expect(historicos.single.entidadeId, 'servico-1');
      expect(historicos.single.campo, 'progressoFisico');
      expect(historicos.single.valorAnterior, '0.00');
      expect(historicos.single.valorNovo, '35.50');
      expect(historicos.single.usuario, 'local');
    });

    test('nao registra historico quando progresso fisico nao muda', () async {
      await repository.atualizarProgressoFisico(
        id: 'servico-1',
        progressoFisico: 0,
      );

      final historicos =
          await database.select(database.historicosAlteracao).get();

      expect(historicos, isEmpty);
    });
  });
}

Future<void> _popularDadosBase(db.AppDatabase database) async {
  await database.into(database.empresas).insert(
        db.EmpresasCompanion.insert(
          id: 'empresa-1',
          nome: 'Construtora Regis',
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
          progressoFisico: const Value(0),
        ),
      );
}
