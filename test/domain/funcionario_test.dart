import 'package:flutter_test/flutter_test.dart';
import 'package:belis_oversight/features/cadastros/domain/funcionario.dart';

void main() {
  group('Funcionario', () {
    test('permite funcionario de empresa', () {
      const funcionario = Funcionario(
        id: 'funcionario-1',
        empresaId: 'empresa-1',
        nome: 'Joao',
        cargo: 'Pedreiro',
        tipo: 'func_empresa',
      );

      expect(funcionario.pertenceAEmpresa, isTrue);
      expect(funcionario.pertenceAContratante, isFalse);
    });

    test('permite funcionario de contratante', () {
      const funcionario = Funcionario(
        id: 'funcionario-1',
        contratanteId: 'contratante-1',
        nome: 'Regis',
        cargo: 'Responsavel',
        tipo: 'func_contratante',
      );

      expect(funcionario.pertenceAEmpresa, isFalse);
      expect(funcionario.pertenceAContratante, isTrue);
    });
  });
}
