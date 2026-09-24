import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';

import '../domain/relatorio.dart';

class RelatorioActionsCard extends StatelessWidget {
  const RelatorioActionsCard({super.key, required this.relatorio});

  final Relatorio relatorio;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PDF gerado',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(relatorio.caminhoArquivo),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _visualizar,
                    icon: const Icon(Icons.visibility),
                    label: const Text('Visualizar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _compartilhar,
                    icon: const Icon(Icons.share),
                    label: const Text('Compartilhar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _visualizar() {
    return Printing.layoutPdf(
      onLayout: (_) => File(relatorio.caminhoArquivo).readAsBytes(),
    );
  }

  Future<void> _compartilhar() async {
    final bytes = await File(relatorio.caminhoArquivo).readAsBytes();
    await Printing.sharePdf(
      bytes: bytes,
      filename: relatorio.nomeArquivoCompartilhamento ??
          p.basename(relatorio.caminhoArquivo),
    );
  }
}
