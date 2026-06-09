import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/domain_enums.dart';
import '../../../core/widgets/app_back_button.dart';
import '../domain/obra.dart';
import 'obras_controller.dart';

class ObrasPage extends ConsumerWidget {
  const ObrasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obras = ref.watch(obrasStreamProvider);
    ref.listen(obrasControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Obras'),
      ),
      body: obras.when(
        data: (items) => _ObrasList(obras: items),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Erro ao carregar obras: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(context),
        icon: const Icon(Icons.add),
        label: const Text('Obra'),
      ),
    );
  }

  Future<void> _abrirFormulario(BuildContext context, {Obra? obra}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ObraForm(obra: obra),
    );
  }
}

class _ObrasList extends StatelessWidget {
  const _ObrasList({required this.obras});

  final List<Obra> obras;

  @override
  Widget build(BuildContext context) {
    if (obras.isEmpty) {
      return const Center(child: Text('Nenhuma obra cadastrada'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final obra = obras[index];
        return ListTile(
          title: Text(obra.nome),
          subtitle: Text(_subtitle(obra)),
          trailing: const Icon(Icons.edit),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => _ObraForm(obra: obra),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: obras.length,
    );
  }

  String _subtitle(Obra obra) {
    final prazo = obra.progressoPrazoDias;
    final prazoTexto = prazo > 0
        ? '$prazo dias restantes'
        : prazo == 0
            ? 'vence hoje'
            : '${prazo.abs()} dias atrasada';

    return '${obra.status.name} | $prazoTexto | ${obra.progressoFisico}%';
  }
}

class _ObraForm extends ConsumerStatefulWidget {
  const _ObraForm({this.obra});

  final Obra? obra;

  @override
  ConsumerState<_ObraForm> createState() => _ObraFormState();
}

class _ObraFormState extends ConsumerState<_ObraForm> {
  late final TextEditingController _empresaIdController;
  late final TextEditingController _enderecoIdController;
  late final TextEditingController _nomeController;
  late DateTime _dataInicio;
  late DateTime _dataFim;
  late StatusExecucao _status;

  @override
  void initState() {
    super.initState();
    final obra = widget.obra;
    _empresaIdController = TextEditingController(text: obra?.empresaId);
    _enderecoIdController = TextEditingController(text: obra?.enderecoId);
    _nomeController = TextEditingController(text: obra?.nome);
    _dataInicio = obra?.dataInicio ?? DateTime.now();
    _dataFim = obra?.dataFim ?? DateTime.now();
    _status = obra?.status ?? StatusExecucao.naoComecou;
  }

  @override
  void dispose() {
    _empresaIdController.dispose();
    _enderecoIdController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(obrasControllerProvider).isLoading;

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
              widget.obra == null ? 'Nova obra' : 'Editar obra',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _empresaIdController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'ID da empresa',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _enderecoIdController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'ID do endereco',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
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
    await ref.read(obrasControllerProvider.notifier).salvar(
          id: widget.obra?.id,
          empresaId: _empresaIdController.text,
          enderecoId: _enderecoIdController.text,
          nome: _nomeController.text,
          dataInicio: _dataInicio,
          dataFim: _dataFim,
          status: _status,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(obrasControllerProvider);
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
