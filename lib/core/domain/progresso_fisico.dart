import '../../features/etapas/domain/etapa.dart';
import '../../features/medicoes/domain/medicao.dart';
import '../../features/servicos/domain/servico.dart';

class ProgressoFisico {
  const ProgressoFisico._();

  static double calcularServicoPorMedicoes(List<Medicao> medicoes) {
    if (medicoes.isEmpty) {
      return 0;
    }

    final ordenadas = [...medicoes]
      ..sort((a, b) {
        final dataCompare = a.data.compareTo(b.data);
        if (dataCompare != 0) {
          return dataCompare;
        }
        return a.id.compareTo(b.id);
      });

    return _normalizarPercentual(ordenadas.last.percentualExecutado);
  }

  static double calcularEtapaPorServicos(List<Servico> servicos) {
    if (servicos.isEmpty) {
      return 0;
    }

    final total = servicos.fold<double>(
      0,
      (sum, servico) => sum + _normalizarPercentual(servico.progressoFisico),
    );

    return _arredondar(total / servicos.length);
  }

  static double calcularObraPorEtapas(List<Etapa> etapas) {
    if (etapas.isEmpty) {
      return 0;
    }

    final total = etapas.fold<double>(
      0,
      (sum, etapa) => sum + _normalizarPercentual(etapa.progressoFisico),
    );

    return _arredondar(total / etapas.length);
  }

  static double _normalizarPercentual(double value) {
    if (value < 0) {
      return 0;
    }

    if (value > 100) {
      return 100;
    }

    return _arredondar(value);
  }

  static double _arredondar(double value) {
    return double.parse(value.toStringAsFixed(2));
  }
}
