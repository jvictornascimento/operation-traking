import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/domain/domain_enums.dart';
import '../data/contatos_repository.dart';
import '../domain/contato.dart';

final contatosRepositoryProvider = Provider<ContatosRepository>((ref) {
  return DriftContatosRepository(ref.watch(appDatabaseProvider));
});

final contatosStreamProvider = StreamProvider.family
    .autoDispose<List<Contato>, ContatosFiltro>((ref, filtro) {
  return ref.watch(contatosRepositoryProvider).watchContatos(
        entidade: filtro.entidade,
        entidadeId: filtro.entidadeId,
      );
});

final contatosControllerProvider =
    StateNotifierProvider<ContatosController, AsyncValue<void>>((ref) {
  return ContatosController(ref.watch(contatosRepositoryProvider));
});

class ContatosFiltro {
  const ContatosFiltro({
    required this.entidade,
    required this.entidadeId,
  });

  final TipoEntidadeContato entidade;
  final String entidadeId;

  @override
  bool operator ==(Object other) {
    return other is ContatosFiltro &&
        other.entidade == entidade &&
        other.entidadeId == entidadeId;
  }

  @override
  int get hashCode => Object.hash(entidade, entidadeId);
}

class ContatosController extends StateNotifier<AsyncValue<void>> {
  ContatosController(this._repository) : super(const AsyncData(null));

  final ContatosRepository _repository;

  Future<void> salvar({
    String? id,
    required TipoEntidadeContato entidade,
    required String entidadeId,
    required TipoContato tipo,
    required String valor,
    String? observacao,
  }) async {
    final entidadeIdNormalizado = entidadeId.trim();
    final valorNormalizado = valor.trim();

    if (entidadeIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Entidade do contato e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    if (valorNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Valor do contato e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _repository.salvarContato(
        Contato(
          id: id ?? _novoId(),
          entidade: entidade,
          entidadeId: entidadeIdNormalizado,
          tipo: tipo,
          valor: valorNormalizado,
          observacao: _normalizarTextoOpcional(observacao),
        ),
      );
    });
  }

  String _novoId() {
    return 'contato-${DateTime.now().microsecondsSinceEpoch}';
  }

  String? _normalizarTextoOpcional(String? value) {
    final texto = value?.trim();
    if (texto == null || texto.isEmpty) {
      return null;
    }
    return texto;
  }
}
