import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:belis_oversight/features/configuracoes/data/backups_repository.dart';
import 'package:belis_oversight/features/configuracoes/domain/backup.dart';
import 'package:belis_oversight/features/configuracoes/presentation/configuracoes_controller.dart';

void main() {
  group('Issue 21 - BackupController', () {
    test('salva plano normalizando copias mantidas', () async {
      final repository = _FakeBackupsRepository();
      final controller = BackupController(repository);

      await controller.salvarPlano(
        frequencia: FrequenciaBackup.semanal,
        copiasMantidas: 15,
      );

      expect(controller.state, isA<AsyncData<BackupRegistro?>>());
      expect(repository.plano.frequencia, FrequenciaBackup.semanal);
      expect(repository.plano.copiasMantidas, 10);
    });

    test('gera backup manual e retorna registro de sucesso', () async {
      final repository = _FakeBackupsRepository();
      final controller = BackupController(repository);

      await controller.gerarBackupManual();

      final backup = controller.state.valueOrNull;
      expect(controller.state, isA<AsyncData<BackupRegistro?>>());
      expect(backup, isNotNull);
      expect(backup!.status, StatusBackup.sucesso);
      expect(backup.caminhoArquivo, '/local/backup.sqlite');
    });

    test('executa backup agendado quando repositorio indicar necessidade',
        () async {
      final repository = _FakeBackupsRepository(agendadoNecessario: true);
      final controller = BackupController(repository);

      await controller.executarBackupAgendadoSeNecessario();

      expect(controller.state.valueOrNull?.status, StatusBackup.sucesso);
    });

    test('nao retorna registro quando backup agendado nao esta vencido',
        () async {
      final repository = _FakeBackupsRepository();
      final controller = BackupController(repository);

      await controller.executarBackupAgendadoSeNecessario();

      expect(controller.state, isA<AsyncData<BackupRegistro?>>());
      expect(controller.state.valueOrNull, isNull);
    });
  });
}

class _FakeBackupsRepository implements BackupsRepository {
  _FakeBackupsRepository({this.agendadoNecessario = false});

  final bool agendadoNecessario;
  PlanoBackup plano = PlanoBackup.padrao();
  BackupRegistro? ultimoBackup;

  @override
  Future<PlanoBackup> carregarPlano() async => plano;

  @override
  Future<BackupRegistro?> executarBackupAgendadoSeNecessario() async {
    if (!agendadoNecessario) {
      return null;
    }

    return gerarBackupManual();
  }

  @override
  Future<BackupRegistro> gerarBackupManual() async {
    ultimoBackup = BackupRegistro(
      id: 'backup-1',
      caminhoArquivo: '/local/backup.sqlite',
      criadoEm: DateTime(2026, 9, 7, 10),
      status: StatusBackup.sucesso,
      tamanhoBytes: 1024,
    );
    return ultimoBackup!;
  }

  @override
  Future<void> salvarPlano(PlanoBackup plano) async {
    this.plano = plano;
  }

  @override
  Stream<PlanoBackup> watchPlano() {
    return Stream.value(plano);
  }

  @override
  Stream<BackupRegistro?> watchUltimoBackup() {
    return Stream.value(ultimoBackup);
  }
}
