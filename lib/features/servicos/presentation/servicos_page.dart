import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/domain_enums.dart';
import '../../../core/widgets/app_back_button.dart';
import '../domain/servico.dart';
import 'servicos_controller.dart';

class ServicosPage extends ConsumerStatefulWidget {
  const ServicosPage({super.key, this.etapaId});

  final String? etapaId;

  @override
  ConsumerState<ServicosPage> createState() => _ServicosPageState();
}

class _ServicosPageState extends ConsumerState<ServicosPage> {
  final _etapaIdController = TextEditingController();

  @override
  void dispose() {
    _etapaIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final etapaId = widget.etapaId ?? _etapaIdController.text.trim();
    final servicos = etapaId.isEmpty
        ? const AsyncData(<Servico>[])
        : ref.watch(servicosEtapaStreamProvider(etapaId));

    ref.listen(servicosControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Servicos da etapa'),
      ),
      body: Column(
        children: [
          if (widget.etapaId == null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _etapaIdController,
                decoration: const InputDecoration(
                  labelText: 'ID da etapa',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          Expanded(
            child: servicos.when(
              data: (items) => _ServicosList(
                servicos: items,
                onEdit: (servico) => _abrirFormulario(
                  context,
                  etapaId: servico.etapaId,
                  servico: servico,
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Erro ao carregar servicos: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: etapaId.isEmpty
            ? null
            : () => _abrirFormulario(context, etapaId: etapaId),
        icon: const Icon(Icons.add),
        label: const Text('Servico'),
      ),
    );
  }

  Future<void> _abrirFormulario(
    BuildContext context, {
    required String etapaId,
    Servico? servico,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ServicoForm(etapaId: etapaId, servico: servico),
    );
  }
}

class _ServicosList extends StatelessWidget {
  const _ServicosList({
    required this.servicos,
    required this.onEdit,
  });

  final List<Servico> servicos;
  final ValueChanged<Servico> onEdit;

  @override
  Widget build(BuildContext context) {
    if (servicos.isEmpty) {
      return const Center(child: Text('Nenhum servico cadastrado'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final servico = servicos[index];
        return ListTile(
          title: Text(servico.nome),
          subtitle: Text(_subtitle(servico)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Historico do servico',
                icon: const Icon(Icons.history),
                onPressed: () {
                  context.push(_historicoPath('servico', servico.id));
                },
              ),
              IconButton(
                tooltip: 'Editar servico',
                icon: const Icon(Icons.edit),
                onPressed: () => onEdit(servico),
              ),
            ],
          ),
          onTap: () => context.push(
            '/etapas/${servico.etapaId}/servicos/${servico.id}/fiscalizacoes',
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: servicos.length,
    );
  }

  String _subtitle(Servico servico) {
    final prazo = servico.progressoPrazoDias;
    final prazoTexto = prazo > 0
        ? '$prazo dias restantes'
        : prazo == 0
            ? 'vence hoje'
            : '${prazo.abs()} dias atrasado';

    return '${servico.status.name} | $prazoTexto | '
        '${servico.quantidade} ${servico.unidade}';
  }
}

String _historicoPath(String entidade, String entidadeId) {
  return '/historico/${Uri.encodeComponent(entidade)}/'
      '${Uri.encodeComponent(entidadeId)}';
}

class _ServicoForm extends ConsumerStatefulWidget {
  const _ServicoForm({
    required this.etapaId,
    this.servico,
  });

  final String etapaId;
  final Servico? servico;

  @override
  ConsumerState<_ServicoForm> createState() => _ServicoFormState();
}

class _ServicoFormState extends ConsumerState<_ServicoForm> {
  late final TextEditingController _nomeController;
  late final TextEditingController _precoController;
  late final TextEditingController _unidadeController;
  late final TextEditingController _quantidadeController;
  late DateTime _dataInicio;
  late DateTime _dataFim;
  late StatusExecucao _status;

  @override
  void initState() {
    super.initState();
    final servico = widget.servico;
    _nomeController = TextEditingController(text: servico?.nome);
    _precoController = TextEditingController(
      text: servico?.precoTotal.toString(),
    );
    _unidadeController = TextEditingController(text: servico?.unidade);
    _quantidadeController = TextEditingController(
      text: servico?.quantidade.toString(),
    );
    _dataInicio = servico?.dataInicio ?? DateTime.now();
    _dataFim = servico?.dataFim ?? DateTime.now();
    _status = servico?.status ?? StatusExecucao.naoComecou;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _unidadeController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(servicosControllerProvider).isLoading;

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
              widget.servico == null ? 'Novo servico' : 'Editar servico',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nomeController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _precoController,
              keyboardType: TextInputType.number,
              inputFormatters: [_DecimalInputFormatter()],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Preco total',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _unidadeController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Unidade',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _quantidadeController,
              keyboardType: TextInputType.number,
              inputFormatters: [_DecimalInputFormatter()],
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
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
    await ref.read(servicosControllerProvider.notifier).salvar(
          id: widget.servico?.id,
          etapaId: widget.etapaId,
          nome: _nomeController.text,
          precoTotal: double.tryParse(_precoController.text) ?? 0,
          unidade: _unidadeController.text,
          quantidade: double.tryParse(_quantidadeController.text) ?? 0,
          dataInicio: _dataInicio,
          dataFim: _dataFim,
          status: _status,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(servicosControllerProvider);
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
