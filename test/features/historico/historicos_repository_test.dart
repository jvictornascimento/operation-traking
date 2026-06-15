import 'dart:ffi';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/database/app_database.dart' as db;
import 'package:operational_tracking/features/historico/data/historicos_repository.dart';
import 'package:sqlite3/open.dart';

void main() {
  late db.AppDatabase database;
  late DriftHistoricosRepository repository;

  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
  });

  setUp(() {
    database = db.AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftHistoricosRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Story 9.1 - HistoricosRepository', () {
    test('registra alteracao generica com usuario local', () async {
      await repository.registrarAlteracao(
        entidade: 'medicao',
        entidadeId: 'medicao-1',
        campo: 'percentualExecutado',
        valorAnterior: '25.00',
        valorNovo: '60.50',
      );

      final historicos = await repository
          .watchHistoricosDaEntidade(
            entidade: 'medicao',
            entidadeId: 'medicao-1',
          )
          .first;

      expect(historicos, hasLength(1));
      expect(historicos.single.entidade, 'medicao');
      expect(historicos.single.entidadeId, 'medicao-1');
      expect(historicos.single.campo, 'percentualExecutado');
      expect(historicos.single.valorAnterior, '25.00');
      expect(historicos.single.valorNovo, '60.50');
      expect(historicos.single.usuario, 'local');
    });

    test('registra alteracao somente quando valor muda', () async {
      await repository.registrarAlteracaoSeMudou(
        entidade: 'servico',
        entidadeId: 'servico-1',
        campo: 'progressoFisico',
        valorAnterior: '10.00',
        valorNovo: '10.00',
      );
      await repository.registrarAlteracaoSeMudou(
        entidade: 'servico',
        entidadeId: 'servico-1',
        campo: 'progressoFisico',
        valorAnterior: '10.00',
        valorNovo: '35.00',
      );

      final historicos = await repository
          .watchHistoricosDaEntidade(
            entidade: 'servico',
            entidadeId: 'servico-1',
          )
          .first;

      expect(historicos, hasLength(1));
      expect(historicos.single.valorAnterior, '10.00');
      expect(historicos.single.valorNovo, '35.00');
    });
  });
}
