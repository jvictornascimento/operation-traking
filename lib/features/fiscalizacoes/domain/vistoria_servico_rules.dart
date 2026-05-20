import 'vistoria_servico.dart';

class VistoriaServicoRules {
  const VistoriaServicoRules._();

  static bool existeVistoriaNoMesmoDia({
    required Iterable<VistoriaServico> vistorias,
    required String servicoId,
    required DateTime data,
  }) {
    final dataNormalizada = _normalizarData(data);

    return vistorias.any((vistoria) {
      return vistoria.servicoId == servicoId &&
          _normalizarData(vistoria.data) == dataNormalizada;
    });
  }

  static void validarNovaVistoria({
    required Iterable<VistoriaServico> vistorias,
    required String servicoId,
    required DateTime data,
  }) {
    final duplicada = existeVistoriaNoMesmoDia(
      vistorias: vistorias,
      servicoId: servicoId,
      data: data,
    );

    if (duplicada) {
      throw StateError(
        'Ja existe fiscalizacao para este servico na data informada.',
      );
    }
  }

  static DateTime _normalizarData(DateTime data) {
    return DateTime(data.year, data.month, data.day);
  }
}
