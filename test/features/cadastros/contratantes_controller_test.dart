import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:belis_oversight/features/cadastros/data/contratantes_repository.dart';
import 'package:belis_oversight/features/cadastros/domain/contratante.dart';
import 'package:belis_oversight/features/cadastros/presentation/contratantes_controller.dart';

void main() {
  group('ContratantesController', () {
    test('rejeita nome vazio', () async {
      final repository = _FakeContratantesRepository();
      final controller = ContratantesController(repository);

      await controller.salvar(nome: '   ');

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.contratantes, isEmpty);
    });

    test('salva contratante com nome normalizado', () async {
      final repository = _FakeContratantesRepository();
      final controller = ContratantesController(repository);

      await controller.salvar(
        nome: '  Cliente Regis  ',
        cnpj: '  456  ',
        ie: ' ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.contratantes, hasLength(1));
      expect(repository.contratantes.single.nome, 'Cliente Regis');
      expect(repository.contratantes.single.cnpj, '456');
      expect(repository.contratantes.single.ie, isNull);
    });
  });
}

class _FakeContratantesRepository implements ContratantesRepository {
  final contratantes = <Contratante>[];

  @override
  Future<void> salvarContratante(Contratante contratante) async {
    contratantes.add(contratante);
  }

  @override
  Stream<List<Contratante>> watchContratantes() {
    return Stream.value(contratantes);
  }
}
