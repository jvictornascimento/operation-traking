import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:belis_oversight/features/cadastros/domain/funcionario.dart';
import 'package:belis_oversight/features/fiscalizacoes/data/vistorias_mao_de_obra_repository.dart';
import 'package:belis_oversight/features/fiscalizacoes/domain/vistoria_mao_de_obra.dart';
import 'package:belis_oversight/features/fiscalizacoes/presentation/fiscalizacoes_controller.dart';

void main() {
  group('Story 4.4 - MaoDeObraFiscalizacaoController', () {
    test('rejeita mao de obra sem fiscalizacao', () async {
      final repository = _FakeVistoriasMaoDeObraRepository();
      final controller = MaoDeObraFiscalizacaoController(repository);

      await controller.salvar(
        vistoriaServicoId: ' ',
        funcionarioId: 'funcionario-1',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.maoDeObra, isEmpty);
    });

    test('rejeita mao de obra sem funcionario', () async {
      final repository = _FakeVistoriasMaoDeObraRepository();
      final controller = MaoDeObraFiscalizacaoController(repository);

      await controller.salvar(
        vistoriaServicoId: 'vistoria-1',
        funcionarioId: ' ',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.maoDeObra, isEmpty);
    });

    test('salva mao de obra normalizando textos opcionais', () async {
      final repository = _FakeVistoriasMaoDeObraRepository();
      final controller = MaoDeObraFiscalizacaoController(repository);

      await controller.salvar(
        vistoriaServicoId: ' vistoria-1 ',
        funcionarioId: ' funcionario-1 ',
        funcaoNoDia: ' Pedreiro ',
        observacao: ' Frente norte ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.maoDeObra, hasLength(1));
      expect(repository.maoDeObra.single.vistoriaServicoId, 'vistoria-1');
      expect(repository.maoDeObra.single.funcionarioId, 'funcionario-1');
      expect(repository.maoDeObra.single.funcaoNoDia, 'Pedreiro');
      expect(repository.maoDeObra.single.observacao, 'Frente norte');
    });

    test('edita mao de obra existente', () async {
      final repository = _FakeVistoriasMaoDeObraRepository();
      final controller = MaoDeObraFiscalizacaoController(repository);

      await controller.salvar(
        id: 'mao-obra-1',
        vistoriaServicoId: 'vistoria-1',
        funcionarioId: 'funcionario-1',
        funcaoNoDia: 'Ajudante',
      );
      await controller.salvar(
        id: 'mao-obra-1',
        vistoriaServicoId: 'vistoria-1',
        funcionarioId: 'funcionario-1',
        funcaoNoDia: 'Pedreiro',
        observacao: 'Realocado',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.maoDeObra, hasLength(1));
      expect(repository.maoDeObra.single.funcaoNoDia, 'Pedreiro');
      expect(repository.maoDeObra.single.observacao, 'Realocado');
    });

    test('remove funcionario da mao de obra', () async {
      final repository = _FakeVistoriasMaoDeObraRepository();
      final controller = MaoDeObraFiscalizacaoController(repository);

      await controller.salvar(
        id: 'mao-obra-1',
        vistoriaServicoId: 'vistoria-1',
        funcionarioId: 'funcionario-1',
      );
      await controller.remover(' mao-obra-1 ');

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.maoDeObra, isEmpty);
    });
  });
}

class _FakeVistoriasMaoDeObraRepository
    implements VistoriasMaoDeObraRepository {
  final maoDeObra = <VistoriaMaoDeObra>[];

  @override
  Future<void> salvarMaoDeObra(VistoriaMaoDeObra item) async {
    final index = maoDeObra.indexWhere((value) => value.id == item.id);
    if (index == -1) {
      maoDeObra.add(item);
      return;
    }

    maoDeObra[index] = item;
  }

  @override
  Future<void> removerMaoDeObra(String id) async {
    maoDeObra.removeWhere((item) => item.id == id);
  }

  @override
  Stream<List<VistoriaMaoDeObra>> watchMaoDeObraDaVistoria(
    String vistoriaServicoId,
  ) {
    return Stream.value(
      maoDeObra
          .where((item) => item.vistoriaServicoId == vistoriaServicoId)
          .toList(),
    );
  }

  @override
  Stream<List<Funcionario>> watchFuncionariosDaEmpresaDaVistoria(
    String vistoriaServicoId,
  ) {
    return const Stream.empty();
  }

  @override
  Future<String?> buscarEmpresaIdDaVistoria(String vistoriaServicoId) async {
    return 'empresa-1';
  }
}
