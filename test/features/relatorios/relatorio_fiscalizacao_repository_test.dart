import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/database/app_database.dart' as db;
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/relatorios/data/relatorio_fiscalizacao_repository.dart';
import 'package:sqlite3/open.dart';

void main() {
  late db.AppDatabase database;
  late DriftRelatorioFiscalizacaoRepository repository;

  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
  });

  setUp(() async {
    database = db.AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftRelatorioFiscalizacaoRepository(database);
    await _popularDadosBase(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Issue #7 - RelatorioFiscalizacaoRepository', () {
    test('carrega somente dados vinculados a fiscalizacao', () async {
      final dados = await repository.carregarDadosDaFiscalizacao('vistoria-1');

      expect(dados.obra.nome, 'Obra Regis');
      expect(dados.servico.nome, 'Escavacao');
      expect(dados.fiscalizacao.numero, '001');
      expect(dados.periodos, hasLength(1));
      expect(dados.medicoes, hasLength(1));
      expect(dados.medicoes.single.id, 'medicao-vistoria-1');
      expect(dados.maoDeObra, hasLength(1));
      expect(dados.fotos, hasLength(1));
      expect(dados.fotos.single.caminhoArquivo, '/local/foto-1.jpg');
    });

    test('rejeita fiscalizacao inexistente', () async {
      expect(
        () => repository.carregarDadosDaFiscalizacao('vistoria-inexistente'),
        throwsA(isA<FiscalizacaoRelatorioNaoEncontradaException>()),
      );
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
          id: 'funcionario-contratante-1',
          contratanteId: const Value('contratante-1'),
          nome: 'Regis',
          cargo: 'Fiscal',
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
          comentario: const Value('Dia produtivo'),
        ),
      );

  await database.into(database.medicoes).insert(
        db.MedicoesCompanion.insert(
          id: 'medicao-vistoria-1',
          servicoId: 'servico-1',
          vistoriaServicoId: const Value('vistoria-1'),
          percentualExecutado: 60,
          observacao: const Value('Frente norte'),
          data: DateTime(2026, 5, 20),
        ),
      );

  await database.into(database.medicoes).insert(
        db.MedicoesCompanion.insert(
          id: 'medicao-sem-vistoria',
          servicoId: 'servico-1',
          percentualExecutado: 20,
          data: DateTime(2026, 5, 19),
        ),
      );

  await database.into(database.fotos).insert(
        db.FotosCompanion.insert(
          id: 'foto-1',
          medicaoId: 'medicao-vistoria-1',
          caminhoArquivo: '/local/foto-1.jpg',
        ),
      );

  await database.into(database.vistoriasPeriodo).insert(
        db.VistoriasPeriodoCompanion.insert(
          id: 'periodo-1',
          vistoriaServicoId: 'vistoria-1',
          periodo: PeriodoDia.manha.name,
          tempo: TempoPeriodo.claro.name,
          condicao: CondicaoPeriodo.praticavel.name,
        ),
      );

  await database.into(database.vistoriasMaoDeObra).insert(
        db.VistoriasMaoDeObraCompanion.insert(
          id: 'mao-obra-1',
          vistoriaServicoId: 'vistoria-1',
          funcionarioId: 'funcionario-empresa-1',
          funcaoNoDia: const Value('Pedreira'),
        ),
      );
}
