import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:belis_oversight/core/database/app_database.dart';
import 'package:belis_oversight/core/domain/domain_enums.dart';
import 'package:belis_oversight/features/cadastros/data/contratantes_repository.dart';
import 'package:belis_oversight/features/cadastros/data/empresas_repository.dart';
import 'package:belis_oversight/features/cadastros/data/funcionarios_repository.dart';
import 'package:belis_oversight/features/cadastros/presentation/contratantes_controller.dart';
import 'package:belis_oversight/features/cadastros/presentation/empresas_controller.dart';
import 'package:belis_oversight/features/cadastros/presentation/funcionarios_controller.dart';
import 'package:belis_oversight/features/etapas/data/etapas_repository.dart';
import 'package:belis_oversight/features/etapas/presentation/etapas_controller.dart';
import 'package:belis_oversight/features/fiscalizacoes/data/vistorias_mao_de_obra_repository.dart';
import 'package:belis_oversight/features/fiscalizacoes/data/vistorias_periodo_repository.dart';
import 'package:belis_oversight/features/fiscalizacoes/data/vistorias_servico_repository.dart';
import 'package:belis_oversight/features/fiscalizacoes/presentation/fiscalizacoes_controller.dart';
import 'package:belis_oversight/features/obras/data/obras_repository.dart';
import 'package:belis_oversight/features/obras/presentation/obras_controller.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'cria obra, etapa e fiscalizacao com repositorios reais no Android',
    (tester) async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);

      final empresasRepository = DriftEmpresasRepository(database);
      final contratantesRepository = DriftContratantesRepository(database);
      final funcionariosRepository = DriftFuncionariosRepository(database);
      final obrasRepository = DriftObrasRepository(database);
      final etapasRepository = DriftEtapasRepository(database);
      final fiscalizacoesRepository = DriftVistoriasServicoRepository(database);
      final periodosRepository = DriftVistoriasPeriodoRepository(database);
      final maoDeObraRepository = DriftVistoriasMaoDeObraRepository(database);

      await EmpresasController(empresasRepository).salvar(
        id: 'empresa-e2e',
        nome: 'Construtora E2E',
      );
      await ContratantesController(contratantesRepository).salvar(
        id: 'contratante-e2e',
        nome: 'Contratante E2E',
      );
      await FuncionariosController(funcionariosRepository).salvar(
        id: 'funcionario-empresa-e2e',
        empresaId: 'empresa-e2e',
        nome: 'Ana E2E',
        telefone: '11911112222',
        cargo: 'Pedreira',
      );
      await FuncionariosController(funcionariosRepository).salvar(
        id: 'funcionario-contratante-e2e',
        contratanteId: 'contratante-e2e',
        nome: 'Fiscal E2E',
        telefone: '11999999999',
        cargo: 'Fiscal',
      );

      await ObrasController(obrasRepository).salvar(
        id: 'obra-e2e',
        empresaId: 'empresa-e2e',
        contratanteId: 'contratante-e2e',
        nome: 'Obra E2E',
        numeroContrato: 'CTR-E2E',
        valorContrato: '1500,00',
        responsavelNome: 'Regis',
        responsavelContato: '11999999999',
        dataInicio: DateTime(2026, 8, 10),
        dataFim: DateTime(2026, 9, 10),
        dataAtual: DateTime(2026, 8, 15),
        enderecoCidade: 'Campinas',
        enderecoEstado: 'SP',
        enderecoLogradouro: 'Rua E2E',
      );
      await EtapasController(etapasRepository).salvar(
        id: 'etapa-e2e',
        obraId: 'obra-e2e',
        nome: 'Fundacao E2E',
        dataInicio: DateTime(2026, 8, 10),
        dataFim: DateTime(2026, 8, 20),
        dataAtual: DateTime(2026, 8, 15),
      );

      await FiscalizacoesController(fiscalizacoesRepository).salvar(
        id: 'fiscalizacao-e2e',
        etapaId: 'etapa-e2e',
        data: DateTime(2026, 8, 15),
        atividade: 'Conferencia da fundacao',
        ocorrencia: 'Sem ocorrencias',
        comentario: 'Fluxo validado no Android',
      );
      await PeriodosFiscalizacaoController(periodosRepository).salvar(
        id: 'periodo-e2e',
        vistoriaServicoId: 'fiscalizacao-e2e',
        periodo: PeriodoDia.manha,
        tempo: TempoPeriodo.claro,
        condicao: CondicaoPeriodo.praticavel,
      );
      await MaoDeObraFiscalizacaoController(maoDeObraRepository).salvar(
        id: 'mao-obra-e2e',
        vistoriaServicoId: 'fiscalizacao-e2e',
        funcionarioId: 'funcionario-empresa-e2e',
        funcaoNoDia: 'Pedreira',
        observacao: 'Equipe local',
      );

      final obras = await database.select(database.obras).get();
      final enderecos = await database.select(database.enderecos).get();
      final etapas = await database.select(database.etapas).get();
      final fiscalizacoes =
          await database.select(database.vistoriasServico).get();
      final periodos = await database.select(database.vistoriasPeriodo).get();
      final maoDeObra =
          await database.select(database.vistoriasMaoDeObra).get();

      expect(obras, hasLength(1));
      expect(obras.single.nome, 'Obra E2E');
      expect(obras.single.empresaId, 'empresa-e2e');
      expect(obras.single.contratanteId, 'contratante-e2e');
      expect(obras.single.numeroContrato, 'CTR-E2E');
      expect(obras.single.valorContrato, 1500);
      expect(enderecos.single.entidadeId, 'obra-e2e');
      expect(enderecos.single.cidade, 'Campinas');
      expect(etapas.single.obraId, 'obra-e2e');
      expect(etapas.single.nome, 'Fundacao E2E');
      expect(fiscalizacoes.single.etapaId, 'etapa-e2e');
      expect(fiscalizacoes.single.obraId, 'obra-e2e');
      expect(fiscalizacoes.single.contratanteId, 'contratante-e2e');
      expect(fiscalizacoes.single.responsavelId, 'funcionario-contratante-e2e');
      expect(fiscalizacoes.single.atividade, 'Conferencia da fundacao');
      expect(fiscalizacoes.single.ocorrencia, 'Sem ocorrencias');
      expect(fiscalizacoes.single.comentario, 'Fluxo validado no Android');
      expect(periodos.single.periodo, PeriodoDia.manha.name);
      expect(maoDeObra.single.funcionarioId, 'funcionario-empresa-e2e');
      expect(maoDeObra.single.funcionarioNomeSnapshot, 'Ana E2E');
      expect(maoDeObra.single.funcionarioCargoSnapshot, 'Pedreira');
      expect(maoDeObra.single.funcionarioTelefoneSnapshot, '11911112222');
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
