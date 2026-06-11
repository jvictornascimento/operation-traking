import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/domain_enums.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../cadastros/domain/funcionario.dart';
import '../../medicoes/domain/medicao.dart';
import '../../medicoes/presentation/medicoes_controller.dart';
import '../../relatorios/presentation/relatorios_controller.dart';
import '../domain/vistoria_mao_de_obra.dart';
import '../domain/vistoria_periodo.dart';
import '../domain/vistoria_servico.dart';
import 'fiscalizacoes_controller.dart';

class FiscalizacoesPage extends ConsumerStatefulWidget {
  const FiscalizacoesPage({super.key, this.servicoId});

  final String? servicoId;

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
    final servicoId = widget.servicoId ?? _servicoIdController.text.trim();
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
        title: const Text('Fiscalizacoes do servico'),
      ),
      body: Column(
        children: [
          if (widget.servicoId == null)
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
            if (widget.vistoria != null || widget.servicoId.isEmpty) ...[
              TextField(
                controller: _obraIdController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'ID da obra',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
            ],
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
              const SizedBox(height: 16),
              _MaoDeObraSection(vistoriaServicoId: vistoria.id),
              const SizedBox(height: 16),
              _MedicoesFiscalizacaoSection(
                vistoriaServicoId: vistoria.id,
              ),
              const SizedBox(height: 16),
              _RelatorioFiscalizacaoSection(vistoriaServicoId: vistoria.id),
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

class _MaoDeObraSection extends ConsumerStatefulWidget {
  const _MaoDeObraSection({required this.vistoriaServicoId});

  final String vistoriaServicoId;

  @override
  ConsumerState<_MaoDeObraSection> createState() => _MaoDeObraSectionState();
}

class _MaoDeObraSectionState extends ConsumerState<_MaoDeObraSection> {
  final _funcionarioIdController = TextEditingController();
  final _funcaoNoDiaController = TextEditingController();
  final _observacaoController = TextEditingController();

  @override
  void dispose() {
    _funcionarioIdController.dispose();
    _funcaoNoDiaController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maoDeObra =
        ref.watch(maoDeObraVistoriaStreamProvider(widget.vistoriaServicoId));
    final funcionarios = ref.watch(
      funcionariosMaoDeObraDisponiveisStreamProvider(widget.vistoriaServicoId),
    );
    final saving = ref.watch(maoDeObraFiscalizacaoControllerProvider).isLoading;

    ref.listen(maoDeObraFiscalizacaoControllerProvider, (previous, next) {
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
          'Mao de obra',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        funcionarios.when(
          data: (items) => _FuncionariosDisponiveisList(
            funcionarios: items,
            onSelect: (funcionario) {
              _funcionarioIdController.text = funcionario.id;
              _funcaoNoDiaController.text = funcionario.cargo;
            },
          ),
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) {
            return Text('Erro ao carregar funcionarios: $error');
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _funcionarioIdController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'ID do funcionario',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _funcaoNoDiaController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Funcao no dia',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _observacaoController,
          textInputAction: TextInputAction.newline,
          minLines: 2,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Observacao',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: saving ? null : _salvar,
            icon: const Icon(Icons.person_add),
            label: Text(saving ? 'Salvando...' : 'Adicionar'),
          ),
        ),
        const SizedBox(height: 12),
        maoDeObra.when(
          data: (items) => _MaoDeObraSelecionadaList(
            maoDeObra: items,
            onRemove: (item) {
              ref
                  .read(maoDeObraFiscalizacaoControllerProvider.notifier)
                  .remover(item.id);
            },
          ),
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) {
            return Text('Erro ao carregar mao de obra: $error');
          },
        ),
      ],
    );
  }

  Future<void> _salvar() async {
    await ref.read(maoDeObraFiscalizacaoControllerProvider.notifier).salvar(
          vistoriaServicoId: widget.vistoriaServicoId,
          funcionarioId: _funcionarioIdController.text,
          funcaoNoDia: _funcaoNoDiaController.text,
          observacao: _observacaoController.text,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(maoDeObraFiscalizacaoControllerProvider);
    if (!state.hasError) {
      _funcionarioIdController.clear();
      _funcaoNoDiaController.clear();
      _observacaoController.clear();
    }
  }
}

class _FuncionariosDisponiveisList extends StatelessWidget {
  const _FuncionariosDisponiveisList({
    required this.funcionarios,
    required this.onSelect,
  });

  final List<Funcionario> funcionarios;
  final ValueChanged<Funcionario> onSelect;

  @override
  Widget build(BuildContext context) {
    if (funcionarios.isEmpty) {
      return const Text('Nenhum funcionario da empresa encontrado');
    }

    return Column(
      children: [
        for (final funcionario in funcionarios)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(funcionario.nome),
            subtitle: Text('${funcionario.cargo} | ${funcionario.id}'),
            trailing: const Icon(Icons.add),
            onTap: () => onSelect(funcionario),
          ),
      ],
    );
  }
}

class _MaoDeObraSelecionadaList extends StatelessWidget {
  const _MaoDeObraSelecionadaList({
    required this.maoDeObra,
    required this.onRemove,
  });

  final List<VistoriaMaoDeObra> maoDeObra;
  final ValueChanged<VistoriaMaoDeObra> onRemove;

  @override
  Widget build(BuildContext context) {
    if (maoDeObra.isEmpty) {
      return const Text('Nenhum funcionario selecionado');
    }

    return Column(
      children: [
        for (final item in maoDeObra)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(item.funcionarioId),
            subtitle: Text(_subtitle(item)),
            trailing: IconButton(
              tooltip: 'Remover',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => onRemove(item),
            ),
          ),
      ],
    );
  }

  String _subtitle(VistoriaMaoDeObra item) {
    final partes = [
      if (item.funcaoNoDia != null) item.funcaoNoDia,
      if (item.observacao != null) item.observacao,
    ];

    if (partes.isEmpty) {
      return 'Sem detalhes';
    }

    return partes.join(' | ');
  }
}

