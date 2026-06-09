import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/servicos/data/servicos_repository.dart';
import 'package:operational_tracking/features/servicos/domain/servico.dart';
import 'package:operational_tracking/features/servicos/presentation/servicos_controller.dart';

void main() {
  group('ServicosController', () {
    test('rejeita etapa vazia', () async {
      final repository = _FakeServicosRepository();
      final controller = ServicosController(repository);

      await controller.salvar(
        etapaId: ' ',
        nome: 'Alvenaria',
        precoTotal: 1000,
        unidade: 'm2',
        quantidade: 20,
        dataInicio: DateTime(2026, 5, 10),
        dataFim: DateTime(2026, 5, 20),
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.servicos, isEmpty);
    });

    test('rejeita preco negativo', () async {
      final repository = _FakeServicosRepository();
      final controller = ServicosController(repository);

      await controller.salvar(
        etapaId: 'etapa-1',
        nome: 'Alvenaria',
        precoTotal: -1,
        unidade: 'm2',
        quantidade: 20,
        dataInicio: DateTime(2026, 5, 10),
        dataFim: DateTime(2026, 5, 20),
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.servicos, isEmpty);
    });

    test('salva servico vinculado a etapa', () async {
      final repository = _FakeServicosRepository();
      final controller = ServicosController(repository);

      await controller.salvar(
        etapaId: ' etapa-1 ',
        nome: ' Alvenaria ',
        precoTotal: 1000,
        unidade: ' m2 ',
        quantidade: 20,
        dataInicio: DateTime(2026, 5, 10),
        dataFim: DateTime(2026, 5, 20),
        dataAtual: DateTime(2026, 5, 18),
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.servicos, hasLength(1));
      expect(repository.servicos.single.etapaId, 'etapa-1');
      expect(repository.servicos.single.nome, 'Alvenaria');
      expect(repository.servicos.single.unidade, 'm2');
      expect(repository.servicos.single.quantidade, 20);
      expect(repository.servicos.single.status, StatusExecucao.naoComecou);
      expect(repository.servicos.single.progressoPrazoDias, 2);
    });

    test('marca servico como atrasado quando prazo esta negativo', () async {
      final repository = _FakeServicosRepository();
      final controller = ServicosController(repository);

      await controller.salvar(
        etapaId: 'etapa-1',
        nome: 'Alvenaria',
        precoTotal: 1000,
        unidade: 'm2',
        quantidade: 20,
        dataInicio: DateTime(2026, 5, 10),
        dataFim: DateTime(2026, 5, 20),
        status: StatusExecucao.emAndamento,
        dataAtual: DateTime(2026, 5, 21),
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.servicos.single.status, StatusExecucao.atrasada);
      expect(repository.servicos.single.progressoPrazoDias, -1);
    });
  });
}

class _FakeServicosRepository implements ServicosRepository {
  final servicos = <Servico>[];

  @override
  Future<void> salvarServico(Servico servico) async {
    servicos.add(servico);
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
    servicos[index] = Servico(
      id: servico.id,
      etapaId: servico.etapaId,
      nome: servico.nome,
      precoTotal: servico.precoTotal,
      unidade: servico.unidade,
      quantidade: servico.quantidade,
      dataInicio: servico.dataInicio,
      dataFim: servico.dataFim,
      status: servico.status,
      progressoFisico: progressoFisico,
      progressoPrazoDias: servico.progressoPrazoDias,
    );
  }

  @override
  Stream<List<Servico>> watchServicosDaEtapa(String etapaId) {
    return Stream.value(
      servicos.where((servico) => servico.etapaId == etapaId).toList(),
    );
  }
}
