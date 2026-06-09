import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Operational Tracking')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
          _DashboardAction(
            title: 'Etapas',
            subtitle: 'Organizacao das fases da obra',
            onTap: () => context.push('/etapas'),
          ),
          _DashboardAction(
            title: 'Servicos',
            subtitle: 'Quantidade, unidade, valor e progresso',
            onTap: () => context.push('/servicos'),
          ),
          _DashboardAction(
            title: 'Fiscalizacoes',
            subtitle: 'Vistorias diarias por servico',
            onTap: () => context.push('/fiscalizacoes'),
          ),
          _DashboardAction(
            title: 'Relatorios',
            subtitle: 'PDFs locais para compartilhar',
            onTap: () => context.push('/relatorios'),
          ),
        ],
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
