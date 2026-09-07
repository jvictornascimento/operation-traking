import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_loading.dart';
import '../domain/backup.dart';
import 'configuracoes_controller.dart';

class ConfiguracoesPage extends ConsumerStatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  ConsumerState<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends ConsumerState<ConfiguracoesPage> {
  bool _agendamentoVerificado = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _agendamentoVerificado) {
        return;
      }

      _agendamentoVerificado = true;
      ref
          .read(backupControllerProvider.notifier)
          .executarBackupAgendadoSeNecessario();
    });
  }

  @override
  Widget build(BuildContext context) {
    final plano = ref.watch(planoBackupStreamProvider);
    final ultimoBackup = ref.watch(ultimoBackupStreamProvider);
    final controllerState = ref.watch(backupControllerProvider);

    ref.listen(backupControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_mensagemErro(next.error))),
        );
        return;
      }

      final backup = next.valueOrNull;
      if (backup == null) {
        return;
      }

      final mensagem = backup.sucesso
          ? 'Backup local gerado com sucesso.'
          : 'Falha ao gerar backup: ${backup.mensagemErro ?? 'erro desconhecido'}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    });

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Configuracoes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Backup',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          plano.when(
            data: (value) => _PlanoBackupCard(
              plano: value,
              saving: controllerState.isLoading,
            ),
            loading: () => const AppInlineLoading(),
            error: (error, stackTrace) {
              return Text('Erro ao carregar plano de backup: $error');
            },
          ),
          const SizedBox(height: 12),
          ultimoBackup.when(
            data: (value) => _UltimoBackupCard(
              backup: value,
              saving: controllerState.isLoading,
            ),
            loading: () => const AppInlineLoading(),
            error: (error, stackTrace) {
              return Text('Erro ao carregar ultimo backup: $error');
            },
          ),
        ],
      ),
    );
  }

  String _mensagemErro(Object? error) {
    if (error == null) {
      return 'Nao foi possivel concluir a operacao.';
    }

    return error.toString().replaceFirst('Invalid argument(s): ', '');
  }
}

class _PlanoBackupCard extends ConsumerWidget {
  const _PlanoBackupCard({
    required this.plano,
    required this.saving,
  });

  final PlanoBackup plano;
  final bool saving;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plano de backup local',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<FrequenciaBackup>(
              initialValue: plano.frequencia,
              decoration: const InputDecoration(
                labelText: 'Frequencia',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final frequencia in FrequenciaBackup.values)
                  DropdownMenuItem(
                    value: frequencia,
                    child: Text(_frequenciaLabel(frequencia)),
                  ),
              ],
              onChanged: saving
                  ? null
                  : (value) {
                      if (value == null) {
                        return;
                      }

                      ref.read(backupControllerProvider.notifier).salvarPlano(
                            frequencia: value,
                            copiasMantidas: plano.copiasMantidas,
                          );
                    },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: plano.copiasMantidas.clamp(1, 10).toInt(),
              decoration: const InputDecoration(
                labelText: 'Copias locais mantidas',
                border: OutlineInputBorder(),
              ),
              items: [
                for (var count = 1; count <= 10; count++)
                  DropdownMenuItem(
                    value: count,
                    child: Text(count.toString()),
                  ),
              ],
              onChanged: saving
                  ? null
                  : (value) {
                      if (value == null) {
                        return;
                      }

                      ref.read(backupControllerProvider.notifier).salvarPlano(
                            frequencia: plano.frequencia,
                            copiasMantidas: value,
                          );
                    },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: saving
                        ? null
                        : () => ref
                            .read(backupControllerProvider.notifier)
                            .gerarBackupManual(),
                    icon: saving
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.backup),
                    label: Text(saving ? 'Gerando...' : 'Gerar backup'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _frequenciaLabel(FrequenciaBackup frequencia) {
    return switch (frequencia) {
      FrequenciaBackup.desativado => 'Sem backup agendado',
      FrequenciaBackup.diario => 'Diario',
      FrequenciaBackup.semanal => 'Semanal',
      FrequenciaBackup.quinzenal => 'Quinzenal',
      FrequenciaBackup.mensal => 'Mensal',
    };
  }
}

class _UltimoBackupCard extends ConsumerWidget {
  const _UltimoBackupCard({
    required this.backup,
    required this.saving,
  });

  final BackupRegistro? backup;
  final bool saving;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backup = this.backup;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ultimo backup',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (backup == null)
              const Text('Nenhum backup local gerado')
            else ...[
              _InfoRow(
                label: 'Status',
                value: backup.sucesso ? 'Sucesso' : 'Erro',
              ),
              _InfoRow(
                  label: 'Data', value: _formatarDataHora(backup.criadoEm)),
              if (backup.tamanhoBytes != null)
                _InfoRow(
                  label: 'Tamanho',
                  value: _formatarTamanho(backup.tamanhoBytes!),
                ),
              if (backup.caminhoArquivo != null)
                _InfoRow(
                  label: 'Arquivo',
                  value: backup.caminhoArquivo!,
                ),
              if (backup.mensagemErro != null)
                _InfoRow(
                  label: 'Erro',
                  value: backup.mensagemErro!,
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: saving || !backup.sucesso
                    ? null
                    : () => ref
                        .read(backupControllerProvider.notifier)
                        .compartilharBackup(backup),
                icon: const Icon(Icons.share),
                label: const Text('Compartilhar backup'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatarDataHora(DateTime value) {
    final dia = value.day.toString().padLeft(2, '0');
    final mes = value.month.toString().padLeft(2, '0');
    final ano = value.year.toString().padLeft(4, '0');
    final hora = value.hour.toString().padLeft(2, '0');
    final minuto = value.minute.toString().padLeft(2, '0');

    return '$dia/$mes/$ano $hora:$minuto';
  }

  String _formatarTamanho(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    final kb = bytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    }

    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
