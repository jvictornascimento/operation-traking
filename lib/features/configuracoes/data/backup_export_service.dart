import 'package:flutter/services.dart';

class BackupExportService {
  static const _channel = MethodChannel(
    'operational_tracking/backup_export',
  );

  Future<void> compartilharArquivo(String caminhoArquivo) {
    return _channel.invokeMethod<void>(
      'shareBackup',
      {'path': caminhoArquivo},
    );
  }
}
