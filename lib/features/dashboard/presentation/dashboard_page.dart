import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/dashboard_resumo.dart';
import 'dashboard_controller.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumo = ref.watch(dashboardResumoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Operational Tracking')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          resumo.when(
            data: (value) => _DashboardResumoSection(resumo: value),
            loading: () => const LinearProgressIndicator(),
            error: (error, stackTrace) => Text(
              'Erro ao carregar dashboard: $error',
            ),
          ),
          const SizedBox(height: 16),
          _DashboardAction(
            title: 'Obras',
            subtitle: 'Acompanhar obras, etapas e servicos',
            onTap: () => context.push('/obras'),
          ),
          _DashboardAction(
            title: 'Empresas',
            subtitle: 'Empresas contratadas e mao de obra',
            onTap: () => context.push('/empresas'),
          ),
          _DashboardAction(
            title: 'Contratantes',
            subtitle: 'Clientes, responsaveis e contatos',
            onTap: () => context.push('/contratantes'),
          ),
        ],
      ),
    );
  }
}

class _DashboardResumoSection extends StatelessWidget {
  const _DashboardResumoSection({required this.resumo});

  final DashboardResumo resumo;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 720;
        final columns = wide ? 3 : 2;

        return GridView.count(
          crossAxisCount: columns,
          childAspectRatio: wide ? 2.25 : 1.45,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _ResumoTile(
              label: 'Obras',
              value: resumo.totalObras.toString(),
              icon: Icons.apartment,
            ),
            _ResumoTile(
              label: 'Servicos',
              value: resumo.totalServicos.toString(),
              icon: Icons.engineering,
            ),
            _ResumoTile(
              label: 'Fiscalizacoes',
              value: resumo.totalFiscalizacoes.toString(),
              icon: Icons.assignment_turned_in,
            ),
            _ResumoTile(
              label: 'Medicoes',
              value: resumo.totalMedicoes.toString(),
              icon: Icons.add_chart,
            ),
            _ResumoTile(
              label: 'Fotos',
              value: resumo.totalFotos.toString(),
              icon: Icons.photo_library,
            ),
            _ResumoTile(
              label: 'Progresso obras',
              value: '${resumo.progressoMedioObras}%',
              icon: Icons.trending_up,
            ),
            _ResumoTile(
              label: 'Obras atrasadas',
              value: resumo.obrasAtrasadas.toString(),
              icon: Icons.warning_amber,
            ),
          ],
        );
      },
    );
  }
}

class _ResumoTile extends StatelessWidget {
  const _ResumoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardAction extends StatelessWidget {
  const _DashboardAction({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
