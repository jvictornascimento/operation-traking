import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_back_button.dart';
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
          trailing: const Icon(Icons.edit),
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
