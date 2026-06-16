import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/obra_detalhe_repository.dart';
import '../domain/obra_detalhe.dart';

final obraDetalheRepositoryProvider = Provider<ObraDetalheRepository>((ref) {
  return DriftObraDetalheRepository(ref.watch(appDatabaseProvider));
});

final obraDetalheStreamProvider =
    StreamProvider.family.autoDispose<ObraDetalhe?, String>((ref, obraId) {
  return ref.watch(obraDetalheRepositoryProvider).watchDetalheDaObra(obraId);
});
