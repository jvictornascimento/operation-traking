import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_loading.dart';
import '../../etapas/domain/etapa.dart';
import '../../fiscalizacoes/domain/vistoria_servico.dart';
import '../../servicos/domain/servico.dart';
import '../domain/obra.dart';
import '../domain/obra_detalhe.dart';
import 'obra_detalhe_controller.dart';

class ObraDetalhePage extends ConsumerWidget {
  const ObraDetalhePage({
    super.key,
    required this.obraId,
  });

  final String obraId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detalhe = ref.watch(obraDetalheStreamProvider(obraId));

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Detalhe da obra'),
      ),
      body: detalhe.when(
        data: (value) {
          if (value == null) {
            return const Center(child: Text('Obra nao encontrada'));
          }

          return _ObraDetalheContent(detalhe: value);
        },
        loading: () => const AppLoadingPage(),
        error: (error, stackTrace) => Center(
          child: Text('Erro ao carregar detalhe da obra: $error'),
        ),
      ),
    );
  }
}

class _ObraDetalheContent extends StatelessWidget {
  const _ObraDetalheContent({required this.detalhe});

  final ObraDetalhe detalhe;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ResumoObraCard(obra: detalhe.obra),
        const SizedBox(height: 16),
        _SectionTitle(
          title: 'Etapas e servicos',
          action: TextButton.icon(
            onPressed: () => context.push('/obras/${detalhe.obra.id}/etapas'),
            icon: const Icon(Icons.account_tree_outlined),
            label: const Text('Abrir etapas'),
          ),
        ),
        const SizedBox(height: 8),
        _EtapasServicosList(
          etapas: detalhe.etapas,
          servicosPorEtapa: detalhe.servicosPorEtapa,
        ),
        const SizedBox(height: 16),
        const _SectionTitle(title: 'Fiscalizacoes recentes'),
        const SizedBox(height: 8),
        _FiscalizacoesRecentesList(
          fiscalizacoes: detalhe.fiscalizacoesRecentes,
        ),
      ],
    );
  }
}

class _ResumoObraCard extends StatelessWidget {
  const _ResumoObraCard({required this.obra});

  final Obra obra;

