import 'package:flutter_test/flutter_test.dart';
import 'package:belis_oversight/core/domain/domain_enums.dart';
import 'package:belis_oversight/core/domain/prazo.dart';

void main() {
  group('Prazo', () {
    test('retorna dias restantes quando data atual esta antes do fim', () {
      final dias = Prazo.calcularDias(
        dataFim: DateTime(2026, 5, 20),
        dataAtual: DateTime(2026, 5, 18),
      );

      expect(dias, 2);
    });

    test('retorna zero quando vence hoje', () {
      final dias = Prazo.calcularDias(
        dataFim: DateTime(2026, 5, 20),
        dataAtual: DateTime(2026, 5, 20),
      );

      expect(dias, 0);
    });

    test('retorna valor negativo quando esta atrasado', () {
      final dias = Prazo.calcularDias(
        dataFim: DateTime(2026, 5, 20),
        dataAtual: DateTime(2026, 5, 21),
      );

      expect(dias, -1);
    });

    test('aplica status atrasada quando prazo esta negativo', () {
      final status = Prazo.aplicarStatusAtrasado(
        statusAtual: StatusExecucao.emAndamento,
        progressoPrazoDias: -1,
      );

      expect(status, StatusExecucao.atrasada);
    });

    test('mantem concluida mesmo com prazo negativo', () {
      final status = Prazo.aplicarStatusAtrasado(
        statusAtual: StatusExecucao.concluida,
        progressoPrazoDias: -1,
      );

      expect(status, StatusExecucao.concluida);
    });
  });
}
