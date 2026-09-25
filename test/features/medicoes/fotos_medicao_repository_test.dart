import 'dart:ffi';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:belis_oversight/core/database/app_database.dart' as db;
import 'package:belis_oversight/core/domain/domain_enums.dart';
import 'package:belis_oversight/features/medicoes/data/fotos_medicao_repository.dart';
import 'package:belis_oversight/features/medicoes/domain/foto_medicao.dart';
import 'package:sqlite3/open.dart';

void main() {
  late db.AppDatabase database;
  late DriftFotosMedicaoRepository repository;

  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
  });

  setUp(() async {
    database = db.AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftFotosMedicaoRepository(database);
    await _popularDadosBase(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Story 5.2 - FotosMedicaoRepository', () {
    test('salva caminho da foto vinculada a medicao', () async {
      await repository.salvarFoto(
        const FotoMedicao(
          id: 'foto-1',
          medicaoId: 'medicao-1',
          caminhoArquivo: '/local/foto-1.jpg',
        ),
      );

      final rows = await database.select(database.fotos).get();

      expect(rows, hasLength(1));
      expect(rows.single.medicaoId, 'medicao-1');
      expect(rows.single.caminhoArquivo, '/local/foto-1.jpg');
    });

    test('lista fotos da medicao', () async {
      await repository.salvarFoto(
        const FotoMedicao(
          id: 'foto-2',
          medicaoId: 'medicao-1',
          caminhoArquivo: '/local/foto-2.jpg',
        ),
      );
      await repository.salvarFoto(
        const FotoMedicao(
          id: 'foto-1',
          medicaoId: 'medicao-1',
          caminhoArquivo: '/local/foto-1.jpg',
        ),
      );

      final fotos = await repository.watchFotosDaMedicao('medicao-1').first;

      expect(fotos.map((foto) => foto.id), ['foto-1', 'foto-2']);
    });

    test('rejeita caminho vazio', () async {
      expect(
        () => repository.salvarFoto(
          const FotoMedicao(
            id: 'foto-1',
            medicaoId: 'medicao-1',
            caminhoArquivo: ' ',
          ),
        ),
        throwsA(isA<CaminhoFotoVazioException>()),
      );
    });

    test('remove foto da medicao', () async {
      await repository.salvarFoto(
        const FotoMedicao(
          id: 'foto-1',
          medicaoId: 'medicao-1',
          caminhoArquivo: '/local/foto-1.jpg',
        ),
      );

      await repository.removerFoto('foto-1');

      final rows = await database.select(database.fotos).get();
      expect(rows, isEmpty);
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
        ),
      );

  await database.into(database.medicoes).insert(
        db.MedicoesCompanion.insert(
          id: 'medicao-1',
          servicoId: 'servico-1',
          percentualExecutado: 50,
          data: DateTime(2026, 5, 20),
        ),
      );
}
