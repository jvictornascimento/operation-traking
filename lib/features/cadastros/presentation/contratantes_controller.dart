import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/contratantes_repository.dart';
import '../domain/contratante.dart';

final contratantesRepositoryProvider = Provider<ContratantesRepository>((ref) {
  return DriftContratantesRepository(ref.watch(appDatabaseProvider));
});

final contratantesStreamProvider = StreamProvider<List<Contratante>>((ref) {
  return ref.watch(contratantesRepositoryProvider).watchContratantes();
});

final contratantesControllerProvider =
    StateNotifierProvider<ContratantesController, AsyncValue<void>>((ref) {
  return ContratantesController(ref.watch(contratantesRepositoryProvider));
});

class ContratantesController extends StateNotifier<AsyncValue<void>> {
  ContratantesController(this._repository) : super(const AsyncData(null));

  final ContratantesRepository _repository;

  Future<void> salvar({
    String? id,
    required String nome,
    String? cnpj,
    String? ie,
  }) async {
    final nomeNormalizado = nome.trim();

    if (nomeNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Nome do contratante e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _repository.salvarContratante(
        Contratante(
          id: id ?? _novoId(),
          nome: nomeNormalizado,
          cnpj: _normalizarTextoOpcional(cnpj),
          ie: _normalizarTextoOpcional(ie),
        ),
      );
    });
  }

  String _novoId() {
    return 'contratante-${DateTime.now().microsecondsSinceEpoch}';
  }

  String? _normalizarTextoOpcional(String? value) {
    final texto = value?.trim();
    if (texto == null || texto.isEmpty) {
      return null;
    }
    return texto;
  }
}
