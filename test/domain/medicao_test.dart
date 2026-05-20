import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/features/medicoes/domain/medicao.dart';

void main() {
  group('Medicao', () {
    test('aceita percentual entre 0 e 100', () {
      final medicao = Medicao(
        id: 'medicao-1',
        servicoId: 'servico-1',
        percentualExecutado: 60,
        data: DateTime(2026, 5, 20),
      );

      expect(medicao.percentualExecutado, 60);
    });
  });
}
