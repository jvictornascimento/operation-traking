import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/empresas_repository.dart';
import '../domain/empresa.dart';

final empresasRepositoryProvider = Provider<EmpresasRepository>((ref) {
  return DriftEmpresasRepository(ref.watch(appDatabaseProvider));
});

final empresasStreamProvider = StreamProvider<List<Empresa>>((ref) {
  return ref.watch(empresasRepositoryProvider).watchEmpresas();
});

final empresasControllerProvider =
    StateNotifierProvider<EmpresasController, AsyncValue<void>>((ref) {
  return EmpresasController(ref.watch(empresasRepositoryProvider));
});

class EmpresasController extends StateNotifier<AsyncValue<void>> {
  EmpresasController(this._repository) : super(const AsyncData(null));

  final EmpresasRepository _repository;

  Future<void> salvar({
    String? id,
    required String nome,
    String? cnpj,
    String? ie,
  }) async {
    final nomeNormalizado = nome.trim();

    if (nomeNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Nome da empresa e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _repository.salvarEmpresa(
        Empresa(
          id: id ?? _novoId(),
          nome: nomeNormalizado,
          cnpj: _normalizarTextoOpcional(cnpj),
          ie: _normalizarTextoOpcional(ie),
        ),
      );
    });
  }

  String _novoId() {
    return 'empresa-${DateTime.now().microsecondsSinceEpoch}';
  }

  String? _normalizarTextoOpcional(String? value) {
    final texto = value?.trim();
    if (texto == null || texto.isEmpty) {
      return null;
    }
    return texto;
  }
}
