import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/fiscalizacoes/data/vistorias_servico_repository.dart';
import 'package:operational_tracking/features/fiscalizacoes/domain/vistoria_servico.dart';
import 'package:operational_tracking/features/fiscalizacoes/presentation/fiscalizacoes_controller.dart';

void main() {
  group('Story 4.1 - FiscalizacoesController', () {
    test('rejeita fiscalizacao sem servico', () async {
      final repository = _FakeVistoriasServicoRepository();
      final controller = FiscalizacoesController(repository);

      await controller.salvar(
        servicoId: ' ',
        obraId: 'obra-1',
        contratanteId: 'contratante-1',
        responsavelId: 'responsavel-1',
        data: DateTime(2026, 5, 20),
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.vistorias, isEmpty);
    });

    test('rejeita fiscalizacao sem contexto do servico', () async {
      final repository = _FakeVistoriasServicoRepository()
        ..contextoPorServico.clear();
      final controller = FiscalizacoesController(repository);

      await controller.salvar(
        servicoId: 'servico-1',
        data: DateTime(2026, 5, 20),
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.vistorias, isEmpty);
    });

    test('cria vistoria com status inicial em andamento', () async {
      final repository = _FakeVistoriasServicoRepository();
      final controller = FiscalizacoesController(repository);

      await controller.salvar(
        servicoId: ' servico-1 ',
        obraId: ' obra-1 ',
        contratanteId: ' contratante-1 ',
        responsavelId: ' responsavel-1 ',
        numero: ' 001 ',
        data: DateTime(2026, 5, 20, 14),
        ocorrencia: ' Sem ocorrencias ',
        comentario: ' Dia produtivo ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.vistorias, hasLength(1));

      final vistoria = repository.vistorias.single;
      expect(vistoria.servicoId, 'servico-1');
      expect(vistoria.obraId, 'obra-1');
      expect(vistoria.contratanteId, 'contratante-1');
      expect(vistoria.responsavelId, 'responsavel-1');
      expect(vistoria.numero, '001');
      expect(vistoria.data, DateTime(2026, 5, 20));
      expect(vistoria.diaSemana, DateTime.wednesday);
      expect(vistoria.status, StatusFiscalizacao.emAndamento);
      expect(vistoria.ocorrencia, 'Sem ocorrencias');
      expect(vistoria.comentario, 'Dia produtivo');
    });

    test('deriva vinculos pelo servico quando nao foram informados', () async {
      final repository = _FakeVistoriasServicoRepository();
      final controller = FiscalizacoesController(repository);

      await controller.salvar(
        servicoId: 'servico-1',
        data: DateTime(2026, 5, 20),
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.vistorias.single.obraId, 'obra-1');
      expect(repository.vistorias.single.contratanteId, 'contratante-1');
      expect(repository.vistorias.single.responsavelId, 'responsavel-1');
    });

    test('gera numero quando campo fica vazio', () async {
      final repository = _FakeVistoriasServicoRepository();
      final controller = FiscalizacoesController(repository);

      await controller.salvar(
        servicoId: 'servico-1',
        obraId: 'obra-1',
        contratanteId: 'contratante-1',
        responsavelId: 'responsavel-1',
        numero: ' ',
        data: DateTime(2026, 5, 20),
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.vistorias.single.numero, startsWith('VS-20260520-'));
    });

    test('edita vistoria existente preservando id e status informado',
        () async {
      final repository = _FakeVistoriasServicoRepository();
      final controller = FiscalizacoesController(repository);

      await controller.salvar(
        id: 'vistoria-1',
        servicoId: 'servico-1',
        obraId: 'obra-1',
        contratanteId: 'contratante-1',
        responsavelId: 'responsavel-1',
        numero: '001',
        data: DateTime(2026, 5, 20),
      );
      await controller.salvar(
        id: 'vistoria-1',
        servicoId: 'servico-1',
        obraId: 'obra-1',
        contratanteId: 'contratante-1',
        responsavelId: 'responsavel-1',
        numero: '001',
        data: DateTime(2026, 5, 20),
        status: StatusFiscalizacao.aprovada,
        comentario: 'Revisado',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.vistorias, hasLength(1));
      expect(repository.vistorias.single.id, 'vistoria-1');
      expect(repository.vistorias.single.status, StatusFiscalizacao.aprovada);
      expect(repository.vistorias.single.comentario, 'Revisado');
    });

    test('salva textos da vistoria existente sem exigir botao salvar',
        () async {
      final repository = _FakeVistoriasServicoRepository();
      final controller = FiscalizacoesController(repository);

      await controller.salvar(
        id: 'vistoria-1',
        servicoId: 'servico-1',
        obraId: 'obra-1',
        contratanteId: 'contratante-1',
        responsavelId: 'responsavel-1',
        numero: '001',
        data: DateTime(2026, 5, 20),
      );

      await controller.salvarTextos(
        id: ' vistoria-1 ',
        ocorrencia: ' Sem acesso ao pavimento ',
        comentario: ' Equipe reprogramou a atividade ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.vistorias.single.ocorrencia, 'Sem acesso ao pavimento');
      expect(
        repository.vistorias.single.comentario,
        'Equipe reprogramou a atividade',
      );
    });
  });
}

class _FakeVistoriasServicoRepository implements VistoriasServicoRepository {
  final vistorias = <VistoriaServico>[];
  final contextoPorServico = <String, ContextoFiscalizacaoServico>{
    'servico-1': const ContextoFiscalizacaoServico(
      obraId: 'obra-1',
      contratanteId: 'contratante-1',
      responsavelId: 'responsavel-1',
    ),
  };

  @override
  Future<String?> buscarObraIdDoServico(String servicoId) async {
    return contextoPorServico[servicoId]?.obraId;
  }

  @override
  Future<ContextoFiscalizacaoServico?> buscarContextoDoServico(
    String servicoId,
  ) async {
    return contextoPorServico[servicoId];
  }

  @override
  Future<void> salvarVistoria(VistoriaServico vistoria) async {
    final index = vistorias.indexWhere((item) => item.id == vistoria.id);
    if (index == -1) {
      vistorias.add(vistoria);
      return;
    }

    vistorias[index] = vistoria;
  }

  @override
  Future<void> atualizarTextosDaVistoria({
    required String id,
    String? ocorrencia,
    String? comentario,
  }) async {
    final index = vistorias.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }

    final vistoria = vistorias[index];
    vistorias[index] = VistoriaServico(
      id: vistoria.id,
      servicoId: vistoria.servicoId,
      obraId: vistoria.obraId,
      contratanteId: vistoria.contratanteId,
      responsavelId: vistoria.responsavelId,
      numero: vistoria.numero,
      data: vistoria.data,
      diaSemana: vistoria.diaSemana,
      status: vistoria.status,
      ocorrencia: ocorrencia?.trim(),
      comentario: comentario?.trim(),
    );
  }

  @override
  Stream<List<VistoriaServico>> watchVistoriasDoServico(String servicoId) {
    return watchFiscalizacoes(servicoId: servicoId);
  }

  @override
  Stream<List<VistoriaServico>> watchFiscalizacoes({
    String? servicoId,
    String? numero,
    StatusFiscalizacao? status,
    DateTime? data,
  }) {
    return Stream.value(
      vistorias.where((vistoria) {
        final combinaServico =
            servicoId == null || vistoria.servicoId == servicoId;
        final combinaNumero = numero == null ||
            numero.trim().isEmpty ||
            vistoria.numero.contains(numero.trim());
        final combinaStatus = status == null || vistoria.status == status;
        final combinaData = data == null ||
            DateTime(vistoria.data.year, vistoria.data.month, vistoria.data.day)
                .isAtSameMomentAs(DateTime(data.year, data.month, data.day));

        return combinaServico && combinaNumero && combinaStatus && combinaData;
      }).toList(),
    );
  }
}
