import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:belis_oversight/features/cadastros/data/empresas_repository.dart';
import 'package:belis_oversight/features/cadastros/domain/empresa.dart';
import 'package:belis_oversight/features/cadastros/presentation/empresas_controller.dart';

void main() {
  group('EmpresasController', () {
    test('rejeita nome vazio', () async {
      final repository = _FakeEmpresasRepository();
      final controller = EmpresasController(repository);

      await controller.salvar(nome: '   ');

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.empresas, isEmpty);
    });

    test('salva empresa com nome normalizado', () async {
      final repository = _FakeEmpresasRepository();
      final controller = EmpresasController(repository);

      await controller.salvar(
        nome: '  Construtora Regis  ',
        cnpj: '  123  ',
        ie: ' ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.empresas, hasLength(1));
      expect(repository.empresas.single.nome, 'Construtora Regis');
      expect(repository.empresas.single.cnpj, '123');
      expect(repository.empresas.single.ie, isNull);
    });
  });
}

class _FakeEmpresasRepository implements EmpresasRepository {
  final empresas = <Empresa>[];

  @override
  Future<void> salvarEmpresa(Empresa empresa) async {
    empresas.add(empresa);
  }

  @override
  Stream<List<Empresa>> watchEmpresas() {
    return Stream.value(empresas);
  }
}
