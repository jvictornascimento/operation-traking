import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/domain/domain_enums.dart';
import '../data/enderecos_repository.dart';
import '../domain/endereco.dart';

final enderecosRepositoryProvider = Provider<EnderecosRepository>((ref) {
  return DriftEnderecosRepository(ref.watch(appDatabaseProvider));
});

final enderecosStreamProvider = StreamProvider.family
    .autoDispose<List<Endereco>, EnderecosFiltro>((ref, filtro) {
  return ref.watch(enderecosRepositoryProvider).watchEnderecos(
        entidade: filtro.entidade,
        entidadeId: filtro.entidadeId,
      );
});

final enderecosControllerProvider =
    StateNotifierProvider<EnderecosController, AsyncValue<void>>((ref) {
  return EnderecosController(ref.watch(enderecosRepositoryProvider));
});

class EnderecosFiltro {
  const EnderecosFiltro({
    required this.entidade,
    required this.entidadeId,
  });

  final TipoEntidadeEndereco entidade;
  final String entidadeId;

  @override
  bool operator ==(Object other) {
    return other is EnderecosFiltro &&
        other.entidade == entidade &&
        other.entidadeId == entidadeId;
  }

  @override
  int get hashCode => Object.hash(entidade, entidadeId);
}

class EnderecosController extends StateNotifier<AsyncValue<void>> {
  EnderecosController(this._repository) : super(const AsyncData(null));

  final EnderecosRepository _repository;

  Future<void> salvar({
    String? id,
    required TipoEntidadeEndereco entidade,
    required String entidadeId,
    required String tipo,
    String? cep,
    String? logradouro,
    String? numero,
    String? complemento,
    String? bairro,
    required String cidade,
    required String estado,
    String? pais,
  }) async {
    final tipoNormalizado = tipo.trim();
    final entidadeIdNormalizado = entidadeId.trim();
    final cidadeNormalizada = cidade.trim();
    final estadoNormalizado = estado.trim();

    if (entidadeIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Entidade do endereco e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    if (tipoNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Tipo do endereco e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    if (cidadeNormalizada.isEmpty || estadoNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Cidade e estado sao obrigatorios.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return _repository.salvarEndereco(
        Endereco(
          id: id ?? _novoId(),
          entidade: entidade,
          entidadeId: entidadeIdNormalizado,
          tipo: tipoNormalizado,
          cep: _normalizarTextoOpcional(cep),
          logradouro: _normalizarTextoOpcional(logradouro),
          numero: _normalizarTextoOpcional(numero),
          complemento: _normalizarTextoOpcional(complemento),
          bairro: _normalizarTextoOpcional(bairro),
          cidade: cidadeNormalizada,
          estado: estadoNormalizado,
          pais: _normalizarTextoOpcional(pais) ?? 'Brasil',
        ),
      );
    });
  }

  String _novoId() {
    return 'endereco-${DateTime.now().microsecondsSinceEpoch}';
  }

  String? _normalizarTextoOpcional(String? value) {
    final texto = value?.trim();
    if (texto == null || texto.isEmpty) {
      return null;
    }
    return texto;
  }
}
