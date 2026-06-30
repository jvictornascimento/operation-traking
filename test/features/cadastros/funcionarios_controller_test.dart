import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/features/cadastros/data/funcionarios_repository.dart';
import 'package:operational_tracking/features/cadastros/domain/funcionario.dart';
import 'package:operational_tracking/features/cadastros/presentation/funcionarios_controller.dart';

void main() {
  group('FuncionariosController', () {
    test('rejeita funcionario sem empresa e sem contratante', () async {
      final repository = _FakeFuncionariosRepository();
      final controller = FuncionariosController(repository);

      await controller.salvar(
        nome: 'Regis',
        cargo: 'Responsavel',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.funcionarios, isEmpty);
    });

    test('rejeita funcionario com empresa e contratante ao mesmo tempo',
        () async {
      final repository = _FakeFuncionariosRepository();
      final controller = FuncionariosController(repository);

      await controller.salvar(
        empresaId: 'empresa-1',
        contratanteId: 'contratante-1',
        nome: 'Regis',
        cargo: 'Responsavel',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.funcionarios, isEmpty);
    });

    test('salva funcionario de empresa normalizado', () async {
      final repository = _FakeFuncionariosRepository();
      final controller = FuncionariosController(repository);

      await controller.salvar(
        empresaId: ' empresa-1 ',
        nome: ' Joao ',
        cpf: ' 123 ',
        telefone: ' 11999990000 ',
        cargo: ' Pedreiro ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.funcionarios, hasLength(1));
      expect(repository.funcionarios.single.empresaId, 'empresa-1');
      expect(repository.funcionarios.single.contratanteId, isNull);
      expect(repository.funcionarios.single.nome, 'Joao');
      expect(repository.funcionarios.single.telefone, '11999990000');
      expect(repository.funcionarios.single.cargo, 'Pedreiro');
      expect(repository.funcionarios.single.tipo, 'func_empresa');
    });

    test('salva funcionario de contratante normalizado com assinatura',
        () async {
      final repository = _FakeFuncionariosRepository();
      final controller = FuncionariosController(repository);

      await controller.salvar(
        contratanteId: ' contratante-1 ',
        nome: ' Regis ',
        telefone: ' 11988887777 ',
        cargo: ' Fiscal ',
        assinaturaPath: ' /app/assinatura.png ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.funcionarios, hasLength(1));
      expect(repository.funcionarios.single.empresaId, isNull);
      expect(repository.funcionarios.single.contratanteId, 'contratante-1');
      expect(repository.funcionarios.single.nome, 'Regis');
      expect(repository.funcionarios.single.telefone, '11988887777');
      expect(repository.funcionarios.single.cargo, 'Fiscal');
      expect(repository.funcionarios.single.tipo, 'func_contratante');
      expect(
          repository.funcionarios.single.assinaturaPath, '/app/assinatura.png');
    });

    test('remove funcionario normalizando id', () async {
      final repository = _FakeFuncionariosRepository();
      final controller = FuncionariosController(repository);

      await controller.salvar(
        id: 'funcionario-1',
        empresaId: 'empresa-1',
        nome: 'Joao',
        cargo: 'Pedreiro',
      );
      await controller.remover(' funcionario-1 ');

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.funcionarios, isEmpty);
    });
  });
}

class _FakeFuncionariosRepository implements FuncionariosRepository {
  final funcionarios = <Funcionario>[];

  @override
  Future<void> salvarFuncionario(Funcionario funcionario) async {
    funcionarios.add(funcionario);
  }

  @override
  Future<void> removerFuncionario(String id) async {
    funcionarios.removeWhere((funcionario) => funcionario.id == id);
  }

  @override
  Stream<List<Funcionario>> watchFuncionariosDaEmpresa(String empresaId) {
    return Stream.value(
      funcionarios
          .where((funcionario) => funcionario.empresaId == empresaId)
          .toList(),
    );
  }

  @override
  Stream<List<Funcionario>> watchFuncionariosDoContratante(
    String contratanteId,
  ) {
    return Stream.value(
      funcionarios
          .where((funcionario) => funcionario.contratanteId == contratanteId)
          .toList(),
    );
  }
}
