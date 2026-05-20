import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/domain_enums.dart';
import '../domain/vistoria_servico.dart';
import 'fiscalizacoes_controller.dart';

class FiscalizacoesPage extends ConsumerStatefulWidget {
  const FiscalizacoesPage({super.key});

  @override
  ConsumerState<FiscalizacoesPage> createState() => _FiscalizacoesPageState();
}

class _FiscalizacoesPageState extends ConsumerState<FiscalizacoesPage> {
  final _servicoIdController = TextEditingController();

  @override
  void dispose() {
    _servicoIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicoId = _servicoIdController.text.trim();
    final vistorias = servicoId.isEmpty
        ? const AsyncData(<VistoriaServico>[])
        : ref.watch(vistoriasServicoStreamProvider(servicoId));

    ref.listen(fiscalizacoesControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Fiscalizacoes')),
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
            child: vistorias.when(
              data: (items) => _VistoriasList(vistorias: items),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Erro ao carregar fiscalizacoes: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: servicoId.isEmpty
            ? null
            : () => _abrirFormulario(context, servicoId: servicoId),
        icon: const Icon(Icons.add),
        label: const Text('Fiscalizacao'),
      ),
    );
  }

  Future<void> _abrirFormulario(
    BuildContext context, {
    required String servicoId,
    VistoriaServico? vistoria,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FiscalizacaoForm(
        servicoId: servicoId,
        vistoria: vistoria,
      ),
    );
  }
}

class _VistoriasList extends StatelessWidget {
  const _VistoriasList({required this.vistorias});

  final List<VistoriaServico> vistorias;

  @override
  Widget build(BuildContext context) {
    if (vistorias.isEmpty) {
      return const Center(child: Text('Nenhuma fiscalizacao cadastrada'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final vistoria = vistorias[index];
        return ListTile(
          title: Text('Fiscalizacao ${vistoria.numero}'),
          subtitle: Text(
            '${vistoria.status.name} | '
            '${vistoria.data.day}/${vistoria.data.month}/${vistoria.data.year}',
          ),
          trailing: const Icon(Icons.edit),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => _FiscalizacaoForm(
              servicoId: vistoria.servicoId,
              vistoria: vistoria,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: vistorias.length,
    );
  }
}

class _FiscalizacaoForm extends ConsumerStatefulWidget {
  const _FiscalizacaoForm({
    required this.servicoId,
    this.vistoria,
  });

  final String servicoId;
  final VistoriaServico? vistoria;

  @override
  ConsumerState<_FiscalizacaoForm> createState() => _FiscalizacaoFormState();
}

class _FiscalizacaoFormState extends ConsumerState<_FiscalizacaoForm> {
  late final TextEditingController _obraIdController;
  late final TextEditingController _contratanteIdController;
  late final TextEditingController _responsavelIdController;
  late final TextEditingController _numeroController;
  late final TextEditingController _ocorrenciaController;
  late final TextEditingController _comentarioController;
  late DateTime _data;
  late StatusFiscalizacao _status;

  @override
  void initState() {
    super.initState();
    final vistoria = widget.vistoria;
    _obraIdController = TextEditingController(text: vistoria?.obraId);
    _contratanteIdController =
        TextEditingController(text: vistoria?.contratanteId);
    _responsavelIdController =
        TextEditingController(text: vistoria?.responsavelId);
    _numeroController = TextEditingController(text: vistoria?.numero);
    _ocorrenciaController = TextEditingController(text: vistoria?.ocorrencia);
    _comentarioController = TextEditingController(text: vistoria?.comentario);
    _data = vistoria?.data ?? DateTime.now();
    _status = vistoria?.status ?? StatusFiscalizacao.emAndamento;
  }

  @override
  void dispose() {
    _obraIdController.dispose();
    _contratanteIdController.dispose();
    _responsavelIdController.dispose();
    _numeroController.dispose();
    _ocorrenciaController.dispose();
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(fiscalizacoesControllerProvider).isLoading;

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
              widget.vistoria == null
                  ? 'Nova fiscalizacao'
                  : 'Editar fiscalizacao',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _obraIdController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'ID da obra',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contratanteIdController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'ID do contratante',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _responsavelIdController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'ID do responsavel',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _numeroController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Numero',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data'),
              subtitle: Text('${_data.day}/${_data.month}/${_data.year}'),
              trailing: const Icon(Icons.calendar_month),
              onTap: _selecionarData,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<StatusFiscalizacao>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: StatusFiscalizacao.values
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
            const SizedBox(height: 12),
            TextField(
              controller: _ocorrenciaController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Ocorrencia',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _comentarioController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Comentario',
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
    await ref.read(fiscalizacoesControllerProvider.notifier).salvar(
          id: widget.vistoria?.id,
          servicoId: widget.servicoId,
          obraId: _obraIdController.text,
          contratanteId: _contratanteIdController.text,
          responsavelId: _responsavelIdController.text,
          numero: _numeroController.text,
          data: _data,
          status: _status,
          ocorrencia: _ocorrenciaController.text,
          comentario: _comentarioController.text,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(fiscalizacoesControllerProvider);
    if (!state.hasError) {
      Navigator.of(context).pop();
    }
  }
}
