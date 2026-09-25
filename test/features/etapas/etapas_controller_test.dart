import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:belis_oversight/core/domain/domain_enums.dart';
import 'package:belis_oversight/features/etapas/data/etapas_repository.dart';
import 'package:belis_oversight/features/etapas/domain/etapa.dart';
import 'package:belis_oversight/features/etapas/presentation/etapas_controller.dart';

void main() {
  group('EtapasController', () {
    test('rejeita obra vazia', () async {
      final repository = _FakeEtapasRepository();
      final controller = EtapasController(repository);

      await controller.salvar(
        obraId: ' ',
        nome: 'Fundacao',
        dataInicio: DateTime(2026, 5, 10),
        dataFim: DateTime(2026, 5, 20),
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.etapas, isEmpty);
    });

    test('salva etapa vinculada a obra', () async {
      final repository = _FakeEtapasRepository();
      final controller = EtapasController(repository);

      await controller.salvar(
        obraId: ' obra-1 ',
        nome: ' Fundacao ',
        dataInicio: DateTime(2026, 5, 10),
        dataFim: DateTime(2026, 5, 20),
        dataAtual: DateTime(2026, 5, 18),
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.etapas, hasLength(1));
      expect(repository.etapas.single.obraId, 'obra-1');
      expect(repository.etapas.single.nome, 'Fundacao');
      expect(repository.etapas.single.status, StatusExecucao.naoComecou);
      expect(repository.etapas.single.progressoPrazoDias, 2);
    });

    test('marca etapa como atrasada quando prazo esta negativo', () async {
      final repository = _FakeEtapasRepository();
      final controller = EtapasController(repository);

      await controller.salvar(
        obraId: 'obra-1',
        nome: 'Fundacao',
        dataInicio: DateTime(2026, 5, 10),
        dataFim: DateTime(2026, 5, 20),
        status: StatusExecucao.emAndamento,
        dataAtual: DateTime(2026, 5, 21),
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.etapas.single.status, StatusExecucao.atrasada);
      expect(repository.etapas.single.progressoPrazoDias, -1);
    });
  });
}

class _FakeEtapasRepository implements EtapasRepository {
  final etapas = <Etapa>[];

  @override
  Future<void> salvarEtapa(Etapa etapa) async {
    etapas.add(etapa);
  }

  @override
  Stream<List<Etapa>> watchEtapasDaObra(String obraId) {
    return Stream.value(
      etapas.where((etapa) => etapa.obraId == obraId).toList(),
    );
  }
}
