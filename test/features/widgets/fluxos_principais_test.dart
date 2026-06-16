import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/cadastros/data/contratantes_repository.dart';
import 'package:operational_tracking/features/cadastros/data/empresas_repository.dart';
import 'package:operational_tracking/features/cadastros/domain/contratante.dart';
import 'package:operational_tracking/features/cadastros/domain/empresa.dart';
import 'package:operational_tracking/features/cadastros/domain/endereco.dart';
import 'package:operational_tracking/features/cadastros/domain/funcionario.dart';
import 'package:operational_tracking/features/cadastros/presentation/contratantes_controller.dart';
import 'package:operational_tracking/features/cadastros/presentation/empresas_controller.dart';
import 'package:operational_tracking/features/fiscalizacoes/data/vistorias_mao_de_obra_repository.dart';
import 'package:operational_tracking/features/fiscalizacoes/data/vistorias_periodo_repository.dart';
import 'package:operational_tracking/features/fiscalizacoes/data/vistorias_servico_repository.dart';
import 'package:operational_tracking/features/fiscalizacoes/domain/vistoria_mao_de_obra.dart';
import 'package:operational_tracking/features/fiscalizacoes/domain/vistoria_periodo.dart';
import 'package:operational_tracking/features/fiscalizacoes/domain/vistoria_servico.dart';
import 'package:operational_tracking/features/fiscalizacoes/presentation/fiscalizacoes_controller.dart';
import 'package:operational_tracking/features/fiscalizacoes/presentation/fiscalizacoes_page.dart';
import 'package:operational_tracking/features/medicoes/data/medicoes_repository.dart';
import 'package:operational_tracking/features/medicoes/domain/medicao.dart';
import 'package:operational_tracking/features/medicoes/presentation/medicoes_controller.dart';
import 'package:operational_tracking/features/obras/data/obras_repository.dart';
import 'package:operational_tracking/features/obras/domain/obra.dart';
import 'package:operational_tracking/features/obras/presentation/obras_controller.dart';
import 'package:operational_tracking/features/obras/presentation/obras_page.dart';
import 'package:operational_tracking/features/relatorios/data/relatorio_fiscalizacao_repository.dart';
import 'package:operational_tracking/features/relatorios/data/relatorio_obra_repository.dart';
import 'package:operational_tracking/features/relatorios/data/relatorio_pdf_generator.dart';
import 'package:operational_tracking/features/relatorios/domain/relatorio_fiscalizacao_dados.dart';
import 'package:operational_tracking/features/relatorios/domain/relatorio_obra_dados.dart';
import 'package:operational_tracking/features/relatorios/presentation/relatorios_controller.dart';
import 'package:operational_tracking/features/servicos/data/servicos_repository.dart';
import 'package:operational_tracking/features/servicos/domain/servico.dart';
import 'package:operational_tracking/features/servicos/presentation/servicos_controller.dart';
import 'package:operational_tracking/features/servicos/presentation/servicos_page.dart';

