import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';

import '../../../core/widgets/app_back_button.dart';
import '../domain/relatorio.dart';
import 'relatorios_controller.dart';

class RelatoriosPage extends ConsumerStatefulWidget {
  const RelatoriosPage({super.key});

  @override
  ConsumerState<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends ConsumerState<RelatoriosPage> {
  final _fiscalizacaoIdController = TextEditingController();

  @override
  void dispose() {
    _fiscalizacaoIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(relatoriosControllerProvider);

    ref.listen(relatoriosControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Relatorios'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _fiscalizacaoIdController,
            decoration: const InputDecoration(
              labelText: 'ID da fiscalizacao',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: state.isLoading ? null : _gerarRelatorio,
            icon: const Icon(Icons.picture_as_pdf),
            label: Text(
              state.isLoading ? 'Gerando...' : 'Gerar PDF da fiscalizacao',
            ),
          ),
          const SizedBox(height: 16),
          state.when(
            data: (relatorio) {
              if (relatorio == null) {
                return const SizedBox.shrink();
              }

              return _RelatorioGeradoCard(relatorio: relatorio);
            },
            loading: () => const LinearProgressIndicator(),
            error: (error, stackTrace) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Future<void> _gerarRelatorio() {
    return ref
        .read(relatoriosControllerProvider.notifier)
        .gerarRelatorioFiscalizacao(_fiscalizacaoIdController.text);
  }
}

class _RelatorioGeradoCard extends StatelessWidget {
  const _RelatorioGeradoCard({required this.relatorio});

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
      filename: p.basename(relatorio.caminhoArquivo),
    );
  }
}
