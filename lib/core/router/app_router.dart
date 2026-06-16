import 'package:go_router/go_router.dart';

import '../../features/cadastros/presentation/contratantes_page.dart';
import '../../features/cadastros/presentation/empresas_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/etapas/presentation/etapas_page.dart';
import '../../features/fiscalizacoes/presentation/fiscalizacoes_page.dart';
import '../../features/historico/presentation/historico_page.dart';
import '../../features/medicoes/presentation/medicoes_page.dart';
import '../../features/obras/presentation/obra_detalhe_page.dart';
import '../../features/obras/presentation/obras_page.dart';
import '../../features/servicos/presentation/servicos_page.dart';

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
      name: 'obra-detalhe',
      path: '/obras/:obraId',
      builder: (context, state) {
        return ObraDetalhePage(
          obraId: state.pathParameters['obraId'] ?? '',
        );
      },
    ),
    GoRoute(
      name: 'obra-etapas',
      path: '/obras/:obraId/etapas',
      builder: (context, state) {
        return EtapasPage(obraId: state.pathParameters['obraId']);
      },
    ),
    GoRoute(
      name: 'etapa-servicos',
      path: '/obras/:obraId/etapas/:etapaId/servicos',
      builder: (context, state) {
        return ServicosPage(etapaId: state.pathParameters['etapaId']);
      },
    ),
    GoRoute(
      name: 'servico-fiscalizacoes',
      path: '/etapas/:etapaId/servicos/:servicoId/fiscalizacoes',
      builder: (context, state) {
        return FiscalizacoesPage(
          servicoId: state.pathParameters['servicoId'],
        );
      },
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
      name: 'etapas',
      path: '/etapas',
      builder: (context, state) => const EtapasPage(),
    ),
    GoRoute(
      name: 'servicos',
      path: '/servicos',
      builder: (context, state) => const ServicosPage(),
    ),
    GoRoute(
      name: 'fiscalizacoes',
      path: '/fiscalizacoes',
      builder: (context, state) => const FiscalizacoesPage(),
    ),
    GoRoute(
      name: 'medicoes',
      path: '/medicoes',
      builder: (context, state) => const MedicoesPage(),
    ),
    GoRoute(
      name: 'historico-entidade',
      path: '/historico/:entidade/:entidadeId',
      builder: (context, state) {
        return HistoricoPage(
          entidade: Uri.decodeComponent(
            state.pathParameters['entidade'] ?? '',
          ),
          entidadeId: Uri.decodeComponent(
            state.pathParameters['entidadeId'] ?? '',
          ),
        );
      },
    ),
  ],
);
