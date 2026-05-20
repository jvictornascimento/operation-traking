import 'package:go_router/go_router.dart';

import '../../features/cadastros/presentation/contratantes_page.dart';
import '../../features/cadastros/presentation/empresas_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/fiscalizacoes/presentation/fiscalizacoes_page.dart';
import '../../features/obras/presentation/obras_page.dart';
import '../../features/relatorios/presentation/relatorios_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'dashboard',
      path: '/',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      name: 'obras',
      path: '/obras',
      builder: (context, state) => const ObrasPage(),
    ),
    GoRoute(
      name: 'empresas',
      path: '/empresas',
      builder: (context, state) => const EmpresasPage(),
    ),
    GoRoute(
      name: 'contratantes',
      path: '/contratantes',
      builder: (context, state) => const ContratantesPage(),
    ),
    GoRoute(
      name: 'fiscalizacoes',
      path: '/fiscalizacoes',
      builder: (context, state) => const FiscalizacoesPage(),
    ),
    GoRoute(
      name: 'relatorios',
      path: '/relatorios',
      builder: (context, state) => const RelatoriosPage(),
    ),
  ],
);
