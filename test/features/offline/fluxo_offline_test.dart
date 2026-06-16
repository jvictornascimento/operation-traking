import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/database/app_database.dart' as db;
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/cadastros/data/contratantes_repository.dart';
import 'package:operational_tracking/features/cadastros/data/empresas_repository.dart';
import 'package:operational_tracking/features/cadastros/data/funcionarios_repository.dart';
import 'package:operational_tracking/features/cadastros/presentation/contratantes_controller.dart';
import 'package:operational_tracking/features/cadastros/presentation/empresas_controller.dart';
import 'package:operational_tracking/features/cadastros/presentation/funcionarios_controller.dart';
import 'package:operational_tracking/features/etapas/data/etapas_repository.dart';
import 'package:operational_tracking/features/etapas/presentation/etapas_controller.dart';
import 'package:operational_tracking/features/fiscalizacoes/data/vistorias_mao_de_obra_repository.dart';
import 'package:operational_tracking/features/fiscalizacoes/data/vistorias_periodo_repository.dart';
import 'package:operational_tracking/features/fiscalizacoes/data/vistorias_servico_repository.dart';
import 'package:operational_tracking/features/fiscalizacoes/presentation/fiscalizacoes_controller.dart';
import 'package:operational_tracking/features/medicoes/data/fotos_medicao_repository.dart';
import 'package:operational_tracking/features/medicoes/data/medicoes_repository.dart';
import 'package:operational_tracking/features/medicoes/domain/foto_medicao.dart';
import 'package:operational_tracking/features/medicoes/presentation/medicoes_controller.dart';
import 'package:operational_tracking/features/obras/data/obras_repository.dart';
import 'package:operational_tracking/features/obras/presentation/obras_controller.dart';
import 'package:operational_tracking/features/relatorios/data/relatorio_fiscalizacao_repository.dart';
import 'package:operational_tracking/features/relatorios/data/relatorio_pdf_generator.dart';
import 'package:operational_tracking/features/servicos/data/servicos_repository.dart';
import 'package:operational_tracking/features/servicos/presentation/servicos_controller.dart';
import 'package:sqlite3/open.dart';

