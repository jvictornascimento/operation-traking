import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_loading.dart';
import 'relatorio_actions.dart';
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

              return RelatorioActionsCard(relatorio: relatorio);
            },
            loading: () => const AppInlineLoading(),
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
