import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/backup_export_service.dart';
import '../data/backups_repository.dart';
import '../domain/backup.dart';

final backupsRepositoryProvider = Provider<BackupsRepository>((ref) {
  return DriftBackupsRepository(ref.watch(appDatabaseProvider));
});

final backupExportServiceProvider = Provider<BackupExportService>((ref) {
  return BackupExportService();
});

final planoBackupStreamProvider = StreamProvider.autoDispose<PlanoBackup>(
  (ref) => ref.watch(backupsRepositoryProvider).watchPlano(),
);

final ultimoBackupStreamProvider = StreamProvider.autoDispose<BackupRegistro?>(
  (ref) => ref.watch(backupsRepositoryProvider).watchUltimoBackup(),
);

final backupControllerProvider =
    StateNotifierProvider<BackupController, AsyncValue<BackupRegistro?>>(
  (ref) => BackupController(
    ref.watch(backupsRepositoryProvider),
    ref.watch(backupExportServiceProvider),
  ),
);

class BackupController extends StateNotifier<AsyncValue<BackupRegistro?>> {
  BackupController(
    this._repository, [
    BackupExportService? exportService,
  ])  : _exportService = exportService ?? BackupExportService(),
        super(const AsyncData(null));

  final BackupsRepository _repository;
  final BackupExportService _exportService;

  Future<void> salvarPlano({
    required FrequenciaBackup frequencia,
    required int copiasMantidas,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final planoAtual = await _repository.carregarPlano();
      await _repository.salvarPlano(
        PlanoBackup(
          frequencia: frequencia,
          copiasMantidas: copiasMantidas.clamp(1, 10).toInt(),
          atualizadoEm: DateTime.now(),
          ultimoBackupId: planoAtual.ultimoBackupId,
        ),
      );
      return null;
    });
  }

  Future<void> gerarBackupManual() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.gerarBackupManual);
  }

  Future<void> executarBackupAgendadoSeNecessario() async {
    final atual = state;
    if (atual.isLoading) {
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      _repository.executarBackupAgendadoSeNecessario,
    );
  }

  Future<void> compartilharBackup(BackupRegistro backup) async {
    final caminho = backup.caminhoArquivo;
    if (caminho == null || caminho.trim().isEmpty) {
      state = AsyncError(
        ArgumentError('Backup sem arquivo local para compartilhar.'),
        StackTrace.current,
      );
      return;
    }

    final file = File(caminho);
    if (!await file.exists()) {
      state = AsyncError(
        ArgumentError('Arquivo de backup nao encontrado no dispositivo.'),
        StackTrace.current,
      );
      return;
    }

    await _exportService.compartilharArquivo(caminho);
  }
}
