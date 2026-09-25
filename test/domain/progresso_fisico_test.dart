import 'package:flutter_test/flutter_test.dart';
import 'package:belis_oversight/core/domain/domain_enums.dart';
import 'package:belis_oversight/core/domain/progresso_fisico.dart';
import 'package:belis_oversight/features/etapas/domain/etapa.dart';
import 'package:belis_oversight/features/medicoes/domain/medicao.dart';
import 'package:belis_oversight/features/servicos/domain/servico.dart';

void main() {
  group('ProgressoFisico', () {
    test('servico sem medicoes retorna zero', () {
      expect(ProgressoFisico.calcularServicoPorMedicoes([]), 0);
    });

    test('servico usa medicao mais recente', () {
      final progresso = ProgressoFisico.calcularServicoPorMedicoes([
        Medicao(
          id: 'medicao-1',
          servicoId: 'servico-1',
          percentualExecutado: 20,
          data: DateTime(2026, 5, 10),
        ),
        Medicao(
          id: 'medicao-2',
          servicoId: 'servico-1',
          percentualExecutado: 65,
          data: DateTime(2026, 5, 12),
        ),
      ]);

      expect(progresso, 65);
    });

    test('etapa usa media do progresso dos servicos', () {
      final progresso = ProgressoFisico.calcularEtapaPorServicos([
        _servico('servico-1', progressoFisico: 50),
        _servico('servico-2', progressoFisico: 100),
      ]);

      expect(progresso, 75);
    });

    test('obra usa media do progresso das etapas', () {
      final progresso = ProgressoFisico.calcularObraPorEtapas([
        _etapa('etapa-1', progressoFisico: 25),
        _etapa('etapa-2', progressoFisico: 75),
      ]);

      expect(progresso, 50);
    });
  });
}

Servico _servico(String id, {required double progressoFisico}) {
  return Servico(
    id: id,
    etapaId: 'etapa-1',
    nome: id,
    precoTotal: 0,
    unidade: 'un',
    quantidade: 0,
    dataInicio: DateTime(2026, 5, 10),
    dataFim: DateTime(2026, 5, 20),
    status: StatusExecucao.emAndamento,
    progressoFisico: progressoFisico,
    progressoPrazoDias: 10,
  );
}

Etapa _etapa(String id, {required double progressoFisico}) {
  return Etapa(
    id: id,
    obraId: 'obra-1',
    nome: id,
    dataInicio: DateTime(2026, 5, 10),
    dataFim: DateTime(2026, 5, 20),
    status: StatusExecucao.emAndamento,
    progressoFisico: progressoFisico,
    progressoPrazoDias: 10,
  );
}
