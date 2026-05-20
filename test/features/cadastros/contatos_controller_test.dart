import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/cadastros/data/contatos_repository.dart';
import 'package:operational_tracking/features/cadastros/domain/contato.dart';
import 'package:operational_tracking/features/cadastros/presentation/contatos_controller.dart';

void main() {
  group('ContatosController', () {
    test('rejeita entidade vazia', () async {
      final repository = _FakeContatosRepository();
      final controller = ContatosController(repository);

      await controller.salvar(
        entidade: TipoEntidadeContato.empresa,
        entidadeId: ' ',
        tipo: TipoContato.email,
        valor: 'contato@empresa.com',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.contatos, isEmpty);
    });

    test('rejeita valor vazio', () async {
      final repository = _FakeContatosRepository();
      final controller = ContatosController(repository);

      await controller.salvar(
        entidade: TipoEntidadeContato.empresa,
        entidadeId: 'empresa-1',
        tipo: TipoContato.telefone,
        valor: ' ',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.contatos, isEmpty);
    });

    test('salva contato normalizado', () async {
      final repository = _FakeContatosRepository();
      final controller = ContatosController(repository);

      await controller.salvar(
        entidade: TipoEntidadeContato.funcionario,
        entidadeId: ' funcionario-1 ',
        tipo: TipoContato.whatsapp,
        valor: ' 11999999999 ',
        observacao: ' ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.contatos, hasLength(1));
      expect(repository.contatos.single.entidadeId, 'funcionario-1');
      expect(repository.contatos.single.tipo, TipoContato.whatsapp);
      expect(repository.contatos.single.valor, '11999999999');
      expect(repository.contatos.single.observacao, isNull);
    });
  });
}

class _FakeContatosRepository implements ContatosRepository {
  final contatos = <Contato>[];

  @override
  Future<void> salvarContato(Contato contato) async {
    contatos.add(contato);
  }

  @override
  Stream<List<Contato>> watchContatos({
    required TipoEntidadeContato entidade,
    required String entidadeId,
  }) {
    return Stream.value(
      contatos
          .where(
            (contato) =>
                contato.entidade == entidade && contato.entidadeId == entidadeId,
          )
          .toList(),
    );
  }
}
