import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/domain_enums.dart';
import '../domain/etapa.dart';
import 'etapas_controller.dart';

class EtapasPage extends ConsumerStatefulWidget {
  const EtapasPage({super.key});

  @override
  ConsumerState<EtapasPage> createState() => _EtapasPageState();
}

class _EtapasPageState extends ConsumerState<EtapasPage> {
  final _obraIdController = TextEditingController();

  @override
  void dispose() {
    _obraIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final obraId = _obraIdController.text.trim();
    final etapas = obraId.isEmpty
        ? const AsyncData(<Etapa>[])
        : ref.watch(etapasObraStreamProvider(obraId));

    ref.listen(etapasControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Etapas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _obraIdController,
              decoration: const InputDecoration(
                labelText: 'ID da obra',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: etapas.when(
              data: (items) => _EtapasList(etapas: items),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Erro ao carregar etapas: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: obraId.isEmpty
            ? null
            : () => _abrirFormulario(context, obraId: obraId),
        icon: const Icon(Icons.add),
        label: const Text('Etapa'),
      ),
    );
  }

  Future<void> _abrirFormulario(
    BuildContext context, {
    required String obraId,
    Etapa? etapa,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EtapaForm(obraId: obraId, etapa: etapa),
    );
  }
}

class _EtapasList extends StatelessWidget {
  const _EtapasList({required this.etapas});

  final List<Etapa> etapas;

  @override
  Widget build(BuildContext context) {
    if (etapas.isEmpty) {
      return const Center(child: Text('Nenhuma etapa cadastrada'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final etapa = etapas[index];
        return ListTile(
          title: Text(etapa.nome),
          subtitle: Text(_subtitle(etapa)),
          trailing: const Icon(Icons.edit),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => _EtapaForm(
              obraId: etapa.obraId,
              etapa: etapa,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: etapas.length,
    );
  }

  String _subtitle(Etapa etapa) {
    final prazo = etapa.progressoPrazoDias;
    final prazoTexto = prazo > 0
        ? '$prazo dias restantes'
        : prazo == 0
            ? 'vence hoje'
            : '${prazo.abs()} dias atrasada';

    return '${etapa.status.name} | $prazoTexto | ${etapa.progressoFisico}%';
  }
}

class _EtapaForm extends ConsumerStatefulWidget {
  const _EtapaForm({
    required this.obraId,
    this.etapa,
  });

  final String obraId;
  final Etapa? etapa;

  @override
  ConsumerState<_EtapaForm> createState() => _EtapaFormState();
}

class _EtapaFormState extends ConsumerState<_EtapaForm> {
  late final TextEditingController _nomeController;
  late DateTime _dataInicio;
  late DateTime _dataFim;
  late StatusExecucao _status;

  @override
  void initState() {
    super.initState();
    final etapa = widget.etapa;
    _nomeController = TextEditingController(text: etapa?.nome);
    _dataInicio = etapa?.dataInicio ?? DateTime.now();
    _dataFim = etapa?.dataFim ?? DateTime.now();
    _status = etapa?.status ?? StatusExecucao.naoComecou;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(etapasControllerProvider).isLoading;

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
              widget.etapa == null ? 'Nova etapa' : 'Editar etapa',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nomeController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            _DateTile(
              label: 'Inicio',
              value: _dataInicio,
              onTap: () => _selecionarData(inicio: true),
            ),
            _DateTile(
              label: 'Fim',
              value: _dataFim,
              onTap: () => _selecionarData(inicio: false),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<StatusExecucao>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: StatusExecucao.values
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _status = value);
                }
              },
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

  Future<void> _selecionarData({required bool inicio}) async {
    final dataAtual = inicio ? _dataInicio : _dataFim;
    final selected = await showDatePicker(
      context: context,
      initialDate: dataAtual,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() {
        if (inicio) {
          _dataInicio = selected;
        } else {
          _dataFim = selected;
        }
      });
    }
  }

  Future<void> _salvar() async {
    await ref.read(etapasControllerProvider.notifier).salvar(
          id: widget.etapa?.id,
          obraId: widget.obraId,
          nome: _nomeController.text,
          dataInicio: _dataInicio,
          dataFim: _dataFim,
          status: _status,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(etapasControllerProvider);
    if (!state.hasError) {
      Navigator.of(context).pop();
    }
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
