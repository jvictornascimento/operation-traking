import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/domain_enums.dart';
import '../../../core/widgets/app_back_button.dart';
import '../domain/vistoria_periodo.dart';
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
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Fiscalizacoes'),
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
            child: vistorias.when(
              data: (items) => _FiscalizacoesList(vistorias: items),
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

class _FiscalizacoesList extends StatelessWidget {
  const _FiscalizacoesList({required this.vistorias});

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
          title: Text(vistoria.numero),
          subtitle: Text(_subtitle(vistoria)),
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

  String _subtitle(VistoriaServico vistoria) {
    return '${_formatarData(vistoria.data)} | ${vistoria.status.name} | '
        'obra ${vistoria.obraId}';
  }

  String _formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year}';
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

  @override
  void initState() {
    super.initState();
    final vistoria = widget.vistoria;
    _obraIdController = TextEditingController(text: vistoria?.obraId);
    _contratanteIdController = TextEditingController(
      text: vistoria?.contratanteId,
    );
    _responsavelIdController = TextEditingController(
      text: vistoria?.responsavelId,
    );
    _numeroController = TextEditingController(text: vistoria?.numero);
    _ocorrenciaController = TextEditingController(text: vistoria?.ocorrencia);
    _comentarioController = TextEditingController(text: vistoria?.comentario);
    _data = vistoria?.data ?? DateTime.now();
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
    final vistoria = widget.vistoria;

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
              vistoria == null ? 'Nova fiscalizacao' : 'Editar fiscalizacao',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${(vistoria?.status.name) ?? 'emAndamento'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _DateTile(
              label: 'Data',
              value: _data,
              onTap: _selecionarData,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _numeroController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Numero',
                hintText: 'Gerado automaticamente se ficar vazio',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
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
              controller: _ocorrenciaController,
              textInputAction: TextInputAction.newline,
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
              textInputAction: TextInputAction.newline,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Comentario',
                border: OutlineInputBorder(),
              ),
            ),
            if (vistoria != null) ...[
              const SizedBox(height: 16),
              _PeriodosSection(vistoriaServicoId: vistoria.id),
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
    final vistoria = widget.vistoria;

    await ref.read(fiscalizacoesControllerProvider.notifier).salvar(
          id: vistoria?.id,
          servicoId: widget.servicoId,
          obraId: _obraIdController.text,
          contratanteId: _contratanteIdController.text,
          responsavelId: _responsavelIdController.text,
          numero: _numeroController.text,
          data: _data,
          status: vistoria?.status,
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

class _PeriodosSection extends ConsumerWidget {
  const _PeriodosSection({required this.vistoriaServicoId});

  final String vistoriaServicoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodos =
        ref.watch(periodosVistoriaStreamProvider(vistoriaServicoId));

    ref.listen(periodosFiscalizacaoControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return periodos.when(
      data: (items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Periodos',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final periodo in PeriodoDia.values)
            _PeriodoEditor(
              vistoriaServicoId: vistoriaServicoId,
              periodo: periodo,
              value: _buscarPeriodo(items, periodo),
            ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('Erro ao carregar periodos: $error'),
    );
  }

  VistoriaPeriodo? _buscarPeriodo(
    List<VistoriaPeriodo> periodos,
    PeriodoDia periodo,
  ) {
    for (final item in periodos) {
      if (item.periodo == periodo) {
        return item;
      }
    }

    return null;
  }
}

class _PeriodoEditor extends ConsumerWidget {
  const _PeriodoEditor({
    required this.vistoriaServicoId,
    required this.periodo,
    required this.value,
  });

  final String vistoriaServicoId;
  final PeriodoDia periodo;
  final VistoriaPeriodo? value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checked = value != null;
    final tempo = value?.tempo ?? TempoPeriodo.claro;
    final condicao = value?.condicao ?? CondicaoPeriodo.praticavel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(_periodoLabel(periodo)),
          value: checked,
          onChanged: (selected) {
            if (selected ?? false) {
              _salvar(ref, tempo: tempo, condicao: condicao);
              return;
            }

            ref.read(periodosFiscalizacaoControllerProvider.notifier).remover(
                  vistoriaServicoId: vistoriaServicoId,
                  periodo: periodo,
                );
          },
        ),
        if (checked) ...[
          Text(
            'Tempo',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          RadioGroup<TempoPeriodo>(
            groupValue: tempo,
            onChanged: (selected) {
              if (selected != null) {
                _salvar(ref, tempo: selected, condicao: condicao);
              }
            },
            child: Column(
              children: [
                for (final option in TempoPeriodo.values)
                  RadioListTile<TempoPeriodo>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(_tempoLabel(option)),
                    value: option,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Condicao',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          RadioGroup<CondicaoPeriodo>(
            groupValue: condicao,
            onChanged: (selected) {
              if (selected != null) {
                _salvar(ref, tempo: tempo, condicao: selected);
              }
            },
            child: Column(
              children: [
                for (final option in CondicaoPeriodo.values)
                  RadioListTile<CondicaoPeriodo>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(_condicaoLabel(option)),
                    value: option,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  void _salvar(
    WidgetRef ref, {
    required TempoPeriodo tempo,
    required CondicaoPeriodo condicao,
  }) {
    ref.read(periodosFiscalizacaoControllerProvider.notifier).salvar(
          id: value?.id,
          vistoriaServicoId: vistoriaServicoId,
          periodo: periodo,
          tempo: tempo,
          condicao: condicao,
        );
  }

  String _periodoLabel(PeriodoDia periodo) {
    return switch (periodo) {
      PeriodoDia.manha => 'Manha',
      PeriodoDia.tarde => 'Tarde',
      PeriodoDia.noite => 'Noite',
    };
  }

  String _tempoLabel(TempoPeriodo tempo) {
    return switch (tempo) {
      TempoPeriodo.claro => 'Claro',
      TempoPeriodo.nublado => 'Nublado',
      TempoPeriodo.chuvoso => 'Chuvoso',
    };
  }

  String _condicaoLabel(CondicaoPeriodo condicao) {
    return switch (condicao) {
      CondicaoPeriodo.praticavel => 'Praticavel',
      CondicaoPeriodo.impraticavel => 'Impraticavel',
    };
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
