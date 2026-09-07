enum FrequenciaBackup {
  desativado,
  diario,
  semanal,
  quinzenal,
  mensal,
}

enum StatusBackup {
  sucesso,
  erro,
}

class PlanoBackup {
  const PlanoBackup({
    required this.frequencia,
    required this.copiasMantidas,
    required this.atualizadoEm,
    this.ultimoBackupId,
  });

  final FrequenciaBackup frequencia;
  final int copiasMantidas;
  final DateTime atualizadoEm;
  final String? ultimoBackupId;

  static PlanoBackup padrao() {
    return PlanoBackup(
      frequencia: FrequenciaBackup.desativado,
      copiasMantidas: 3,
      atualizadoEm: DateTime.now(),
    );
  }
}

class BackupRegistro {
  const BackupRegistro({
    required this.id,
    required this.criadoEm,
    required this.status,
    this.caminhoArquivo,
    this.mensagemErro,
    this.tamanhoBytes,
  });

  final String id;
  final String? caminhoArquivo;
  final DateTime criadoEm;
  final StatusBackup status;
  final String? mensagemErro;
  final int? tamanhoBytes;

  bool get sucesso => status == StatusBackup.sucesso;
}
