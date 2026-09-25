import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:belis_oversight/features/historico/domain/historico_alteracao.dart';
import 'package:belis_oversight/features/historico/presentation/historico_controller.dart';
import 'package:belis_oversight/features/historico/presentation/historico_page.dart';

void main() {
  group('Story 9.2 - HistoricoPage', () {
    testWidgets('exibe historico da entidade', (tester) async {
      const filtro = HistoricoEntidadeFiltro(
        entidade: 'medicao',
        entidadeId: 'medicao-1',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            historicosEntidadeStreamProvider(filtro).overrideWith(
              (ref) => Stream.value([
                HistoricoAlteracao(
                  id: 'historico-1',
                  entidade: 'medicao',
                  entidadeId: 'medicao-1',
                  campo: 'percentualExecutado',
                  valorAnterior: '25.00',
                  valorNovo: '60.50',
                  data: DateTime(2026, 6, 15, 9, 30),
                  usuario: 'local',
                ),
              ]),
            ),
          ],
          child: const MaterialApp(
            home: HistoricoPage(
              entidade: 'medicao',
              entidadeId: 'medicao-1',
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Historico'), findsOneWidget);
      expect(find.text('Percentual executado'), findsOneWidget);
      expect(find.text('25.00'), findsOneWidget);
      expect(find.text('60.50'), findsOneWidget);
      expect(find.text('Usuario: local'), findsOneWidget);
    });

    testWidgets('exibe estado vazio', (tester) async {
      const filtro = HistoricoEntidadeFiltro(
        entidade: 'servico',
        entidadeId: 'servico-1',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            historicosEntidadeStreamProvider(filtro).overrideWith(
              (ref) => Stream.value(const []),
            ),
          ],
          child: const MaterialApp(
            home: HistoricoPage(
              entidade: 'servico',
              entidadeId: 'servico-1',
            ),
          ),
        ),
      );

      await tester.pump();

      expect(
        find.text('Nenhuma alteracao registrada para servico servico-1.'),
        findsOneWidget,
      );
    });
  });
}
