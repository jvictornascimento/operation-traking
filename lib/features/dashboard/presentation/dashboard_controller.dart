import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/dashboard_repository.dart';
import '../domain/dashboard_resumo.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DriftDashboardRepository(ref.watch(appDatabaseProvider));
});

final dashboardResumoProvider = StreamProvider.autoDispose<DashboardResumo>(
  (ref) {
    return ref.watch(dashboardRepositoryProvider).watchResumo();
  },
);
