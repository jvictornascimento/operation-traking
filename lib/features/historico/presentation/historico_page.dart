import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_back_button.dart';
import '../domain/historico_alteracao.dart';
import 'historico_controller.dart';

class HistoricoPage extends ConsumerWidget {
  const HistoricoPage({
    super.key,
    required this.entidade,
    required this.entidadeId,
  });

  final String entidade;
  final String entidadeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historicos = ref.watch(
      historicosEntidadeStreamProvider(
        HistoricoEntidadeFiltro(
          entidade: entidade,
          entidadeId: entidadeId,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Historico'),
      ),
      body: historicos.when(
        data: (items) => _HistoricoContent(
          entidade: entidade,
          entidadeId: entidadeId,
          historicos: items,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Erro ao carregar historico: $error'),
        ),
      ),
    );
  }
}

class _HistoricoContent extends StatelessWidget {
  const _HistoricoContent({
    required this.entidade,
    required this.entidadeId,
    required this.historicos,
  });

  final String entidade;
  final String entidadeId;
  final List<HistoricoAlteracao> historicos;

  @override
  Widget build(BuildContext context) {
    if (historicos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Nenhuma alteracao registrada para $_tituloEntidade.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return _HistoricoTile(historico: historicos[index]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: historicos.length,
    );
  }

  String get _tituloEntidade {
    return '$entidade $entidadeId';
  }
}

class _HistoricoTile extends StatelessWidget {
  const _HistoricoTile({required this.historico});

  final HistoricoAlteracao historico;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _campoLabel(historico.campo),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Text(
                  _formatarDataHora(historico.data),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _ValorLinha(
              label: 'Anterior',
              value: historico.valorAnterior,
            ),
            const SizedBox(height: 6),
            _ValorLinha(
              label: 'Novo',
              value: historico.valorNovo,
            ),
            if (historico.usuario != null) ...[
              const SizedBox(height: 8),
              Text(
                'Usuario: ${historico.usuario}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _campoLabel(String campo) {
    return switch (campo) {
      'percentualExecutado' => 'Percentual executado',
      'progressoFisico' => 'Progresso fisico',
      'ocorrencia' => 'Ocorrencia',
      'comentario' => 'Comentario',
      'status' => 'Status',
      _ => campo,
    };
  }

  String _formatarDataHora(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString().padLeft(4, '0');
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return '$dia/$mes/$ano $hora:$minuto';
  }
}

class _ValorLinha extends StatelessWidget {
  const _ValorLinha({
    required this.label,
    required this.value,
  });

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(value == null || value!.isEmpty ? '-' : value!),
        ),
      ],
    );
  }
}