void main() {
  group('Story 10.2 - widgets dos fluxos principais', () {
    testWidgets('cadastra obra com empresa selecionada e endereco embutido',
        (tester) async {
      final obrasRepository = _FakeObrasRepository();
      final empresasRepository = _FakeEmpresasRepository([
        const Empresa(id: 'empresa-1', nome: 'Construtora Regis'),
      ]);
      final contratantesRepository = _FakeContratantesRepository([
        const Contratante(id: 'contratante-1', nome: 'Cliente Regis'),
      ]);

      await tester.pumpWidget(
        _testApp(
          overrides: [
            obrasRepositoryProvider.overrideWithValue(obrasRepository),
            empresasRepositoryProvider.overrideWithValue(empresasRepository),
            contratantesRepositoryProvider.overrideWithValue(
              contratantesRepository,
            ),
          ],
          child: const ObrasPage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Obra'));
      await tester.pumpAndSettle();

      await tester.enterText(_field('Nome'), 'Obra Central');
      await tester.tap(find.byType(DropdownButtonFormField<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Construtora Regis'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cliente Regis'));
      await tester.pumpAndSettle();
      await tester.enterText(_field('Responsavel da obra'), 'Regis');
      await tester.enterText(_field('Contato do responsavel'), '11999999999');
      await tester.enterText(_field('Cidade'), 'Sao Paulo');
      await tester.enterText(_field('Estado'), 'SP');
      await _scrollUntilText(tester, 'Salvar');
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(obrasRepository.obras, hasLength(1));
      expect(obrasRepository.obras.single.nome, 'Obra Central');
      expect(obrasRepository.obras.single.empresaId, 'empresa-1');
      expect(obrasRepository.obras.single.contratanteId, 'contratante-1');
      expect(obrasRepository.obras.single.responsavelNome, 'Regis');
      expect(obrasRepository.obras.single.responsavelContato, '11999999999');
      expect(obrasRepository.enderecosSalvos.single.cidade, 'Sao Paulo');
    });

    testWidgets('cadastra servico dentro da etapa', (tester) async {
      final servicosRepository = _FakeServicosRepository();

      await tester.pumpWidget(
        _testApp(
          overrides: [
            servicosRepositoryProvider.overrideWithValue(servicosRepository),
          ],
          child: const ServicosPage(etapaId: 'etapa-1'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Servico'));
      await tester.pumpAndSettle();

      await tester.enterText(_field('Nome'), 'Alvenaria');
      await tester.enterText(_field('Preco total'), '1500');
      await tester.enterText(_field('Unidade'), 'm2');
      await tester.enterText(_field('Quantidade'), '45');
      await _scrollUntilText(tester, 'Salvar');
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(servicosRepository.servicos, hasLength(1));
      expect(servicosRepository.servicos.single.etapaId, 'etapa-1');
      expect(servicosRepository.servicos.single.nome, 'Alvenaria');
      expect(servicosRepository.servicos.single.quantidade, 45);
    });

    testWidgets('cadastra fiscalizacao dentro do servico', (tester) async {
      final fiscalizacoesRepository = _FakeVistoriasServicoRepository();

      await tester.pumpWidget(
        _testApp(
          overrides: [
            vistoriasServicoRepositoryProvider.overrideWithValue(
              fiscalizacoesRepository,
            ),
          ],
          child: const FiscalizacoesPage(servicoId: 'servico-1'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fiscalizacao'));
      await tester.pumpAndSettle();

      await tester.enterText(_field('ID do contratante'), 'contratante-1');
      await tester.enterText(_field('ID do responsavel'), 'funcionario-1');
      await tester.enterText(_field('Numero'), 'FISC-001');
      await tester.enterText(_field('Ocorrencia'), 'Sem ocorrencias');
      await tester.enterText(_field('Comentario'), 'Servico liberado');
      await _scrollUntilText(tester, 'Salvar');
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(fiscalizacoesRepository.vistorias, hasLength(1));
      expect(fiscalizacoesRepository.vistorias.single.servicoId, 'servico-1');
      expect(fiscalizacoesRepository.vistorias.single.obraId, 'obra-1');
      expect(fiscalizacoesRepository.vistorias.single.numero, 'FISC-001');
      expect(
        fiscalizacoesRepository.vistorias.single.comentario,
        'Servico liberado',
      );
    });

    testWidgets('periodos exibem checkbox e radio groups', (tester) async {
      final fiscalizacoesRepository = _FakeVistoriasServicoRepository(
        vistorias: [
          VistoriaServico(
            id: 'vistoria-1',
            servicoId: 'servico-1',
            obraId: 'obra-1',
            contratanteId: 'contratante-1',
            responsavelId: 'funcionario-1',
            numero: 'FISC-001',
            data: DateTime(2026, 6, 15),
            diaSemana: DateTime.monday,
          ),
        ],
      );
      final periodosRepository = _FakeVistoriasPeriodoRepository([
        const VistoriaPeriodo(
          id: 'periodo-1',
          vistoriaServicoId: 'vistoria-1',
          periodo: PeriodoDia.manha,
          tempo: TempoPeriodo.claro,
          condicao: CondicaoPeriodo.praticavel,
        ),
      ]);

      await tester.pumpWidget(
        _testApp(
          overrides: [
            vistoriasServicoRepositoryProvider.overrideWithValue(
              fiscalizacoesRepository,
            ),
            vistoriasPeriodoRepositoryProvider.overrideWithValue(
              periodosRepository,
            ),
            vistoriasMaoDeObraRepositoryProvider.overrideWithValue(
              _FakeVistoriasMaoDeObraRepository(),
            ),
            medicoesRepositoryProvider.overrideWithValue(
              _FakeMedicoesRepository(),
            ),
            servicosRepositoryProvider.overrideWithValue(
              _FakeServicosRepository(),
            ),
            relatoriosControllerProvider.overrideWith(
              (ref) => _FakeRelatoriosController(),
            ),
          ],
          child: const FiscalizacoesPage(servicoId: 'servico-1'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('FISC-001'));
      await tester.tap(find.text('FISC-001'));
      await tester.pumpAndSettle();
      await _scrollUntilText(tester, 'Periodos');

      expect(find.text('Periodos'), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsNWidgets(3));
      expect(find.text('Tempo'), findsOneWidget);
      expect(find.text('Condicao'), findsOneWidget);
      expect(find.text('Claro'), findsOneWidget);
      expect(find.text('Praticavel'), findsOneWidget);

      await tester.tap(find.widgetWithText(CheckboxListTile, 'Manha'));
      await tester.pump();

      expect(
        periodosRepository.periodos
            .any((periodo) => periodo.periodo == PeriodoDia.manha),
        isFalse,
      );
    });
  });
}

Widget _testApp({
  required List<Override> overrides,
  required Widget child,
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(home: child),
  );
}

Finder _field(String label) {
  return find.widgetWithText(TextField, label);
}

Future<void> _scrollUntilText(WidgetTester tester, String text) async {
  for (var attempt = 0; attempt < 8; attempt++) {
    if (find.text(text).evaluate().isNotEmpty) {
      return;
    }

    await tester.drag(
      find.byType(ListView).last,
      const Offset(0, -500),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
  }
}

class _FakeEmpresasRepository implements EmpresasRepository {
  _FakeEmpresasRepository(this.empresas);

  final List<Empresa> empresas;

  @override
  Stream<List<Empresa>> watchEmpresas() => Stream.value(empresas);

  @override
  Future<void> salvarEmpresa(Empresa empresa) async {
    empresas.add(empresa);
  }
}

class _FakeContratantesRepository implements ContratantesRepository {
  _FakeContratantesRepository(this.contratantes);

  final List<Contratante> contratantes;

  @override
  Stream<List<Contratante>> watchContratantes() => Stream.value(contratantes);

  @override
  Future<void> salvarContratante(Contratante contratante) async {
    contratantes.add(contratante);
  }
}

class _FakeObrasRepository implements ObrasRepository {
  final obras = <Obra>[];
  final enderecosSalvos = <Endereco>[];

  @override
  Stream<List<Obra>> watchObras() => Stream.value(obras);

  @override
  Future<void> salvarObra(Obra obra) async {
    obras.add(obra);
  }

  @override
  Future<void> salvarObraComEndereco({
    required Obra obra,
    required Endereco endereco,
  }) async {
    obras.add(obra);
    enderecosSalvos.add(endereco);
  }
}

class _FakeServicosRepository implements ServicosRepository {
  final servicos = <Servico>[];
  final progressoAtualizado = <String, double>{};

  @override
  Stream<List<Servico>> watchServicosDaEtapa(String etapaId) {
    return Stream.value(
      servicos.where((servico) => servico.etapaId == etapaId).toList(),
    );
  }

  @override
  Future<void> salvarServico(Servico servico) async {
    final index = servicos.indexWhere((item) => item.id == servico.id);
    if (index == -1) {
      servicos.add(servico);
      return;
    }

    servicos[index] = servico;
  }

  @override
  Future<void> atualizarProgressoFisico({
    required String id,
    required double progressoFisico,
  }) async {
    progressoAtualizado[id] = progressoFisico;
  }
}

class _FakeVistoriasServicoRepository implements VistoriasServicoRepository {
  _FakeVistoriasServicoRepository({List<VistoriaServico>? vistorias})
      : vistorias = [...?vistorias];

  final List<VistoriaServico> vistorias;

  @override
  Stream<List<VistoriaServico>> watchVistoriasDoServico(String servicoId) {
    return watchFiscalizacoes(servicoId: servicoId);
  }

  @override
  Stream<List<VistoriaServico>> watchFiscalizacoes({
    String? servicoId,
    String? numero,
    StatusFiscalizacao? status,
    DateTime? data,
  }) {
    return Stream.value(
      vistorias.where((vistoria) {
        final combinaServico =
            servicoId == null || vistoria.servicoId == servicoId;
        final combinaNumero = numero == null ||
            numero.trim().isEmpty ||
            vistoria.numero.contains(numero.trim());
        final combinaStatus = status == null || vistoria.status == status;
        final combinaData = data == null ||
            DateTime(vistoria.data.year, vistoria.data.month, vistoria.data.day)
                .isAtSameMomentAs(DateTime(data.year, data.month, data.day));

        return combinaServico && combinaNumero && combinaStatus && combinaData;
      }).toList(),
    );
  }

  @override
  Future<String?> buscarObraIdDoServico(String servicoId) async => 'obra-1';

  @override
  Future<void> salvarVistoria(VistoriaServico vistoria) async {
    final index = vistorias.indexWhere((item) => item.id == vistoria.id);
    if (index == -1) {
      vistorias.add(vistoria);
      return;
    }

    vistorias[index] = vistoria;
  }

  @override
  Future<void> atualizarTextosDaVistoria({
    required String id,
    String? ocorrencia,
    String? comentario,
  }) async {}
}

class _FakeVistoriasPeriodoRepository implements VistoriasPeriodoRepository {
  _FakeVistoriasPeriodoRepository(List<VistoriaPeriodo> periodos)
      : periodos = [...periodos];

  final List<VistoriaPeriodo> periodos;

  @override
  Stream<List<VistoriaPeriodo>> watchPeriodosDaVistoria(
    String vistoriaServicoId,
  ) {
    return Stream.value(
      periodos
          .where((periodo) => periodo.vistoriaServicoId == vistoriaServicoId)
          .toList(),
    );
  }

  @override
  Future<void> salvarPeriodo(VistoriaPeriodo periodo) async {
    periodos.removeWhere((item) => item.id == periodo.id);
    periodos.add(periodo);
  }

  @override
  Future<void> removerPeriodo({
    required String vistoriaServicoId,
    required PeriodoDia periodo,
  }) async {
    periodos.removeWhere(
      (item) =>
          item.vistoriaServicoId == vistoriaServicoId &&
          item.periodo == periodo,
    );
  }
}

class _FakeVistoriasMaoDeObraRepository
    implements VistoriasMaoDeObraRepository {
  @override
  Stream<List<VistoriaMaoDeObra>> watchMaoDeObraDaVistoria(
    String vistoriaServicoId,
  ) {
    return Stream.value(const []);
  }

  @override
  Stream<List<Funcionario>> watchFuncionariosDaEmpresaDaVistoria(
    String vistoriaServicoId,
  ) {
    return Stream.value(const []);
  }

  @override
  Future<String?> buscarEmpresaIdDaVistoria(String vistoriaServicoId) async {
    return 'empresa-1';
  }

  @override
  Future<void> salvarMaoDeObra(VistoriaMaoDeObra maoDeObra) async {}

  @override
  Future<void> removerMaoDeObra(String id) async {}
}

class _FakeMedicoesRepository implements MedicoesRepository {
  final medicoes = <Medicao>[];

  @override
  Stream<List<Medicao>> watchMedicoesDoServico(String servicoId) {
    return Stream.value(
      medicoes.where((medicao) => medicao.servicoId == servicoId).toList(),
    );
  }

  @override
  Stream<List<Medicao>> watchMedicoesDaFiscalizacao(
    String vistoriaServicoId,
  ) {
    return Stream.value(
      medicoes
          .where((medicao) => medicao.vistoriaServicoId == vistoriaServicoId)
          .toList(),
    );
  }

  @override
  Future<String?> buscarServicoIdDaFiscalizacao(
      String vistoriaServicoId) async {
    return 'servico-1';
  }

  @override
  Future<void> salvarMedicao(Medicao medicao) async {
    medicoes.add(medicao);
  }
}

class _FakeRelatoriosController extends RelatoriosController {
  _FakeRelatoriosController()
      : super(
          obraRepository: _FakeRelatorioObraRepository(),
          fiscalizacaoRepository: _FakeRelatorioFiscalizacaoRepository(),
          generator: const RelatorioPdfGenerator(),
        );
}

class _FakeRelatorioObraRepository implements RelatorioObraRepository {
  @override
  Future<RelatorioObraDados> carregarDadosDaObra(String obraId) {
    throw UnimplementedError();
  }
}

class _FakeRelatorioFiscalizacaoRepository
    implements RelatorioFiscalizacaoRepository {
  @override
  Future<RelatorioFiscalizacaoDados> carregarDadosDaFiscalizacao(
    String vistoriaServicoId,
  ) {
    throw UnimplementedError();
  }
}
