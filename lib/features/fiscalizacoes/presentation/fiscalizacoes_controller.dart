import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/domain/domain_enums.dart';
import '../data/vistorias_servico_repository.dart';
import '../domain/vistoria_servico.dart';

final vistoriasServicoRepositoryProvider =
    Provider<VistoriasServicoRepository>((ref) {
  return DriftVistoriasServicoRepository(ref.watch(appDatabaseProvider));
});

final vistoriasServicoStreamProvider =
    StreamProvider.family.autoDispose<List<VistoriaServico>, String>(
  (ref, servicoId) {
    return ref
        .watch(vistoriasServicoRepositoryProvider)
        .watchVistoriasDoServico(servicoId);
  },
);

final fiscalizacoesControllerProvider =
    StateNotifierProvider<FiscalizacoesController, AsyncValue<void>>((ref) {
  return FiscalizacoesController(ref.watch(vistoriasServicoRepositoryProvider));
});

class FiscalizacoesController extends StateNotifier<AsyncValue<void>> {
  FiscalizacoesController(this._repository) : super(const AsyncData(null));

  final VistoriasServicoRepository _repository;

  Future<void> salvar({
    String? id,
    required String servicoId,
    required String obraId,
    required String contratanteId,
    required String responsavelId,
    String? numero,
    required DateTime data,
    StatusFiscalizacao? status,
    String? ocorrencia,
    String? comentario,
  }) async {
    final servicoIdNormalizado = servicoId.trim();
    final obraIdNormalizado = obraId.trim();
    final contratanteIdNormalizado = contratanteId.trim();
    final responsavelIdNormalizado = responsavelId.trim();
    final numeroNormalizado = _normalizarTextoOpcional(numero);

    if (servicoIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Servico da fiscalizacao e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    if (obraIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Obra da fiscalizacao e obrigatoria.'),
        StackTrace.current,
      );
      return;
    }

    if (contratanteIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Contratante da fiscalizacao e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    if (responsavelIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Responsavel da fiscalizacao e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    final dataNormalizada = DateTime(data.year, data.month, data.day);
    final idFinal = id ?? _novoId();

    state = await AsyncValue.guard(() {
      return _repository.salvarVistoria(
        VistoriaServico(
          id: idFinal,
          servicoId: servicoIdNormalizado,
          obraId: obraIdNormalizado,
          contratanteId: contratanteIdNormalizado,
          responsavelId: responsavelIdNormalizado,
          numero: numeroNormalizado ?? _novoNumero(dataNormalizada),
          data: dataNormalizada,
          diaSemana: dataNormalizada.weekday,
          status: status ?? StatusFiscalizacao.emAndamento,
          ocorrencia: _normalizarTextoOpcional(ocorrencia),
          comentario: _normalizarTextoOpcional(comentario),
        ),
      );
    });
  }

  String _novoId() {
    return 'vistoria-${DateTime.now().microsecondsSinceEpoch}';
  }

  String _novoNumero(DateTime data) {
    final ano = data.year.toString().padLeft(4, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final dia = data.day.toString().padLeft(2, '0');
    final micros = DateTime.now().microsecondsSinceEpoch;
    return 'VS-$ano$mes$dia-$micros';
  }

  String? _normalizarTextoOpcional(String? value) {
    final texto = value?.trim();
    if (texto == null || texto.isEmpty) {
      return null;
    }
    return texto;
  }
}
