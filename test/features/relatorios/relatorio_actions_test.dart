import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/features/relatorios/domain/relatorio.dart';
import 'package:operational_tracking/features/relatorios/presentation/relatorio_actions.dart';

void main() {
  group('Story 8.3 - RelatorioActionsCard', () {
    testWidgets('exibe acoes de visualizar e compartilhar', (tester) async {
      final relatorio = Relatorio(
        id: 'relatorio-1',
        obraId: 'obra-1',
        fiscalizacaoId: 'vistoria-1',
        criadoEm: DateTime(2026, 6, 15),
        caminhoArquivo: '/tmp/relatorio-1.pdf',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RelatorioActionsCard(relatorio: relatorio),
          ),
        ),
      );

      expect(find.text('PDF gerado'), findsOneWidget);
      expect(find.text('/tmp/relatorio-1.pdf'), findsOneWidget);
      expect(find.text('Visualizar'), findsOneWidget);
      expect(find.text('Compartilhar'), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });
  });
}
