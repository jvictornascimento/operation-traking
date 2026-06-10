import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/medicoes/data/medicoes_repository.dart';
import 'package:operational_tracking/features/medicoes/domain/medicao.dart';
import 'package:operational_tracking/features/medicoes/presentation/medicoes_controller.dart';
import 'package:operational_tracking/features/servicos/data/servicos_repository.dart';
import 'package:operational_tracking/features/servicos/domain/servico.dart';

void main() {
  group('Story 5.1 - MedicoesController', () {
    test('rejeita medicao sem servico', () async {
      final medicoesRepository = _FakeMedicoesRepository();
      final servicosRepository = _FakeServicosRepository();
      final controller = MedicoesController(
        medicoesRepository: medicoesRepository,
        servicosRepository: servicosRepository,
      );

      await controller.salvar(
        servicoId: ' ',
        percentualExecutado: 20,
        data: DateTime(2026, 5, 20),
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(medicoesRepository.medicoes, isEmpty);
    });

    test('rejeita percentual fora do intervalo permitido', () async {
      final medicoesRepository = _FakeMedicoesRepository();
      final servicosRepository = _FakeServicosRepository();
      final controller = MedicoesController(
        medicoesRepository: medicoesRepository,
        servicosRepository: servicosRepository,
      );

      await controller.salvar(
        servicoId: 'servico-1',
        percentualExecutado: 101,
        data: DateTime(2026, 5, 20),
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(medicoesRepository.medicoes, isEmpty);
    });

    test('salva medicao e atualiza progresso fisico do servico', () async {
      final medicoesRepository = _FakeMedicoesRepository();
      final servicosRepository = _FakeServicosRepository()
        ..servicos.add(_servico(id: 'servico-1'));
      final controller = MedicoesController(
        medicoesRepository: medicoesRepository,
        servicosRepository: servicosRepository,
      );

      await controller.salvar(
        servicoId: ' servico-1 ',
        percentualExecutado: 45.678,
        observacao: ' Frente sul ',
        data: DateTime(2026, 5, 20, 15),
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(medicoesRepository.medicoes, hasLength(1));
      expect(medicoesRepository.medicoes.single.servicoId, 'servico-1');
      expect(medicoesRepository.medicoes.single.percentualExecutado, 45.68);
      expect(medicoesRepository.medicoes.single.observacao, 'Frente sul');
      expect(medicoesRepository.medicoes.single.data, DateTime(2026, 5, 20));
      expect(servicosRepository.servicos.single.progressoFisico, 45.68);
    });

    test('usa medicao mais recente para atualizar progresso fisico', () async {
      final medicoesRepository = _FakeMedicoesRepository();
      final servicosRepository = _FakeServicosRepository()
        ..servicos.add(_servico(id: 'servico-1'));
      final controller = MedicoesController(
        medicoesRepository: medicoesRepository,
        servicosRepository: servicosRepository,
      );

      await controller.salvar(
        servicoId: 'servico-1',
        percentualExecutado: 70,
        data: DateTime(2026, 5, 22),
      );
      await controller.salvar(
        servicoId: 'servico-1',
        percentualExecutado: 40,
        data: DateTime(2026, 5, 21),
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(servicosRepository.servicos.single.progressoFisico, 70);
    });

    test('salva medicao pela fiscalizacao usando o servico vinculado',
        () async {
      final medicoesRepository = _FakeMedicoesRepository()
        ..servicoPorVistoria['vistoria-1'] = 'servico-1';
      final servicosRepository = _FakeServicosRepository()
        ..servicos.add(_servico(id: 'servico-1'));
      final controller = MedicoesController(
        medicoesRepository: medicoesRepository,
        servicosRepository: servicosRepository,
      );

      await controller.salvarDaFiscalizacao(
        vistoriaServicoId: ' vistoria-1 ',
        percentualExecutado: 33.333,
        observacao: ' Liberado ',
        data: DateTime(2026, 5, 23, 9),
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(medicoesRepository.medicoes, hasLength(1));
      expect(medicoesRepository.medicoes.single.servicoId, 'servico-1');
      expect(
        medicoesRepository.medicoes.single.vistoriaServicoId,
        'vistoria-1',
      );
      expect(medicoesRepository.medicoes.single.percentualExecutado, 33.33);
      expect(medicoesRepository.medicoes.single.observacao, 'Liberado');
      expect(medicoesRepository.medicoes.single.data, DateTime(2026, 5, 23));
      expect(servicosRepository.servicos.single.progressoFisico, 33.33);
    });

    test('rejeita medicao de fiscalizacao inexistente', () async {
      final medicoesRepository = _FakeMedicoesRepository();
      final servicosRepository = _FakeServicosRepository();
      final controller = MedicoesController(
        medicoesRepository: medicoesRepository,
        servicosRepository: servicosRepository,
      );

      await controller.salvarDaFiscalizacao(
        vistoriaServicoId: 'vistoria-inexistente',
        percentualExecutado: 20,
        data: DateTime(2026, 5, 23),
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(medicoesRepository.medicoes, isEmpty);
    });
  });
}

class _FakeMedicoesRepository implements MedicoesRepository {
  final medicoes = <Medicao>[];
  final servicoPorVistoria = <String, String>{};

  @override
  Future<String?> buscarServicoIdDaFiscalizacao(
      String vistoriaServicoId) async {
    return servicoPorVistoria[vistoriaServicoId];
  }

  @override
  Future<void> salvarMedicao(Medicao medicao) async {
    final index = medicoes.indexWhere((item) => item.id == medicao.id);
    if (index == -1) {
      medicoes.add(medicao);
      return;
    }

    medicoes[index] = medicao;
  }

  @override
  Stream<List<Medicao>> watchMedicoesDoServico(String servicoId) {
    return Stream.value(
      medicoes.where((medicao) => medicao.servicoId == servicoId).toList(),
    );
  }

  @override
  Stream<List<Medicao>> watchMedicoesDaFiscalizacao(String vistoriaServicoId) {
    return Stream.value(
      medicoes
          .where((medicao) => medicao.vistoriaServicoId == vistoriaServicoId)
          .toList(),
    );
  }
}

class _FakeServicosRepository implements ServicosRepository {
  final servicos = <Servico>[];

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
    final index = servicos.indexWhere((servico) => servico.id == id);
    if (index == -1) {
      return;
    }

    final servico = servicos[index];
    servicos[index] = _servico(
      id: servico.id,
      progressoFisico: progressoFisico,
    );
  }

  @override
  Stream<List<Servico>> watchServicosDaEtapa(String etapaId) {
    return Stream.value(
      servicos.where((servico) => servico.etapaId == etapaId).toList(),
    );
  }
}

Servico _servico({
  required String id,
  double progressoFisico = 0,
}) {
  return Servico(
    id: id,
    etapaId: 'etapa-1',
    nome: 'Escavacao',
    precoTotal: 1000,
    unidade: 'm3',
    quantidade: 10,
    dataInicio: DateTime(2026, 5, 1),
    dataFim: DateTime(2026, 5, 10),
    status: StatusExecucao.emAndamento,
    progressoFisico: progressoFisico,
    progressoPrazoDias: 0,
  );
}
