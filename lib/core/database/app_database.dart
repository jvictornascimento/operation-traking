import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Empresas,
    Contratantes,
    Funcionarios,
    Enderecos,
    Contatos,
    Obras,
    Etapas,
    Servicos,
    VistoriasServico,
    VistoriasPeriodo,
    VistoriasMaoDeObra,
    VistoriasFotos,
    Medicoes,
    Fotos,
    HistoricosAlteracao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(medicoes, medicoes.vistoriaServicoId);
          }
          if (from < 3) {
            await migrator.addColumn(obras, obras.contratanteId);
            await migrator.addColumn(obras, obras.responsavelNome);
            await migrator.addColumn(obras, obras.responsavelContato);
          }
          if (from < 4) {
            await migrator.addColumn(funcionarios, funcionarios.telefone);
          }
          if (from < 5) {
            await migrator.addColumn(obras, obras.numeroContrato);
            await migrator.addColumn(obras, obras.valorContrato);
          }
          if (from < 6) {
            await migrator.addColumn(funcionarios, funcionarios.tipo);
            await migrator.addColumn(
              funcionarios,
              funcionarios.assinaturaPath,
            );
            await customStatement(
              "UPDATE funcionarios SET tipo = 'func_contratante' "
              'WHERE contratante_id IS NOT NULL',
            );
          }
          if (from < 7) {
            await migrator.addColumn(
                vistoriasServico, vistoriasServico.etapaId);
            await migrator.addColumn(
              vistoriasServico,
              vistoriasServico.atividade,
            );
            await migrator.createTable(vistoriasFotos);
            await customStatement(
              '''
              UPDATE vistorias_servico
              SET etapa_id = (
                SELECT etapa_id
                FROM servicos
                WHERE servicos.id = vistorias_servico.servico_id
              )
              WHERE etapa_id IS NULL
              ''',
            );
          }
          if (from < 8) {
            await migrator.addColumn(vistoriasFotos, vistoriasFotos.legenda);
          }
          if (from < 9) {
            await migrator.addColumn(funcionarios, funcionarios.ativo);
            await migrator.addColumn(funcionarios, funcionarios.excluidoEm);
            await migrator.addColumn(
              funcionarios,
              funcionarios.motivoInativacao,
            );
            await migrator.addColumn(
              vistoriasMaoDeObra,
              vistoriasMaoDeObra.funcionarioNomeSnapshot,
            );
            await migrator.addColumn(
              vistoriasMaoDeObra,
              vistoriasMaoDeObra.funcionarioCargoSnapshot,
            );
            await migrator.addColumn(
              vistoriasMaoDeObra,
              vistoriasMaoDeObra.funcionarioTelefoneSnapshot,
            );
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'operational_tracking.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

class Empresas extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get cnpj => text().nullable()();
  TextColumn get ie => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Contratantes extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get cnpj => text().nullable()();
  TextColumn get ie => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Funcionarios extends Table {
  TextColumn get id => text()();
  TextColumn get empresaId => text().nullable().references(Empresas, #id)();
  TextColumn get contratanteId =>
      text().nullable().references(Contratantes, #id)();
  TextColumn get nome => text()();
  TextColumn get cpf => text().nullable()();
  TextColumn get telefone => text().nullable()();
  TextColumn get cargo => text()();
  TextColumn get tipo => text().withDefault(const Constant('func_empresa'))();
  TextColumn get assinaturaPath => text().nullable()();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get excluidoEm => dateTime().nullable()();
  TextColumn get motivoInativacao => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Enderecos extends Table {
  TextColumn get id => text()();
  TextColumn get entidade => text()();
  TextColumn get entidadeId => text()();
  TextColumn get tipo => text()();
  TextColumn get cep => text().nullable()();
  TextColumn get logradouro => text().nullable()();
  TextColumn get numero => text().nullable()();
  TextColumn get complemento => text().nullable()();
  TextColumn get bairro => text().nullable()();
  TextColumn get cidade => text()();
  TextColumn get estado => text()();
  TextColumn get pais => text().withDefault(const Constant('Brasil'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Contatos extends Table {
  TextColumn get id => text()();
  TextColumn get entidade => text()();
  TextColumn get entidadeId => text()();
  TextColumn get tipo => text()();
  TextColumn get valor => text()();
  TextColumn get observacao => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Obras extends Table {
  TextColumn get id => text()();
  TextColumn get empresaId => text().references(Empresas, #id)();
  TextColumn get contratanteId =>
      text().nullable().references(Contratantes, #id)();
  TextColumn get enderecoId => text().references(Enderecos, #id)();
  TextColumn get nome => text()();
  TextColumn get numeroContrato => text().nullable()();
  RealColumn get valorContrato => real().nullable()();
  TextColumn get responsavelNome => text().nullable()();
  TextColumn get responsavelContato => text().nullable()();
  DateTimeColumn get dataInicio => dateTime()();
  DateTimeColumn get dataFim => dateTime()();
  TextColumn get status => text()();
  RealColumn get progressoFisico => real().withDefault(const Constant(0))();
  IntColumn get progressoPrazoDias =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Etapas extends Table {
  TextColumn get id => text()();
  TextColumn get obraId => text().references(Obras, #id)();
  TextColumn get nome => text()();
  DateTimeColumn get dataInicio => dateTime()();
  DateTimeColumn get dataFim => dateTime()();
  TextColumn get status => text()();
  RealColumn get progressoFisico => real().withDefault(const Constant(0))();
  IntColumn get progressoPrazoDias =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Servicos extends Table {
  TextColumn get id => text()();
  TextColumn get etapaId => text().references(Etapas, #id)();
  TextColumn get nome => text()();
  RealColumn get precoTotal => real()();
  TextColumn get unidade => text()();
  RealColumn get quantidade => real()();
  DateTimeColumn get dataInicio => dateTime()();
  DateTimeColumn get dataFim => dateTime()();
  TextColumn get status => text()();
  RealColumn get progressoFisico => real().withDefault(const Constant(0))();
  IntColumn get progressoPrazoDias =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class VistoriasServico extends Table {
  TextColumn get id => text()();
  TextColumn get servicoId => text()();
  TextColumn get etapaId => text().nullable().references(Etapas, #id)();
  TextColumn get obraId => text().references(Obras, #id)();
  TextColumn get contratanteId => text().references(Contratantes, #id)();
  TextColumn get responsavelId => text().references(Funcionarios, #id)();
  TextColumn get numero => text().unique()();
  DateTimeColumn get data => dateTime()();
  IntColumn get diaSemana => integer()();
  TextColumn get status => text()();
  TextColumn get atividade => text().nullable()();
  TextColumn get ocorrencia => text().nullable()();
  TextColumn get comentario => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {etapaId, data},
      ];
}

class VistoriasPeriodo extends Table {
  TextColumn get id => text()();
  TextColumn get vistoriaServicoId =>
      text().references(VistoriasServico, #id)();
  TextColumn get periodo => text()();
  TextColumn get tempo => text()();
  TextColumn get condicao => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {vistoriaServicoId, periodo},
      ];
}

class VistoriasMaoDeObra extends Table {
  TextColumn get id => text()();
  TextColumn get vistoriaServicoId =>
      text().references(VistoriasServico, #id)();
  TextColumn get funcionarioId => text().references(Funcionarios, #id)();
  TextColumn get funcionarioNomeSnapshot => text().nullable()();
  TextColumn get funcionarioCargoSnapshot => text().nullable()();
  TextColumn get funcionarioTelefoneSnapshot => text().nullable()();
  TextColumn get funcaoNoDia => text().nullable()();
  TextColumn get observacao => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class VistoriasFotos extends Table {
  TextColumn get id => text()();
  TextColumn get vistoriaServicoId =>
      text().references(VistoriasServico, #id)();
  TextColumn get caminhoArquivo => text()();
  TextColumn get legenda => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Medicoes extends Table {
  TextColumn get id => text()();
  TextColumn get servicoId => text().references(Servicos, #id)();
  TextColumn get vistoriaServicoId =>
      text().nullable().references(VistoriasServico, #id)();
  RealColumn get percentualExecutado => real()();
  TextColumn get observacao => text().nullable()();
  DateTimeColumn get data => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Fotos extends Table {
  TextColumn get id => text()();
  TextColumn get medicaoId => text().references(Medicoes, #id)();
  TextColumn get caminhoArquivo => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class HistoricosAlteracao extends Table {
  TextColumn get id => text()();
  TextColumn get entidade => text()();
  TextColumn get entidadeId => text()();
  TextColumn get campo => text()();
  TextColumn get valorAnterior => text().nullable()();
  TextColumn get valorNovo => text().nullable()();
  DateTimeColumn get data => dateTime()();
  TextColumn get usuario => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
