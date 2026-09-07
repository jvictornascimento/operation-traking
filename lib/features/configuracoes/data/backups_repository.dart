import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/database/app_database.dart' as db;
import '../domain/backup.dart';

abstract class BackupsRepository {
  Stream<PlanoBackup> watchPlano();

  Stream<BackupRegistro?> watchUltimoBackup();

  Future<PlanoBackup> carregarPlano();

  Future<void> salvarPlano(PlanoBackup plano);

  Future<BackupRegistro?> executarBackupAgendadoSeNecessario();

  Future<BackupRegistro> gerarBackupManual();
}

class DriftBackupsRepository implements BackupsRepository {
  const DriftBackupsRepository(this._database);

  static const _planoId = 'backup-local';
  static const _databaseFileName = 'operational_tracking.sqlite';

  final db.AppDatabase _database;

  @override
  Stream<PlanoBackup> watchPlano() {
    final query = _database.select(_database.configuracoesBackup)
      ..where((table) => table.id.equals(_planoId));

    return query.watchSingleOrNull().map((row) {
      if (row == null) {
        return PlanoBackup.padrao();
      }

      return _mapPlano(row);
    });
  }

  @override
  Stream<BackupRegistro?> watchUltimoBackup() {
    final query = _database.select(_database.backups)
      ..orderBy([(table) => OrderingTerm.desc(table.criadoEm)])
      ..limit(1);

    return query.watchSingleOrNull().map((row) {
      if (row == null) {
        return null;
      }

      return _mapBackup(row);
    });
  }

  @override
  Future<PlanoBackup> carregarPlano() async {
    final row = await (_database.select(_database.configuracoesBackup)
          ..where((table) => table.id.equals(_planoId)))
        .getSingleOrNull();

    if (row == null) {
      return PlanoBackup.padrao();
    }

    return _mapPlano(row);
  }

  @override
  Future<void> salvarPlano(PlanoBackup plano) {
    return _database.into(_database.configuracoesBackup).insertOnConflictUpdate(
          db.ConfiguracoesBackupCompanion.insert(
            id: _planoId,
            frequencia: plano.frequencia.name,
            copiasMantidas: Value(_normalizarCopias(plano.copiasMantidas)),
            atualizadoEm: plano.atualizadoEm,
            ultimoBackupId: Value(plano.ultimoBackupId),
          ),
        );
  }

  @override
  Future<BackupRegistro?> executarBackupAgendadoSeNecessario() async {
    final plano = await carregarPlano();
    if (plano.frequencia == FrequenciaBackup.desativado) {
      return null;
    }

    final ultimoBackup = await (_database.select(_database.backups)
          ..where((table) => table.status.equals(StatusBackup.sucesso.name))
          ..orderBy([(table) => OrderingTerm.desc(table.criadoEm)])
          ..limit(1))
        .getSingleOrNull();

    final ultimo = ultimoBackup?.criadoEm;
    if (ultimo != null && !_estaVencido(plano.frequencia, ultimo)) {
      return null;
    }

    return gerarBackupManual();
  }

  @override
  Future<BackupRegistro> gerarBackupManual() async {
    try {
      await _database.customStatement('PRAGMA wal_checkpoint(FULL)');

      final appDir = await getApplicationDocumentsDirectory();
      final databaseFile = File(p.join(appDir.path, _databaseFileName));
      if (!await databaseFile.exists()) {
        throw StateError(
          'Arquivo do banco local nao encontrado para backup.',
        );
      }

      final criadoEm = DateTime.now();
      final id = 'backup-${criadoEm.microsecondsSinceEpoch}';
      final backupsDir = Directory(p.join(appDir.path, 'backups'));
      if (!await backupsDir.exists()) {
        await backupsDir.create(recursive: true);
      }

      final backupFileName =
          'operational_tracking_backup_${_timestampArquivo(criadoEm)}.sqlite';
      final backupFile = File(p.join(backupsDir.path, backupFileName));
      await databaseFile.copy(backupFile.path);

      final length = await backupFile.length();
      final registro = BackupRegistro(
        id: id,
        caminhoArquivo: backupFile.path,
        criadoEm: criadoEm,
        status: StatusBackup.sucesso,
        tamanhoBytes: length,
      );

      await _registrarBackup(registro);
      final plano = await carregarPlano();
      await salvarPlano(
        PlanoBackup(
          frequencia: plano.frequencia,
          copiasMantidas: plano.copiasMantidas,
          atualizadoEm: DateTime.now(),
          ultimoBackupId: id,
        ),
      );
      await _aplicarRetencao(plano.copiasMantidas);

      return registro;
    } catch (error) {
      final registro = BackupRegistro(
        id: 'backup-erro-${DateTime.now().microsecondsSinceEpoch}',
        criadoEm: DateTime.now(),
        status: StatusBackup.erro,
        mensagemErro: _mensagemErro(error),
      );
      await _registrarBackup(registro);
      return registro;
    }
  }