void main() {
  late db.AppDatabase database;
  late Directory tempDir;

  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
  });

  setUp(() async {
    database = db.AppDatabase.forTesting(NativeDatabase.memory());
    tempDir = await Directory.systemTemp.createTemp('fluxo-offline-');
  });

  tearDown(() async {
    await database.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Story 10.4 - fluxo offline completo', () {
    test('cria dados locais do cadastro ao PDF sem depender de servidor',
        () async {
      final empresasRepository = DriftEmpresasRepository(database);
      final contratantesRepository = DriftContratantesRepository(database);
      final funcionariosRepository = DriftFuncionariosRepository(database);
      final obrasRepository = DriftObrasRepository(database);
      final etapasRepository = DriftEtapasRepository(database);
      final servicosRepository = DriftServicosRepository(database);
      final fiscalizacoesRepository = DriftVistoriasServicoRepository(database);
      final periodosRepository = DriftVistoriasPeriodoRepository(database);
      final maoDeObraRepository = DriftVistoriasMaoDeObraRepository(database);
      final medicoesRepository = DriftMedicoesRepository(database);
      final fotosRepository = DriftFotosMedicaoRepository(database);
      final relatorioRepository = DriftRelatorioFiscalizacaoRepository(
        database,
      );
      const pdfGenerator = RelatorioPdfGenerator();

      await EmpresasController(empresasRepository).salvar(
        id: 'empresa-1',
        nome: 'Construtora Regis',
      );
      await ContratantesController(contratantesRepository).salvar(
        id: 'contratante-1',
        nome: 'Cliente Regis',
      );
      await FuncionariosController(funcionariosRepository).salvar(
        id: 'funcionario-empresa-1',
        empresaId: 'empresa-1',
        nome: 'Ana',
        cargo: 'Pedreira',
      );
      await FuncionariosController(funcionariosRepository).salvar(
        id: 'funcionario-contratante-1',
        contratanteId: 'contratante-1',
        nome: 'Regis',
        cargo: 'Fiscal',
      );

      await ObrasController(obrasRepository).salvar(
        id: 'obra-1',
        empresaId: 'empresa-1',
        nome: 'Obra Central',
        dataInicio: DateTime(2026, 6, 1),
        dataFim: DateTime(2026, 7, 1),
        dataAtual: DateTime(2026, 6, 15),
        enderecoId: 'endereco-1',
        enderecoCidade: 'Campinas',
        enderecoEstado: 'SP',
      );
      await EtapasController(etapasRepository).salvar(
        id: 'etapa-1',
        obraId: 'obra-1',
        nome: 'Fundacao',
        dataInicio: DateTime(2026, 6, 1),
        dataFim: DateTime(2026, 6, 20),
        dataAtual: DateTime(2026, 6, 15),
      );
      await ServicosController(servicosRepository).salvar(
        id: 'servico-1',
        etapaId: 'etapa-1',
        nome: 'Escavacao',
        precoTotal: 1000,
        unidade: 'm3',
        quantidade: 10,
        dataInicio: DateTime(2026, 6, 1),
        dataFim: DateTime(2026, 6, 20),
        dataAtual: DateTime(2026, 6, 15),
      );

      final fiscalizacoesController = FiscalizacoesController(
        fiscalizacoesRepository,
      );
      await fiscalizacoesController.salvar(
        id: 'vistoria-1',
        servicoId: 'servico-1',
        obraId: '',
        contratanteId: 'contratante-1',
        responsavelId: 'funcionario-contratante-1',
        numero: 'FISC-001',
        data: DateTime(2026, 6, 15),
      );
      await fiscalizacoesController.salvarTextos(
        id: 'vistoria-1',
        ocorrencia: 'Sem ocorrencias',
        comentario: 'Servico liberado em campo',
      );
      await PeriodosFiscalizacaoController(periodosRepository).salvar(
        id: 'periodo-1',
        vistoriaServicoId: 'vistoria-1',
        periodo: PeriodoDia.manha,
        tempo: TempoPeriodo.claro,
        condicao: CondicaoPeriodo.praticavel,
      );
      await MaoDeObraFiscalizacaoController(maoDeObraRepository).salvar(
        id: 'mao-obra-1',
        vistoriaServicoId: 'vistoria-1',
        funcionarioId: 'funcionario-empresa-1',
        funcaoNoDia: 'Pedreira',
        observacao: 'Equipe local',
      );

      await MedicoesController(
        medicoesRepository: medicoesRepository,
        servicosRepository: servicosRepository,
      ).salvarDaFiscalizacao(
        id: 'medicao-1',
        vistoriaServicoId: 'vistoria-1',
        percentualExecutado: 65,
        observacao: 'Frente norte concluida',
        data: DateTime(2026, 6, 15),
      );

      final fotoFile = File('${tempDir.path}/foto-1.png');
      await fotoFile.writeAsBytes(_pngTransparente1x1());
      await fotosRepository.salvarFoto(
        FotoMedicao(
          id: 'foto-1',
          medicaoId: 'medicao-1',
          caminhoArquivo: fotoFile.path,
        ),
      );

      final dadosRelatorio =
          await relatorioRepository.carregarDadosDaFiscalizacao('vistoria-1');
      final pdfBytes = await pdfGenerator.gerarRelatorioFiscalizacao(
        dadosRelatorio,
      );
      final pdfFile = File('${tempDir.path}/relatorio-vistoria-1.pdf');
      await pdfFile.writeAsBytes(pdfBytes, flush: true);

      final empresas = await database.select(database.empresas).get();
      final contratantes = await database.select(database.contratantes).get();
      final funcionarios = await database.select(database.funcionarios).get();
      final obras = await database.select(database.obras).get();
      final etapas = await database.select(database.etapas).get();
      final servicos = await database.select(database.servicos).get();
      final fiscalizacoes =
          await database.select(database.vistoriasServico).get();
      final periodos = await database.select(database.vistoriasPeriodo).get();
      final maoDeObra =
          await database.select(database.vistoriasMaoDeObra).get();
      final medicoes = await database.select(database.medicoes).get();
      final fotos = await database.select(database.fotos).get();

      expect(empresas, hasLength(1));
      expect(contratantes, hasLength(1));
      expect(funcionarios, hasLength(2));
      expect(obras.single.nome, 'Obra Central');
      expect(etapas.single.obraId, 'obra-1');
      expect(servicos.single.etapaId, 'etapa-1');
      expect(servicos.single.progressoFisico, 65);
      expect(fiscalizacoes.single.obraId, 'obra-1');
      expect(fiscalizacoes.single.ocorrencia, 'Sem ocorrencias');
      expect(fiscalizacoes.single.comentario, 'Servico liberado em campo');
      expect(periodos.single.periodo, PeriodoDia.manha.name);
      expect(maoDeObra.single.funcionarioId, 'funcionario-empresa-1');
      expect(medicoes.single.vistoriaServicoId, 'vistoria-1');
      expect(medicoes.single.percentualExecutado, 65);
      expect(fotos.single.caminhoArquivo, fotoFile.path);
      expect(await fotoFile.exists(), isTrue);
      expect(await pdfFile.exists(), isTrue);
      expect(pdfBytes, isNotEmpty);
      expect(String.fromCharCodes(pdfBytes.take(4)), '%PDF');
      expect(dadosRelatorio.fotos.single.caminhoArquivo, fotoFile.path);
    });
  });
}

List<int> _pngTransparente1x1() {
  return base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
  );
}
