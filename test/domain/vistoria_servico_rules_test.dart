import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/core/domain/domain_enums.dart';
import 'package:operational_tracking/features/fiscalizacoes/domain/vistoria_servico.dart';
import 'package:operational_tracking/features/fiscalizacoes/domain/vistoria_servico_rules.dart';

void main() {
  group('VistoriaServicoRules', () {
    test('identifica vistoria duplicada para mesmo servico e dia', () {
      final vistorias = [
        VistoriaServico(
          id: 'vistoria-1',
          servicoId: 'servico-1',
          obraId: 'obra-1',
          contratanteId: 'contratante-1',
          responsavelId: 'funcionario-1',
          numero: '001',
          data: DateTime(2026, 5, 20, 10),
          diaSemana: DateTime.wednesday,
          status: StatusFiscalizacao.emAndamento,
        ),
      ];

      final existe = VistoriaServicoRules.existeVistoriaNoMesmoDia(
        vistorias: vistorias,
        servicoId: 'servico-1',
        data: DateTime(2026, 5, 20, 18),
      );

      expect(existe, isTrue);
    });

    test('permite vistoria para o mesmo servico em outro dia', () {
      final vistorias = [
        VistoriaServico(
          id: 'vistoria-1',
          servicoId: 'servico-1',
          obraId: 'obra-1',
          contratanteId: 'contratante-1',
          responsavelId: 'funcionario-1',
          numero: '001',
          data: DateTime(2026, 5, 20),
          diaSemana: DateTime.wednesday,
        ),
      ];

      final existe = VistoriaServicoRules.existeVistoriaNoMesmoDia(
        vistorias: vistorias,
        servicoId: 'servico-1',
        data: DateTime(2026, 5, 21),
      );

      expect(existe, isFalse);
    });

    test('lanca erro para nova vistoria duplicada', () {
      final vistorias = [
        VistoriaServico(
          id: 'vistoria-1',
          servicoId: 'servico-1',
          obraId: 'obra-1',
          contratanteId: 'contratante-1',
          responsavelId: 'funcionario-1',
          numero: '001',
          data: DateTime(2026, 5, 20),
          diaSemana: DateTime.wednesday,
        ),
      ];

      expect(
        () => VistoriaServicoRules.validarNovaVistoria(
          vistorias: vistorias,
          servicoId: 'servico-1',
          data: DateTime(2026, 5, 20),
        ),
        throwsStateError,
      );
    });
  });
}
