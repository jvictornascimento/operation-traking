import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/app_back_button.dart';
import '../domain/foto_medicao.dart';
import '../domain/medicao.dart';
import 'medicoes_controller.dart';

class MedicoesPage extends ConsumerStatefulWidget {
  const MedicoesPage({super.key});

  @override
  ConsumerState<MedicoesPage> createState() => _MedicoesPageState();
}

class _MedicoesPageState extends ConsumerState<MedicoesPage> {
  final _servicoIdController = TextEditingController();

  @override
  void dispose() {
    _servicoIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicoId = _servicoIdController.text.trim();
    final medicoes = servicoId.isEmpty
        ? const AsyncData(<Medicao>[])
        : ref.watch(medicoesServicoStreamProvider(servicoId));

    ref.listen(medicoesControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Medicoes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _servicoIdController,
              decoration: const InputDecoration(
                labelText: 'ID do servico',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: medicoes.when(
              data: (items) => _MedicoesList(medicoes: items),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Erro ao carregar medicoes: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: servicoId.isEmpty
            ? null
            : () => _abrirFormulario(context, servicoId: servicoId),
        icon: const Icon(Icons.add_chart),
        label: const Text('Medicao'),
      ),
    );
  }

  Future<void> _abrirFormulario(
    BuildContext context, {
    required String servicoId,
    Medicao? medicao,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _MedicaoForm(
        servicoId: servicoId,
        medicao: medicao,
      ),
    );
  }
}

class _MedicoesList extends StatelessWidget {
  const _MedicoesList({required this.medicoes});

  final List<Medicao> medicoes;

  @override
  Widget build(BuildContext context) {
    if (medicoes.isEmpty) {
      return const Center(child: Text('Nenhuma medicao cadastrada'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final medicao = medicoes[index];
        return ListTile(
          title: Text('${medicao.percentualExecutado}% executado'),
          subtitle: Text(_subtitle(medicao)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Historico da medicao',
                icon: const Icon(Icons.history),
                onPressed: () {
                  context.push(_historicoPath('medicao', medicao.id));
                },
              ),
              const Icon(Icons.edit),
            ],
          ),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => _MedicaoForm(
              servicoId: medicao.servicoId,
              medicao: medicao,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: medicoes.length,
    );
  }

  String _subtitle(Medicao medicao) {
    final data = _formatarData(medicao.data);
    final observacao = medicao.observacao;
    if (observacao == null) {
      return data;
    }

    return '$data | $observacao';
  }

  String _formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year}';
  }
}

String _historicoPath(String entidade, String entidadeId) {
  return '/historico/${Uri.encodeComponent(entidade)}/'
      '${Uri.encodeComponent(entidadeId)}';
}

class _MedicaoForm extends ConsumerStatefulWidget {
  const _MedicaoForm({
    required this.servicoId,
    this.medicao,
  });

  final String servicoId;
  final Medicao? medicao;

  @override
  ConsumerState<_MedicaoForm> createState() => _MedicaoFormState();
}

class _MedicaoFormState extends ConsumerState<_MedicaoForm> {
  late final TextEditingController _percentualController;
  late final TextEditingController _observacaoController;
  late DateTime _data;

  @override
  void initState() {
    super.initState();
    final medicao = widget.medicao;
    _percentualController = TextEditingController(
      text: medicao?.percentualExecutado.toString(),
    );
    _observacaoController = TextEditingController(text: medicao?.observacao);
    _data = medicao?.data ?? DateTime.now();
  }

  @override
  void dispose() {
    _percentualController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(medicoesControllerProvider).isLoading;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              widget.medicao == null ? 'Nova medicao' : 'Editar medicao',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _DateTile(
              label: 'Data',
              value: _data,
              onTap: _selecionarData,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _percentualController,
              keyboardType: TextInputType.number,
              inputFormatters: [_DecimalInputFormatter()],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Percentual executado',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _observacaoController,
              textInputAction: TextInputAction.newline,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Observacao',
                border: OutlineInputBorder(),
              ),
            ),
            if (widget.medicao != null) ...[
              const SizedBox(height: 16),
              _FotosMedicaoSection(medicaoId: widget.medicao!.id),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: saving ? null : _salvar,
              child: Text(saving ? 'Salvando...' : 'Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selecionarData() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() => _data = selected);
    }
  }

  Future<void> _salvar() async {
    await ref.read(medicoesControllerProvider.notifier).salvar(
          id: widget.medicao?.id,
          servicoId: widget.servicoId,
          percentualExecutado:
              double.tryParse(_percentualController.text) ?? -1,
          observacao: _observacaoController.text,
          data: _data,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(medicoesControllerProvider);
    if (!state.hasError) {
      Navigator.of(context).pop();
    }
  }
}

class _FotosMedicaoSection extends ConsumerWidget {
  const _FotosMedicaoSection({required this.medicaoId});

  final String medicaoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fotos = ref.watch(fotosMedicaoStreamProvider(medicaoId));
    final saving = ref.watch(fotosMedicaoControllerProvider).isLoading;

    ref.listen(fotosMedicaoControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fotos',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: saving
                    ? null
                    : () => _selecionarFoto(
                          ref,
                          source: ImageSource.camera,
                        ),
                icon: const Icon(Icons.photo_camera),
                label: const Text('Camera'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: saving
                    ? null
                    : () => _selecionarFoto(
                          ref,
                          source: ImageSource.gallery,
                        ),
                icon: const Icon(Icons.photo_library),
                label: const Text('Galeria'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        fotos.when(
          data: (items) => _FotosMedicaoList(fotos: items),
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) {
            return Text('Erro ao carregar fotos: $error');
          },
        ),
      ],
    );
  }

  Future<void> _selecionarFoto(
    WidgetRef ref, {
    required ImageSource source,
  }) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (picked == null) {
      return;
    }

    await ref.read(fotosMedicaoControllerProvider.notifier).salvarArquivo(
          medicaoId: medicaoId,
          caminhoOrigem: picked.path,
        );
  }
}

class _FotosMedicaoList extends ConsumerWidget {
  const _FotosMedicaoList({required this.fotos});

  final List<FotoMedicao> fotos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (fotos.isEmpty) {
      return const Text('Nenhuma foto cadastrada');
    }

    return Column(
      children: [
        for (final foto in fotos)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: _FotoPreview(caminhoArquivo: foto.caminhoArquivo),
            title: Text(foto.id),
            subtitle: Text(foto.caminhoArquivo),
            trailing: IconButton(
              tooltip: 'Remover',
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                ref
                    .read(fotosMedicaoControllerProvider.notifier)
                    .remover(foto.id);
              },
            ),
          ),
      ],
    );
  }
}

class _FotoPreview extends StatelessWidget {
  const _FotoPreview({required this.caminhoArquivo});

  final String caminhoArquivo;

  @override
  Widget build(BuildContext context) {
    final file = File(caminhoArquivo);
    if (!file.existsSync()) {
      return const SizedBox.square(
        dimension: 48,
        child: Icon(Icons.image_not_supported),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.file(
        file,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final normalized = newValue.text.replaceAll(',', '.');
    if (normalized.isEmpty || double.tryParse(normalized) != null) {
      return newValue.copyWith(text: normalized);
    }
    return oldValue;
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text('${value.day}/${value.month}/${value.year}'),
      trailing: const Icon(Icons.calendar_month),
      onTap: onTap,
    );
  }
}
