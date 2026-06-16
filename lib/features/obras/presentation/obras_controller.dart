import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/domain/domain_enums.dart';
import '../../../core/domain/prazo.dart';
import '../../cadastros/domain/endereco.dart';
import '../data/obras_repository.dart';
import '../domain/obra.dart';

final obrasRepositoryProvider = Provider<ObrasRepository>((ref) {
  return DriftObrasRepository(ref.watch(appDatabaseProvider));
});

final obrasStreamProvider = StreamProvider<List<Obra>>((ref) {
  return ref.watch(obrasRepositoryProvider).watchObras();
});

final obrasControllerProvider =
    StateNotifierProvider<ObrasController, AsyncValue<void>>((ref) {
  return ObrasController(ref.watch(obrasRepositoryProvider));
});

class ObrasController extends StateNotifier<AsyncValue<void>> {
  ObrasController(this._repository) : super(const AsyncData(null));

  final ObrasRepository _repository;

  Future<void> salvar({
    String? id,
    required String empresaId,
    String? contratanteId,
    required String nome,
    String? responsavelNome,
    String? responsavelContato,
    required DateTime dataInicio,
    required DateTime dataFim,
    StatusExecucao? status,
    DateTime? dataAtual,
    String? enderecoId,
    String enderecoTipo = 'Principal',
    String? enderecoCep,
    String? enderecoLogradouro,
    String? enderecoNumero,
    String? enderecoComplemento,
    String? enderecoBairro,
    required String enderecoCidade,
    required String enderecoEstado,
    String? enderecoPais,
  }) async {
    final empresaIdNormalizado = empresaId.trim();
    final contratanteIdNormalizado = _normalizarTextoOpcional(contratanteId);
    final nomeNormalizado = nome.trim();
    final enderecoTipoNormalizado = enderecoTipo.trim();
    final enderecoCidadeNormalizada = enderecoCidade.trim();
    final enderecoEstadoNormalizado = enderecoEstado.trim();

    if (empresaIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Empresa da obra e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    if (contratanteIdNormalizado == null) {
      state = AsyncError(
        ArgumentError('Contratante da obra e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    if (nomeNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Nome da obra e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    if (enderecoTipoNormalizado.isEmpty ||
        enderecoCidadeNormalizada.isEmpty ||
        enderecoEstadoNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Tipo, cidade e estado do endereco sao obrigatorios.'),
        StackTrace.current,
      );
      return;
    }

    if (dataFim.isBefore(dataInicio)) {
      state = AsyncError(
        ArgumentError('Data final nao pode ser anterior a data inicial.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    final prazoDias = Prazo.calcularDias(
      dataFim: dataFim,
      dataAtual: dataAtual ?? DateTime.now(),
    );
    final statusBase = status ?? StatusExecucao.naoComecou;
    final statusCalculado = Prazo.aplicarStatusAtrasado(
      statusAtual: statusBase,
      progressoPrazoDias: prazoDias,
    );

    final obraId = id ?? _novoId();
    final enderecoIdFinal = _normalizarTextoOpcional(enderecoId) ??
        'endereco-${DateTime.now().microsecondsSinceEpoch}';

    state = await AsyncValue.guard(() {
      return _repository.salvarObraComEndereco(
        obra: Obra(
          id: obraId,
          empresaId: empresaIdNormalizado,
          contratanteId: contratanteIdNormalizado,
          enderecoId: enderecoIdFinal,
          nome: nomeNormalizado,
          responsavelNome: _normalizarTextoOpcional(responsavelNome),
          responsavelContato: _normalizarTextoOpcional(responsavelContato),
          dataInicio: dataInicio,
          dataFim: dataFim,
          status: statusCalculado,
          progressoFisico: 0,
          progressoPrazoDias: prazoDias,
        ),
        endereco: Endereco(
          id: enderecoIdFinal,
          entidade: TipoEntidadeEndereco.obra,
          entidadeId: obraId,
          tipo: enderecoTipoNormalizado,
          cep: _normalizarTextoOpcional(enderecoCep),
          logradouro: _normalizarTextoOpcional(enderecoLogradouro),
          numero: _normalizarTextoOpcional(enderecoNumero),
          complemento: _normalizarTextoOpcional(enderecoComplemento),
          bairro: _normalizarTextoOpcional(enderecoBairro),
          cidade: enderecoCidadeNormalizada,
          estado: enderecoEstadoNormalizado,
          pais: _normalizarTextoOpcional(enderecoPais) ?? 'Brasil',
        ),
      );
    });
  }

  String _novoId() {
    return 'obra-${DateTime.now().microsecondsSinceEpoch}';
  }

  String? _normalizarTextoOpcional(String? value) {
    final texto = value?.trim();
    if (texto == null || texto.isEmpty) {
      return null;
    }
    return texto;
  }
}