class _MedicoesFiscalizacaoSection extends ConsumerStatefulWidget {
  const _MedicoesFiscalizacaoSection({required this.vistoriaServicoId});

  final String vistoriaServicoId;

  @override
  ConsumerState<_MedicoesFiscalizacaoSection> createState() =>
      _MedicoesFiscalizacaoSectionState();
}

class _MedicoesFiscalizacaoSectionState
    extends ConsumerState<_MedicoesFiscalizacaoSection> {
  final _percentualController = TextEditingController();
  final _observacaoController = TextEditingController();
  DateTime _data = DateTime.now();
  Medicao? _editando;

  @override
  void dispose() {
    _percentualController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicoes =
        ref.watch(medicoesFiscalizacaoStreamProvider(widget.vistoriaServicoId));
    final saving = ref.watch(medicoesControllerProvider).isLoading;

    ref.listen(medicoesControllerProvider, (previous, next) {
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
          'Medicao',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _DateTile(
          label: 'Data da medicao',
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
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Observacao da medicao',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_editando != null)
              TextButton(
                onPressed: saving ? null : _limparFormulario,
                child: const Text('Cancelar'),
              ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: saving ? null : _salvar,
              icon: const Icon(Icons.add_chart),
              label: Text(saving ? 'Salvando...' : _labelSalvar()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        medicoes.when(
          data: (items) => _MedicoesFiscalizacaoList(
            medicoes: items,
            onSelect: _preencherFormulario,
          ),
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) {
            return Text('Erro ao carregar medicoes: $error');
          },
        ),
      ],
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
    await ref.read(medicoesControllerProvider.notifier).salvarDaFiscalizacao(
          id: _editando?.id,
          vistoriaServicoId: widget.vistoriaServicoId,
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
      _limparFormulario();
    }
  }

  void _preencherFormulario(Medicao medicao) {
    setState(() {
      _editando = medicao;
      _data = medicao.data;
      _percentualController.text = medicao.percentualExecutado.toString();
      _observacaoController.text = medicao.observacao ?? '';
    });
  }

  void _limparFormulario() {
    setState(() {
      _editando = null;
      _data = DateTime.now();
      _percentualController.clear();
      _observacaoController.clear();
    });
  }

  String _labelSalvar() {
    return _editando == null ? 'Adicionar' : 'Atualizar';
  }
}

class _MedicoesFiscalizacaoList extends StatelessWidget {
  const _MedicoesFiscalizacaoList({
    required this.medicoes,
    required this.onSelect,
  });

  final List<Medicao> medicoes;
  final ValueChanged<Medicao> onSelect;

  @override
  Widget build(BuildContext context) {
    if (medicoes.isEmpty) {
      return const Text('Nenhuma medicao cadastrada nesta fiscalizacao');
    }

    return Column(
      children: [
        for (final medicao in medicoes)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text('${medicao.percentualExecutado}% executado'),
            subtitle: Text(_subtitle(medicao)),
            trailing: const Icon(Icons.edit),
            onTap: () => onSelect(medicao),
          ),
      ],
    );
  }

  String _subtitle(Medicao medicao) {
    final data =
        '${medicao.data.day}/${medicao.data.month}/${medicao.data.year}';
    final observacao = medicao.observacao;
    if (observacao == null) {
      return data;
    }

    return '$data | $observacao';
  }
}

class _RelatorioFiscalizacaoSection extends ConsumerWidget {
  const _RelatorioFiscalizacaoSection({required this.vistoriaServicoId});

  final String vistoriaServicoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(relatoriosControllerProvider);

    ref.listen(relatoriosControllerProvider, (previous, next) {
      final relatorio = next.valueOrNull;
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
        return;
      }

      if ((previous?.isLoading ?? false) && relatorio != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF gerado: ${relatorio.caminhoArquivo}')),
        );
      }
    });

    return Align(
      alignment: Alignment.centerRight,
      child: FilledButton.icon(
        onPressed: state.isLoading
            ? null
            : () {
                ref
                    .read(relatoriosControllerProvider.notifier)
                    .gerarRelatorioFiscalizacao(vistoriaServicoId);
              },
        icon: const Icon(Icons.picture_as_pdf),
        label: Text(
          state.isLoading ? 'Gerando PDF...' : 'Gerar PDF da fiscalizacao',
        ),
      ),
    );
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