  Future<void> _registrarBackup(BackupRegistro registro) {
    return _database.into(_database.backups).insertOnConflictUpdate(
          db.BackupsCompanion.insert(
            id: registro.id,
            caminhoArquivo: Value(registro.caminhoArquivo),
            criadoEm: registro.criadoEm,
            status: registro.status.name,
            mensagemErro: Value(registro.mensagemErro),
            tamanhoBytes: Value(registro.tamanhoBytes),
          ),
        );
  }

  Future<void> _aplicarRetencao(int copiasMantidas) async {
    final backups = await (_database.select(_database.backups)
          ..where((table) => table.status.equals(StatusBackup.sucesso.name))
          ..orderBy([(table) => OrderingTerm.desc(table.criadoEm)]))
        .get();

    final antigos = backups.skip(_normalizarCopias(copiasMantidas));
    for (final backup in antigos) {
      final caminho = backup.caminhoArquivo;
      if (caminho != null) {
        final file = File(caminho);
        if (await file.exists()) {
          await file.delete();
        }
      }

      await (_database.delete(_database.backups)
            ..where((table) => table.id.equals(backup.id)))
          .go();
    }
  }

  bool _estaVencido(FrequenciaBackup frequencia, DateTime ultimoBackup) {
    final dias = switch (frequencia) {
      FrequenciaBackup.desativado => 0,
      FrequenciaBackup.diario => 1,
      FrequenciaBackup.semanal => 7,
      FrequenciaBackup.quinzenal => 15,
      FrequenciaBackup.mensal => 30,
    };

    if (dias == 0) {
      return false;
    }

    return DateTime.now().difference(ultimoBackup).inDays >= dias;
  }

  PlanoBackup _mapPlano(db.ConfiguracoesBackupData row) {
    return PlanoBackup(
      frequencia: _mapFrequencia(row.frequencia),
      copiasMantidas: _normalizarCopias(row.copiasMantidas),
      atualizadoEm: row.atualizadoEm,
      ultimoBackupId: row.ultimoBackupId,
    );
  }

  BackupRegistro _mapBackup(db.Backup row) {
    return BackupRegistro(
      id: row.id,
      caminhoArquivo: row.caminhoArquivo,
      criadoEm: row.criadoEm,
      status: StatusBackup.values.byName(row.status),
      mensagemErro: row.mensagemErro,
      tamanhoBytes: row.tamanhoBytes,
    );
  }

  String _timestampArquivo(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}'
        '${value.month.toString().padLeft(2, '0')}'
        '${value.day.toString().padLeft(2, '0')}_'
        '${value.hour.toString().padLeft(2, '0')}'
        '${value.minute.toString().padLeft(2, '0')}'
        '${value.second.toString().padLeft(2, '0')}';
  }

  String _mensagemErro(Object error) {
    return error.toString().replaceFirst('Bad state: ', '');
  }

  FrequenciaBackup _mapFrequencia(String value) {
    return FrequenciaBackup.values.firstWhere(
      (frequencia) => frequencia.name == value,
      orElse: () => FrequenciaBackup.desativado,
    );
  }

  int _normalizarCopias(int value) {
    return value.clamp(1, 10).toInt();
  }
}