  @override
  Widget build(BuildContext context) {
    final prazoTexto = _prazoTexto(obra.progressoPrazoDias);
    final diasTotais = _diasTotaisContrato();
    final diasDecorridos = _diasDecorridos();
    final diasRestantes = _diasRestantes(diasTotais, diasDecorridos);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              obra.nome,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: Icons.flag_outlined,
                  label: _statusExecucaoLabel(obra.status.name),
                ),
                _InfoChip(
                  icon: Icons.timeline_outlined,
                  label: '${obra.progressoFisico.toStringAsFixed(1)}%',
                ),
                _InfoChip(
                  icon: Icons.event_available_outlined,
                  label: prazoTexto,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: (obra.progressoFisico / 100).clamp(0, 1),
              minHeight: 8,
            ),
            const SizedBox(height: 16),
            if (obra.numeroContrato != null || obra.valorContrato != null) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (obra.numeroContrato != null)
                    _InfoChip(
                      icon: Icons.description_outlined,
                      label: 'Contrato ${obra.numeroContrato}',
                    ),
                  if (obra.valorContrato != null)
                    _InfoChip(
                      icon: Icons.payments_outlined,
                      label: _formatarMoeda(obra.valorContrato!),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Expanded(
                  child: _DateInfo(
                    label: 'Dias totais',
                    value: '$diasTotais',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateInfo(
                    label: 'Decorridos',
                    value: '$diasDecorridos',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateInfo(
                    label: diasRestantes >= 0 ? 'Restantes' : 'Atraso',
                    value: '${diasRestantes.abs()}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DateInfo(
                    label: 'Inicio',
                    value: _formatarData(obra.dataInicio),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateInfo(
                    label: 'Fim',
                    value: _formatarData(obra.dataFim),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _prazoTexto(int prazo) {
    if (prazo > 0) {
      return '$prazo dias restantes';
    }

    if (prazo == 0) {
      return 'vence hoje';
    }

    return '${prazo.abs()} dias atrasada';
  }

  int _diasTotaisContrato() {
    return obra.dataFim.difference(obra.dataInicio).inDays + 1;
  }

  int _diasDecorridos() {
    final hoje = DateTime.now();
    final hojeNormalizado = DateTime(hoje.year, hoje.month, hoje.day);
    final inicio = DateTime(
      obra.dataInicio.year,
      obra.dataInicio.month,
      obra.dataInicio.day,
    );
    final fim =
        DateTime(obra.dataFim.year, obra.dataFim.month, obra.dataFim.day);

    if (hojeNormalizado.isBefore(inicio)) {
      return 0;
    }

    final limite = hojeNormalizado.isAfter(fim) ? fim : hojeNormalizado;
    return limite.difference(inicio).inDays + 1;
  }

  int _diasRestantes(int diasTotais, int diasDecorridos) {
    final hoje = DateTime.now();
    final hojeNormalizado = DateTime(hoje.year, hoje.month, hoje.day);
    final fim =
        DateTime(obra.dataFim.year, obra.dataFim.month, obra.dataFim.day);

    if (hojeNormalizado.isAfter(fim)) {
      return -hojeNormalizado.difference(fim).inDays;
    }

    return diasTotais - diasDecorridos;
  }

  String _formatarMoeda(double value) {
    final texto = value.toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $texto';
  }
}

class _EtapasServicosList extends StatelessWidget {
  const _EtapasServicosList({
    required this.etapas,
    required this.servicosPorEtapa,
  });

  final List<Etapa> etapas;
  final Map<String, List<Servico>> servicosPorEtapa;

  @override
  Widget build(BuildContext context) {
    if (etapas.isEmpty) {
      return const _EmptyState(text: 'Nenhuma etapa cadastrada para esta obra');
    }

    return Column(
      children: [
        for (final etapa in etapas)
          Card(
            child: ExpansionTile(
              title: Text(etapa.nome),
              subtitle: Text(
                '${_statusExecucaoLabel(etapa.status.name)} | '
                '${etapa.progressoFisico.toStringAsFixed(1)}%',
              ),
              children: [
                _ServicosEtapaList(
                  etapa: etapa,
                  servicos: servicosPorEtapa[etapa.id] ?? const [],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ServicosEtapaList extends StatelessWidget {
  const _ServicosEtapaList({
    required this.etapa,
    required this.servicos,
  });

  final Etapa etapa;
  final List<Servico> servicos;

  @override
  Widget build(BuildContext context) {
    if (servicos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Nenhum servico cadastrado nesta etapa'),
        ),
      );
    }

    return Column(
      children: [
        for (final servico in servicos)
          ListTile(
            title: Text(servico.nome),
            subtitle: Text(
              '${_statusExecucaoLabel(servico.status.name)} | '
              '${servico.progressoFisico.toStringAsFixed(1)}% | '
              '${servico.quantidade.toStringAsFixed(2)} ${servico.unidade}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push(
                '/etapas/${etapa.id}/servicos/${servico.id}/fiscalizacoes',
              );
            },
          ),
      ],
    );
  }
}

class _FiscalizacoesRecentesList extends StatelessWidget {
  const _FiscalizacoesRecentesList({required this.fiscalizacoes});

  final List<VistoriaServico> fiscalizacoes;

  @override
  Widget build(BuildContext context) {
    if (fiscalizacoes.isEmpty) {
      return const _EmptyState(text: 'Nenhuma fiscalizacao registrada');
    }

    return Card(
      child: Column(
        children: [
          for (final fiscalizacao in fiscalizacoes)
            ListTile(
              title: Text(fiscalizacao.numero),
              subtitle: Text(
                '${_formatarData(fiscalizacao.data)} | '
                '${_statusFiscalizacaoLabel(fiscalizacao.status.name)}',
              ),
              trailing: const Icon(Icons.assignment_outlined),
            ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    this.action,
  });

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _DateInfo extends StatelessWidget {
  const _DateInfo({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(child: Text(text)),
      ),
    );
  }
}

String _formatarData(DateTime data) {
  return '${data.day.toString().padLeft(2, '0')}/'
      '${data.month.toString().padLeft(2, '0')}/'
      '${data.year.toString().padLeft(4, '0')}';
}

String _statusExecucaoLabel(String value) {
  return switch (value) {
    'naoComecou' => 'Nao comecou',
    'emAndamento' => 'Em andamento',
    'parada' => 'Parada',
    'embargada' => 'Embargada',
    'atrasada' => 'Atrasada',
    'concluida' => 'Concluida',
    _ => value,
  };
}

String _statusFiscalizacaoLabel(String value) {
  return switch (value) {
    'emAndamento' => 'Em andamento',
    'aprovada' => 'Aprovada',
    'negada' => 'Negada',
    _ => value,
  };
}
