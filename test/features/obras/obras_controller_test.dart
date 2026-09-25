import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:belis_oversight/core/domain/domain_enums.dart';
import 'package:belis_oversight/features/cadastros/domain/endereco.dart';
import 'package:belis_oversight/features/obras/data/obras_repository.dart';
import 'package:belis_oversight/features/obras/domain/obra.dart';
import 'package:belis_oversight/features/obras/presentation/obras_controller.dart';

void main() {
  group('ObrasController', () {
    test('rejeita nome vazio', () async {
      final repository = _FakeObrasRepository();
      final controller = ObrasController(repository);

      await controller.salvar(
        empresaId: 'empresa-1',
        contratanteId: 'contratante-1',
        nome: ' ',
        dataInicio: DateTime(2026, 5, 10),
        dataFim: DateTime(2026, 5, 20),
        enderecoCidade: 'Campinas',
        enderecoEstado: 'SP',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.obras, isEmpty);
    });

    test('rejeita data final anterior a inicial', () async {
      final repository = _FakeObrasRepository();
      final controller = ObrasController(repository);

      await controller.salvar(
        empresaId: 'empresa-1',
        contratanteId: 'contratante-1',
        nome: 'Obra Regis',
        dataInicio: DateTime(2026, 5, 20),
        dataFim: DateTime(2026, 5, 10),
        enderecoCidade: 'Campinas',
        enderecoEstado: 'SP',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.obras, isEmpty);
    });

    test('salva obra com status inicial nao comecou', () async {
      final repository = _FakeObrasRepository();
      final controller = ObrasController(repository);

      await controller.salvar(
        empresaId: ' empresa-1 ',
        contratanteId: ' contratante-1 ',
        nome: ' Obra Regis ',
        numeroContrato: ' CTR-001 ',
        valorContrato: ' 1.250,50 ',
        responsavelNome: ' Regis ',
        responsavelContato: ' 11999999999 ',
        dataInicio: DateTime(2026, 5, 10),
        dataFim: DateTime(2026, 5, 20),
        dataAtual: DateTime(2026, 5, 18),
        enderecoTipo: ' Principal ',
        enderecoCidade: ' Campinas ',
        enderecoEstado: ' SP ',
        enderecoLogradouro: ' Rua Um ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.obras, hasLength(1));
      expect(repository.obras.single.empresaId, 'empresa-1');
      expect(repository.obras.single.contratanteId, 'contratante-1');
      expect(repository.obras.single.numeroContrato, 'CTR-001');
      expect(repository.obras.single.valorContrato, 1250.50);
      expect(repository.obras.single.responsavelNome, 'Regis');
      expect(repository.obras.single.responsavelContato, '11999999999');
      expect(repository.enderecos, hasLength(1));
      expect(
          repository.obras.single.enderecoId, repository.enderecos.single.id);
      expect(repository.obras.single.nome, 'Obra Regis');
      expect(repository.obras.single.status, StatusExecucao.naoComecou);
      expect(repository.obras.single.progressoPrazoDias, 2);
      expect(repository.obras.single.progressoFisico, 0);
      expect(
          repository.enderecos.single.entidadeId, repository.obras.single.id);
      expect(repository.enderecos.single.tipo, 'Principal');
      expect(repository.enderecos.single.cidade, 'Campinas');
      expect(repository.enderecos.single.estado, 'SP');
      expect(repository.enderecos.single.logradouro, 'Rua Um');
    });

    test('marca obra como atrasada quando prazo esta negativo', () async {
      final repository = _FakeObrasRepository();
      final controller = ObrasController(repository);

      await controller.salvar(
        empresaId: 'empresa-1',
        contratanteId: 'contratante-1',
        nome: 'Obra Regis',
        dataInicio: DateTime(2026, 5, 10),
        dataFim: DateTime(2026, 5, 20),
        status: StatusExecucao.emAndamento,
        dataAtual: DateTime(2026, 5, 21),
        enderecoCidade: 'Campinas',
        enderecoEstado: 'SP',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.obras.single.status, StatusExecucao.atrasada);
      expect(repository.obras.single.progressoPrazoDias, -1);
    });
  });
}

class _FakeObrasRepository implements ObrasRepository {
  final obras = <Obra>[];
  final enderecos = <Endereco>[];

  @override
  Future<void> salvarObra(Obra obra) async {
    obras.add(obra);
  }

  @override
  Future<void> salvarObraComEndereco({
    required Obra obra,
    required Endereco endereco,
  }) async {
    enderecos.add(endereco);
    obras.add(obra);
  }

  @override
  Stream<List<Obra>> watchObras() {
    return Stream.value(obras);
  }
}
