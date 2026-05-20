import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/obras/data/obras_repository.dart';
import 'package:operational_tracking/features/obras/domain/obra.dart';
import 'package:operational_tracking/features/obras/presentation/obras_controller.dart';

void main() {
  group('ObrasController', () {
    test('rejeita nome vazio', () async {
      final repository = _FakeObrasRepository();
      final controller = ObrasController(repository);

      await controller.salvar(
        empresaId: 'empresa-1',
        enderecoId: 'endereco-1',
        nome: ' ',
        dataInicio: DateTime(2026, 5, 10),
        dataFim: DateTime(2026, 5, 20),
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.obras, isEmpty);
    });

    test('rejeita data final anterior a inicial', () async {
      final repository = _FakeObrasRepository();
      final controller = ObrasController(repository);

      await controller.salvar(
        empresaId: 'empresa-1',
        enderecoId: 'endereco-1',
        nome: 'Obra Regis',
        dataInicio: DateTime(2026, 5, 20),
        dataFim: DateTime(2026, 5, 10),
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.obras, isEmpty);
    });

    test('salva obra com status inicial nao comecou', () async {
      final repository = _FakeObrasRepository();
      final controller = ObrasController(repository);

      await controller.salvar(
        empresaId: ' empresa-1 ',
        enderecoId: ' endereco-1 ',
        nome: ' Obra Regis ',
        dataInicio: DateTime(2026, 5, 10),
        dataFim: DateTime(2026, 5, 20),
        dataAtual: DateTime(2026, 5, 18),
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.obras, hasLength(1));
      expect(repository.obras.single.empresaId, 'empresa-1');
      expect(repository.obras.single.enderecoId, 'endereco-1');
      expect(repository.obras.single.nome, 'Obra Regis');
      expect(repository.obras.single.status, StatusExecucao.naoComecou);
      expect(repository.obras.single.progressoPrazoDias, 2);
      expect(repository.obras.single.progressoFisico, 0);
    });

    test('marca obra como atrasada quando prazo esta negativo', () async {
      final repository = _FakeObrasRepository();
      final controller = ObrasController(repository);

      await controller.salvar(
        empresaId: 'empresa-1',
        enderecoId: 'endereco-1',
        nome: 'Obra Regis',
        dataInicio: DateTime(2026, 5, 10),
        dataFim: DateTime(2026, 5, 20),
        status: StatusExecucao.emAndamento,
        dataAtual: DateTime(2026, 5, 21),
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.obras.single.status, StatusExecucao.atrasada);
      expect(repository.obras.single.progressoPrazoDias, -1);
    });
  });
}

class _FakeObrasRepository implements ObrasRepository {
  final obras = <Obra>[];

  @override
  Future<void> salvarObra(Obra obra) async {
    obras.add(obra);
  }

  @override
  Stream<List<Obra>> watchObras() {
    return Stream.value(obras);
  }
}
