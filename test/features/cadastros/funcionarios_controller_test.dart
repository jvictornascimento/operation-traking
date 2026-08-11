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

    test('inativa funcionario normalizando id', () async {
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
      expect(repository.funcionarios, hasLength(1));
      expect(repository.funcionarios.single.ativo, isFalse);
      expect(repository.funcionarios.single.excluidoEm, isNotNull);
    });
  });
}

class _FakeFuncionariosRepository implements FuncionariosRepository {
  final funcionarios = <Funcionario>[];

  @override
  Future<void> salvarFuncionario(Funcionario funcionario) async {
    final index = funcionarios.indexWhere((item) => item.id == funcionario.id);
    if (index == -1) {
      funcionarios.add(funcionario);
      return;
    }

    funcionarios[index] = funcionario;
  }

  @override
  Future<void> removerFuncionario(String id) async {
    final index =
        funcionarios.indexWhere((funcionario) => funcionario.id == id);
    if (index == -1) {
      return;
    }

    final funcionario = funcionarios[index];
    funcionarios[index] = Funcionario(
      id: funcionario.id,
      empresaId: funcionario.empresaId,
      contratanteId: funcionario.contratanteId,
      nome: funcionario.nome,
      cpf: funcionario.cpf,
      telefone: funcionario.telefone,
      cargo: funcionario.cargo,
      tipo: funcionario.tipo,
      assinaturaPath: funcionario.assinaturaPath,
      ativo: false,
      excluidoEm: DateTime.now(),
      motivoInativacao: 'Removido pelo usuario.',
    );
  }

  @override
  Stream<List<Funcionario>> watchFuncionariosDaEmpresa(String empresaId) {
    return Stream.value(
      funcionarios
          .where((funcionario) =>
              funcionario.empresaId == empresaId && funcionario.ativo)
          .toList(),
    );
  }

  @override
  Stream<List<Funcionario>> watchFuncionariosDoContratante(
    String contratanteId,
  ) {
    return Stream.value(
      funcionarios
          .where((funcionario) =>
              funcionario.contratanteId == contratanteId && funcionario.ativo)
          .toList(),
    );
  }
}
