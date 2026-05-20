import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/domain/domain_enums.dart';
import '../data/vistorias_servico_repository.dart';
import '../domain/vistoria_servico.dart';
import '../domain/vistoria_servico_rules.dart';

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
    required String numero,
    required DateTime data,
    StatusFiscalizacao status = StatusFiscalizacao.emAndamento,
    String? ocorrencia,
    String? comentario,
  }) async {
    final servicoIdNormalizado = servicoId.trim();
    final obraIdNormalizado = obraId.trim();
    final contratanteIdNormalizado = contratanteId.trim();
    final responsavelIdNormalizado = responsavelId.trim();
    final numeroNormalizado = numero.trim();

    if (servicoIdNormalizado.isEmpty ||
        obraIdNormalizado.isEmpty ||
        contratanteIdNormalizado.isEmpty ||
        responsavelIdNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError(
          'Servico, obra, contratante e responsavel sao obrigatorios.',
        ),
        StackTrace.current,
      );
      return;
    }

    if (numeroNormalizado.isEmpty) {
      state = AsyncError(
        ArgumentError('Numero da fiscalizacao e obrigatorio.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final existentes = await _repository.listarVistoriasDoServico(
        servicoIdNormalizado,
      );

      if (id == null) {
        VistoriaServicoRules.validarNovaVistoria(
          vistorias: existentes,
          servicoId: servicoIdNormalizado,
          data: data,
        );
      }

      return _repository.salvarVistoria(
        VistoriaServico(
          id: id ?? _novoId(),
          servicoId: servicoIdNormalizado,
          obraId: obraIdNormalizado,
          contratanteId: contratanteIdNormalizado,
          responsavelId: responsavelIdNormalizado,
          numero: numeroNormalizado,
          data: data,
          diaSemana: data.weekday,
          status: status,
          ocorrencia: _normalizarTextoOpcional(ocorrencia),
          comentario: _normalizarTextoOpcional(comentario),
        ),
      );
    });
  }

  String _novoId() {
    return 'vistoria-${DateTime.now().microsecondsSinceEpoch}';
  }

  String? _normalizarTextoOpcional(String? value) {
    final texto = value?.trim();
    if (texto == null || texto.isEmpty) {
      return null;
    }
    return texto;
  }
}
