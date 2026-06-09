import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/fiscalizacoes/data/vistorias_periodo_repository.dart';
import 'package:operational_tracking/features/fiscalizacoes/domain/vistoria_periodo.dart';
import 'package:operational_tracking/features/fiscalizacoes/presentation/fiscalizacoes_controller.dart';

void main() {
  group('Story 4.3 - PeriodosFiscalizacaoController', () {
    test('rejeita periodo sem fiscalizacao', () async {
      final repository = _FakeVistoriasPeriodoRepository();
      final controller = PeriodosFiscalizacaoController(repository);

      await controller.salvar(
        vistoriaServicoId: ' ',
        periodo: PeriodoDia.manha,
        tempo: TempoPeriodo.claro,
        condicao: CondicaoPeriodo.praticavel,
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.periodos, isEmpty);
    });

    test('salva periodo com tempo e condicao', () async {
      final repository = _FakeVistoriasPeriodoRepository();
      final controller = PeriodosFiscalizacaoController(repository);

      await controller.salvar(
        vistoriaServicoId: ' vistoria-1 ',
        periodo: PeriodoDia.tarde,
        tempo: TempoPeriodo.nublado,
        condicao: CondicaoPeriodo.impraticavel,
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.periodos, hasLength(1));
      expect(repository.periodos.single.vistoriaServicoId, 'vistoria-1');
      expect(repository.periodos.single.periodo, PeriodoDia.tarde);
      expect(repository.periodos.single.tempo, TempoPeriodo.nublado);
      expect(repository.periodos.single.condicao, CondicaoPeriodo.impraticavel);
    });

    test('edita periodo existente', () async {
      final repository = _FakeVistoriasPeriodoRepository();
      final controller = PeriodosFiscalizacaoController(repository);

      await controller.salvar(
        id: 'periodo-1',
        vistoriaServicoId: 'vistoria-1',
        periodo: PeriodoDia.manha,
        tempo: TempoPeriodo.claro,
        condicao: CondicaoPeriodo.praticavel,
      );
      await controller.salvar(
        id: 'periodo-1',
        vistoriaServicoId: 'vistoria-1',
        periodo: PeriodoDia.manha,
        tempo: TempoPeriodo.chuvoso,
        condicao: CondicaoPeriodo.impraticavel,
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.periodos, hasLength(1));
      expect(repository.periodos.single.tempo, TempoPeriodo.chuvoso);
      expect(repository.periodos.single.condicao, CondicaoPeriodo.impraticavel);
    });

    test('remove periodo selecionado', () async {
      final repository = _FakeVistoriasPeriodoRepository();
      final controller = PeriodosFiscalizacaoController(repository);

      await controller.salvar(
        vistoriaServicoId: 'vistoria-1',
        periodo: PeriodoDia.noite,
        tempo: TempoPeriodo.claro,
        condicao: CondicaoPeriodo.praticavel,
      );
      await controller.remover(
        vistoriaServicoId: 'vistoria-1',
        periodo: PeriodoDia.noite,
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.periodos, isEmpty);
    });
  });
}

class _FakeVistoriasPeriodoRepository implements VistoriasPeriodoRepository {
  final periodos = <VistoriaPeriodo>[];

  @override
  Future<void> salvarPeriodo(VistoriaPeriodo periodo) async {
    final index = periodos.indexWhere((item) => item.id == periodo.id);
    if (index == -1) {
      periodos.add(periodo);
      return;
    }

    periodos[index] = periodo;
  }

  @override
  Future<void> removerPeriodo({
    required String vistoriaServicoId,
    required PeriodoDia periodo,
  }) async {
    periodos.removeWhere((item) {
      return item.vistoriaServicoId == vistoriaServicoId &&
          item.periodo == periodo;
    });
  }

  @override
  Stream<List<VistoriaPeriodo>> watchPeriodosDaVistoria(
    String vistoriaServicoId,
  ) {
    return Stream.value(
      periodos
          .where((periodo) => periodo.vistoriaServicoId == vistoriaServicoId)
          .toList(),
    );
  }
}
