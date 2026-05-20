import 'domain_enums.dart';

class Prazo {
  const Prazo._();

  static int calcularDias({
    required DateTime dataFim,
    required DateTime dataAtual,
  }) {
    final fim = DateTime(dataFim.year, dataFim.month, dataFim.day);
    final atual = DateTime(dataAtual.year, dataAtual.month, dataAtual.day);
    return fim.difference(atual).inDays;
  }

  static StatusExecucao aplicarStatusAtrasado({
    required StatusExecucao statusAtual,
    required int progressoPrazoDias,
  }) {
    if (statusAtual == StatusExecucao.concluida) {
      return statusAtual;
    }

    if (progressoPrazoDias < 0) {
      return StatusExecucao.atrasada;
    }

    return statusAtual;
  }
}
