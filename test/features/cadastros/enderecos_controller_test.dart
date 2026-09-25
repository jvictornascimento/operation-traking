import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:belis_oversight/core/domain/domain_enums.dart';
import 'package:belis_oversight/features/cadastros/data/enderecos_repository.dart';
import 'package:belis_oversight/features/cadastros/domain/endereco.dart';
import 'package:belis_oversight/features/cadastros/presentation/enderecos_controller.dart';

void main() {
  group('EnderecosController', () {
    test('rejeita entidade vazia', () async {
      final repository = _FakeEnderecosRepository();
      final controller = EnderecosController(repository);

      await controller.salvar(
        entidade: TipoEntidadeEndereco.empresa,
        entidadeId: ' ',
        tipo: 'Comercial',
        cidade: 'Sao Paulo',
        estado: 'SP',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.enderecos, isEmpty);
    });

    test('rejeita tipo vazio', () async {
      final repository = _FakeEnderecosRepository();
      final controller = EnderecosController(repository);

      await controller.salvar(
        entidade: TipoEntidadeEndereco.empresa,
        entidadeId: 'empresa-1',
        tipo: ' ',
        cidade: 'Sao Paulo',
        estado: 'SP',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.enderecos, isEmpty);
    });

    test('salva endereco normalizado', () async {
      final repository = _FakeEnderecosRepository();
      final controller = EnderecosController(repository);

      await controller.salvar(
        entidade: TipoEntidadeEndereco.obra,
        entidadeId: ' obra-1 ',
        tipo: ' Principal ',
        cidade: ' Campinas ',
        estado: ' SP ',
        pais: ' ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.enderecos, hasLength(1));
      expect(repository.enderecos.single.entidadeId, 'obra-1');
      expect(repository.enderecos.single.tipo, 'Principal');
      expect(repository.enderecos.single.cidade, 'Campinas');
      expect(repository.enderecos.single.estado, 'SP');
      expect(repository.enderecos.single.pais, 'Brasil');
    });
  });
}

class _FakeEnderecosRepository implements EnderecosRepository {
  final enderecos = <Endereco>[];

  @override
  Future<void> salvarEndereco(Endereco endereco) async {
    enderecos.add(endereco);
  }

  @override
  Stream<List<Endereco>> watchEnderecos({
    required TipoEntidadeEndereco entidade,
    required String entidadeId,
  }) {
    return Stream.value(
      enderecos
          .where(
            (endereco) =>
                endereco.entidade == entidade &&
                endereco.entidadeId == entidadeId,
          )
          .toList(),
    );
  }
}
