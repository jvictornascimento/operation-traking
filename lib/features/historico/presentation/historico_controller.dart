import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/historicos_repository.dart';
import '../domain/historico_alteracao.dart';

final historicosRepositoryProvider = Provider<HistoricosRepository>((ref) {
  return DriftHistoricosRepository(ref.watch(appDatabaseProvider));
});

final historicosEntidadeStreamProvider = StreamProvider.family
    .autoDispose<List<HistoricoAlteracao>, HistoricoEntidadeFiltro>(
  (ref, filtro) {
    return ref.watch(historicosRepositoryProvider).watchHistoricosDaEntidade(
          entidade: filtro.entidade,
          entidadeId: filtro.entidadeId,
        );
  },
);

class HistoricoEntidadeFiltro {
  const HistoricoEntidadeFiltro({
    required this.entidade,
    required this.entidadeId,
  });

  final String entidade;
  final String entidadeId;

  @override
  bool operator ==(Object other) {
    return other is HistoricoEntidadeFiltro &&
        other.entidade == entidade &&
        other.entidadeId == entidadeId;
  }

  @override
  int get hashCode => Object.hash(entidade, entidadeId);
}
