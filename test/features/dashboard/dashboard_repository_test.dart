import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/database/app_database.dart' as db;
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/dashboard/data/dashboard_repository.dart';
import 'package:sqlite3/open.dart';

void main() {
  late db.AppDatabase database;
  late DriftDashboardRepository repository;

  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
  });

  setUp(() async {
    database = db.AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftDashboardRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Story 6.1 - DashboardRepository', () {
    test('retorna resumo vazio quando nao existem dados', () async {
      final resumo = await repository.watchResumo().first;

      expect(resumo.totalObras, 0);
      expect(resumo.totalServicos, 0);
      expect(resumo.totalFiscalizacoes, 0);
      expect(resumo.totalMedicoes, 0);
      expect(resumo.totalFotos, 0);
      expect(resumo.obrasAtrasadas, 0);
      expect(resumo.progressoMedioObras, 0);
    });

    test('retorna contadores e progresso medio local', () async {
      await _popularDadosBase(database);

      final resumo = await repository.watchResumo().first;

      expect(resumo.totalObras, 2);
      expect(resumo.totalServicos, 1);
      expect(resumo.totalFiscalizacoes, 1);
      expect(resumo.totalMedicoes, 1);
      expect(resumo.totalFotos, 1);
      expect(resumo.obrasAtrasadas, 1);
      expect(resumo.progressoMedioObras, 60);
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

  await database.into(database.enderecos).insert(
        db.EnderecosCompanion.insert(
          id: 'endereco-2',
          entidade: TipoEntidadeEndereco.obra.name,
          entidadeId: 'obra-2',
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
          nome: 'Obra em andamento',
          dataInicio: DateTime(2026, 5, 1),
          dataFim: DateTime(2026, 6, 1),
          status: StatusExecucao.emAndamento.name,
          progressoFisico: const Value(80),
        ),
      );

  await database.into(database.obras).insert(
        db.ObrasCompanion.insert(
          id: 'obra-2',
          empresaId: 'empresa-1',
          enderecoId: 'endereco-2',
          nome: 'Obra atrasada',
          dataInicio: DateTime(2026, 5, 1),
          dataFim: DateTime(2026, 6, 1),
          status: StatusExecucao.atrasada.name,
          progressoFisico: const Value(40),
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
          responsavelId: 'funcionario-1',
          numero: '001',
          data: DateTime(2026, 5, 20),
          diaSemana: DateTime.wednesday,
          status: StatusFiscalizacao.emAndamento.name,
        ),
      );

  await database.into(database.medicoes).insert(
        db.MedicoesCompanion.insert(
          id: 'medicao-1',
          servicoId: 'servico-1',
          percentualExecutado: 60,
          data: DateTime(2026, 5, 20),
        ),
      );

  await database.into(database.fotos).insert(
        db.FotosCompanion.insert(
          id: 'foto-1',
          medicaoId: 'medicao-1',
          caminhoArquivo: '/local/foto-1.jpg',
        ),
      );
}
