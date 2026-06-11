import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/database/app_database.dart' as db;
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/fiscalizacoes/data/vistorias_servico_repository.dart';
import 'package:operational_tracking/features/fiscalizacoes/domain/vistoria_servico.dart';
import 'package:sqlite3/open.dart';

void main() {
  late db.AppDatabase database;
  late DriftVistoriasServicoRepository repository;

  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
  });

  setUp(() async {
    database = db.AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftVistoriasServicoRepository(database);
    await _popularDadosBase(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Story 1.3 - VistoriasServicoRepository', () {
    test('salva vistoria normalizando data para o dia', () async {
      await repository.salvarVistoria(
        _vistoria(
          id: 'vistoria-1',
          numero: '001',
          data: DateTime(2026, 5, 20, 14, 30),
        ),
      );

      final rows = await database.select(database.vistoriasServico).get();

      expect(rows, hasLength(1));
      expect(rows.single.data, DateTime(2026, 5, 20));
      expect(rows.single.diaSemana, DateTime.wednesday);
    });

    test('rejeita duas vistorias do mesmo servico no mesmo dia', () async {
      await repository.salvarVistoria(
        _vistoria(
          id: 'vistoria-1',
          numero: '001',
          data: DateTime(2026, 5, 20, 8),
        ),
      );

      expect(
        () => repository.salvarVistoria(
          _vistoria(
            id: 'vistoria-2',
            numero: '002',
            data: DateTime(2026, 5, 20, 18),
          ),
        ),
        throwsA(isA<VistoriaServicoDuplicadaException>()),
      );

      final rows = await database.select(database.vistoriasServico).get();
      expect(rows, hasLength(1));
    });

    test('permite vistorias do mesmo servico em dias diferentes', () async {
      await repository.salvarVistoria(
        _vistoria(
          id: 'vistoria-1',
          numero: '001',
          data: DateTime(2026, 5, 20),
        ),
      );
      await repository.salvarVistoria(
        _vistoria(
          id: 'vistoria-2',
          numero: '002',
          data: DateTime(2026, 5, 21),
        ),
      );

      final rows = await database.select(database.vistoriasServico).get();
      expect(rows, hasLength(2));
    });

    test('permite editar a mesma vistoria sem acusar duplicidade', () async {
      await repository.salvarVistoria(
        _vistoria(
          id: 'vistoria-1',
          numero: '001',
          data: DateTime(2026, 5, 20),
        ),
      );

      await repository.salvarVistoria(
        _vistoria(
          id: 'vistoria-1',
          numero: '001',
          data: DateTime(2026, 5, 20, 16),
          comentario: 'Atualizado em campo',
        ),
      );

      final rows = await database.select(database.vistoriasServico).get();
      expect(rows, hasLength(1));
      expect(rows.single.comentario, 'Atualizado em campo');
    });

    test('registra historico quando status da vistoria muda', () async {
      await repository.salvarVistoria(
        _vistoria(
          id: 'vistoria-1',
          numero: '001',
          data: DateTime(2026, 5, 20),
        ),
      );

      await repository.salvarVistoria(
        _vistoria(
          id: 'vistoria-1',
          numero: '001',
          data: DateTime(2026, 5, 20),
          status: StatusFiscalizacao.aprovada,
        ),
      );

      final historicos =
          await database.select(database.historicosAlteracao).get();

      expect(historicos, hasLength(1));
      expect(historicos.single.entidade, 'fiscalizacao');
      expect(historicos.single.entidadeId, 'vistoria-1');
      expect(historicos.single.campo, 'status');
      expect(historicos.single.valorAnterior, 'emAndamento');
      expect(historicos.single.valorNovo, 'aprovada');
      expect(historicos.single.usuario, 'local');
    });

    test('rejeita numero duplicado em vistorias diferentes', () async {
      await repository.salvarVistoria(
        _vistoria(
          id: 'vistoria-1',
          numero: '001',
          data: DateTime(2026, 5, 20),
        ),
      );

      expect(
        () => repository.salvarVistoria(
          _vistoria(
            id: 'vistoria-2',
            numero: '001',
            data: DateTime(2026, 5, 21),
          ),
        ),
        throwsA(isA<NumeroVistoriaDuplicadoException>()),
      );
    });

    test('banco impede duplicidade por servico e data normalizada', () async {
      await repository.salvarVistoria(
        _vistoria(
          id: 'vistoria-1',
          numero: '001',
          data: DateTime(2026, 5, 20),
        ),
      );

      expect(
        () {
          return database.into(database.vistoriasServico).insert(
                db.VistoriasServicoCompanion.insert(
                  id: 'vistoria-2',
                  servicoId: 'servico-1',
                  obraId: 'obra-1',
                  contratanteId: 'contratante-1',
                  responsavelId: 'funcionario-1',
                  numero: '002',
                  data: DateTime(2026, 5, 20),
                  diaSemana: DateTime.wednesday,
                  status: StatusFiscalizacao.emAndamento.name,
                ),
              );
        },
        throwsException,
      );
    });
  });
}

VistoriaServico _vistoria({
  required String id,
  required String numero,
  required DateTime data,
  String? comentario,
  StatusFiscalizacao status = StatusFiscalizacao.emAndamento,
}) {
  return VistoriaServico(
    id: id,
    servicoId: 'servico-1',
    obraId: 'obra-1',
    contratanteId: 'contratante-1',
    responsavelId: 'funcionario-1',
    numero: numero,
    data: data,
    diaSemana: data.weekday,
    status: status,
    comentario: comentario,
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
}
