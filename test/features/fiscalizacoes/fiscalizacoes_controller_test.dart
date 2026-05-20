import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/fiscalizacoes/data/vistorias_servico_repository.dart';
import 'package:operational_tracking/features/fiscalizacoes/domain/vistoria_servico.dart';
import 'package:operational_tracking/features/fiscalizacoes/presentation/fiscalizacoes_controller.dart';

void main() {
  group('FiscalizacoesController', () {
    test('rejeita campos relacionais vazios', () async {
      final repository = _FakeVistoriasServicoRepository();
      final controller = FiscalizacoesController(repository);

      await controller.salvar(
        servicoId: '',
        obraId: 'obra-1',
        contratanteId: 'contratante-1',
        responsavelId: 'funcionario-1',
        numero: '001',
        data: DateTime(2026, 5, 20),
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.vistorias, isEmpty);
    });

    test('salva fiscalizacao em andamento', () async {
      final repository = _FakeVistoriasServicoRepository();
      final controller = FiscalizacoesController(repository);

      await controller.salvar(
        servicoId: ' servico-1 ',
        obraId: ' obra-1 ',
        contratanteId: ' contratante-1 ',
        responsavelId: ' funcionario-1 ',
        numero: ' 001 ',
        data: DateTime(2026, 5, 20),
        ocorrencia: ' Sem ocorrencias ',
        comentario: ' Tudo ok ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.vistorias, hasLength(1));
      expect(repository.vistorias.single.servicoId, 'servico-1');
      expect(repository.vistorias.single.status, StatusFiscalizacao.emAndamento);
      expect(repository.vistorias.single.diaSemana, DateTime.wednesday);
      expect(repository.vistorias.single.ocorrencia, 'Sem ocorrencias');
      expect(repository.vistorias.single.comentario, 'Tudo ok');
    });

    test('rejeita fiscalizacao duplicada para mesmo servico e dia', () async {
      final repository = _FakeVistoriasServicoRepository();
      final controller = FiscalizacoesController(repository);

      await controller.salvar(
        servicoId: 'servico-1',
        obraId: 'obra-1',
        contratanteId: 'contratante-1',
        responsavelId: 'funcionario-1',
        numero: '001',
        data: DateTime(2026, 5, 20),
      );
      await controller.salvar(
        servicoId: 'servico-1',
        obraId: 'obra-1',
        contratanteId: 'contratante-1',
        responsavelId: 'funcionario-1',
        numero: '002',
        data: DateTime(2026, 5, 20, 18),
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.vistorias, hasLength(1));
    });
  });
}

class _FakeVistoriasServicoRepository implements VistoriasServicoRepository {
  final vistorias = <VistoriaServico>[];

  @override
  Future<List<VistoriaServico>> listarVistoriasDoServico(String servicoId) {
    return Future.value(
      vistorias.where((vistoria) => vistoria.servicoId == servicoId).toList(),
    );
  }

  @override
  Future<void> salvarVistoria(VistoriaServico vistoria) async {
    vistorias.add(vistoria);
  }

  @override
  Stream<List<VistoriaServico>> watchVistoriasDoServico(String servicoId) {
    return Stream.value(
      vistorias.where((vistoria) => vistoria.servicoId == servicoId).toList(),
    );
  }
}
