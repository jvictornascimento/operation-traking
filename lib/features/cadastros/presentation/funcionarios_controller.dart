import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/funcionarios_repository.dart';
import '../domain/funcionario.dart';

final funcionariosRepositoryProvider = Provider<FuncionariosRepository>((ref) {
  return DriftFuncionariosRepository(ref.watch(appDatabaseProvider));
});

final funcionariosEmpresaStreamProvider =
    StreamProvider.family.autoDispose<List<Funcionario>, String>((ref, id) {
  return ref
      .watch(funcionariosRepositoryProvider)
      .watchFuncionariosDaEmpresa(id);
});

final funcionariosContratanteStreamProvider =
    StreamProvider.family.autoDispose<List<Funcionario>, String>((ref, id) {
  return ref
      .watch(funcionariosRepositoryProvider)
      .watchFuncionariosDoContratante(id);
});

final funcionariosControllerProvider =
    StateNotifierProvider<FuncionariosController, AsyncValue<void>>((ref) {
  return FuncionariosController(ref.watch(funcionariosRepositoryProvider));
});

class FuncionariosController extends StateNotifier<AsyncValue<void>> {
  FuncionariosController(this._repository) : super(const AsyncData(null));

  final FuncionariosRepository _repository;

  Future<void> salvar({
    String? id,
    String? empresaId,
    String? contratanteId,
    required String nome,
    String? cpf,
    String? telefone,
    required String cargo,
  }) async {
    final empresaIdNormalizado = _normalizarTextoOpcional(empresaId);
    final contratanteIdNormalizado = _normalizarTextoOpcional(contratanteId);
    final nomeNormalizado = nome.trim();
    final cargoNormalizado = cargo.trim();

    if ((empresaIdNormalizado == null) == (contratanteIdNormalizado == null)) {
      state = AsyncError(
        ArgumentError(
          'Funcionario deve pertencer a uma empresa ou a um contratante.',
        ),
        StackTrace.current,
      );
      return;
    }

    if (nomeNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Nome do funcionario e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    if (cargoNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Cargo do funcionario e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _repository.salvarFuncionario(
        Funcionario(
          id: id ?? _novoId(),
          empresaId: empresaIdNormalizado,
          contratanteId: contratanteIdNormalizado,
          nome: nomeNormalizado,
          cpf: _normalizarTextoOpcional(cpf),
          telefone: _normalizarTextoOpcional(telefone),
          cargo: cargoNormalizado,
        ),
      );
    });
  }

  Future<void> remover(String id) async {
    final idNormalizado = id.trim();

    if (idNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Funcionario e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return _repository.removerFuncionario(idNormalizado);
    });
  }

  String _novoId() {
    return 'funcionario-${DateTime.now().microsecondsSinceEpoch}';
  }

  String? _normalizarTextoOpcional(String? value) {
    final texto = value?.trim();
    if (texto == null || texto.isEmpty) {
      return null;
    }
    return texto;
  }
}
