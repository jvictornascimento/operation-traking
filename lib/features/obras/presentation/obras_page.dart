import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/domain_enums.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../cadastros/domain/contratante.dart';
import '../../cadastros/domain/empresa.dart';
import '../../cadastros/domain/endereco.dart';
import '../../cadastros/presentation/contratantes_controller.dart';
import '../../cadastros/presentation/empresas_controller.dart';
import '../../cadastros/presentation/enderecos_controller.dart';
import '../domain/obra.dart';
import 'obras_controller.dart';

class ObrasPage extends ConsumerStatefulWidget {
  const ObrasPage({super.key});

  @override
  ConsumerState<ObrasPage> createState() => _ObrasPageState();
}

class _ObrasPageState extends ConsumerState<ObrasPage> {
  final _buscaController = TextEditingController();
  StatusExecucao? _statusFiltro;

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        data: (items) => Column(
          children: [
            _ObrasFilters(
              buscaController: _buscaController,
              status: _statusFiltro,
              onBuscaChanged: (_) => setState(() {}),
              onStatusChanged: (value) {
                setState(() => _statusFiltro = value);
              },
              onClearStatus: () => setState(() => _statusFiltro = null),
            ),
            Expanded(
              child: _ObrasList(
                obras: _filtrarObras(items),
                onEdit: (obra) => _abrirFormulario(context, obra: obra),
              ),
            ),
          ],
        ),
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

  List<Obra> _filtrarObras(List<Obra> obras) {
    final busca = _buscaController.text.trim().toLowerCase();

    return obras.where((obra) {
      final combinaBusca =
          busca.isEmpty || obra.nome.toLowerCase().contains(busca);
      final combinaStatus =
          _statusFiltro == null || obra.status == _statusFiltro;

      return combinaBusca && combinaStatus;
    }).toList();
  }
}

class _ObrasFilters extends StatelessWidget {
  const _ObrasFilters({
    required this.buscaController,
    required this.status,
    required this.onBuscaChanged,
    required this.onStatusChanged,
    required this.onClearStatus,
  });

  final TextEditingController buscaController;
  final StatusExecucao? status;
  final ValueChanged<String> onBuscaChanged;
  final ValueChanged<StatusExecucao?> onStatusChanged;
  final VoidCallback onClearStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          TextField(
            controller: buscaController,
            decoration: const InputDecoration(
              labelText: 'Buscar obra',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: onBuscaChanged,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<StatusExecucao>(
            initialValue: status,
            decoration: InputDecoration(
              labelText: 'Status',
              border: const OutlineInputBorder(),
              suffixIcon: status == null
                  ? null
                  : IconButton(
                      tooltip: 'Limpar status',
                      icon: const Icon(Icons.clear),
                      onPressed: onClearStatus,
                    ),
            ),
            items: StatusExecucao.values
                .map(
                  (status) => DropdownMenuItem(
                    value: status,
                    child: Text(_statusExecucaoLabel(status.name)),
                  ),
                )
                .toList(),
            onChanged: onStatusChanged,
          ),
        ],
      ),
    );
  }
}

class _ObrasList extends StatelessWidget {
  const _ObrasList({
    required this.obras,
    required this.onEdit,
  });

  final List<Obra> obras;
  final ValueChanged<Obra> onEdit;

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
          trailing: IconButton(
            tooltip: 'Editar obra',
            icon: const Icon(Icons.edit),
            onPressed: () => onEdit(obra),
          ),
          onTap: () => context.push('/obras/${obra.id}'),
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

    return '${_statusExecucaoLabel(obra.status.name)} | $prazoTexto | '
        '${obra.progressoFisico}%';
  }
}

String _statusExecucaoLabel(String value) {
  return switch (value) {
    'naoComecou' => 'Nao comecou',
    'emAndamento' => 'Em andamento',
    'parada' => 'Parada',
    'embargada' => 'Embargada',
    'atrasada' => 'Atrasada',
    'concluida' => 'Concluida',
    _ => value,
  };
}

class _ObraForm extends ConsumerStatefulWidget {
  const _ObraForm({this.obra});

  final Obra? obra;

  @override
  ConsumerState<_ObraForm> createState() => _ObraFormState();
}

class _ObraFormState extends ConsumerState<_ObraForm> {
  late final TextEditingController _nomeController;
  late final TextEditingController _numeroContratoController;
  late final TextEditingController _valorContratoController;
  late final TextEditingController _responsavelNomeController;
  late final TextEditingController _responsavelContatoController;
  late final TextEditingController _enderecoTipoController;
  late final TextEditingController _cepController;
  late final TextEditingController _logradouroController;
  late final TextEditingController _numeroController;
  late final TextEditingController _complementoController;
  late final TextEditingController _bairroController;
  late final TextEditingController _cidadeController;
  late final TextEditingController _estadoController;
  late final TextEditingController _paisController;
  String? _empresaId;
  String? _contratanteId;
  String? _enderecoId;
  late DateTime _dataInicio;
  late DateTime _dataFim;
  late StatusExecucao _status;
  bool _enderecoCarregado = false;

  @override
  void initState() {
    super.initState();
    final obra = widget.obra;
    _nomeController = TextEditingController(text: obra?.nome);
    _numeroContratoController = TextEditingController(
      text: obra?.numeroContrato,
    );
    _valorContratoController = TextEditingController(
      text: obra?.valorContrato?.toStringAsFixed(2).replaceAll('.', ','),
    );
    _responsavelNomeController = TextEditingController(
      text: obra?.responsavelNome,
    );
    _responsavelContatoController = TextEditingController(
      text: obra?.responsavelContato,
    );
    _enderecoTipoController = TextEditingController(text: 'Principal');
    _cepController = TextEditingController();
    _logradouroController = TextEditingController();
    _numeroController = TextEditingController();
    _complementoController = TextEditingController();
    _bairroController = TextEditingController();
    _cidadeController = TextEditingController();
    _estadoController = TextEditingController();
    _paisController = TextEditingController(text: 'Brasil');
    _empresaId = obra?.empresaId;
    _contratanteId = obra?.contratanteId;
    _enderecoId = obra?.enderecoId;
    _dataInicio = obra?.dataInicio ?? DateTime.now();
    _dataFim = obra?.dataFim ?? DateTime.now();
    _status = obra?.status ?? StatusExecucao.naoComecou;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _numeroContratoController.dispose();
    _valorContratoController.dispose();
    _responsavelNomeController.dispose();
    _responsavelContatoController.dispose();
    _enderecoTipoController.dispose();
    _cepController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _paisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(obrasControllerProvider).isLoading;
    final empresas = ref.watch(empresasStreamProvider);
    final contratantes = ref.watch(contratantesStreamProvider);
    final endereco = widget.obra == null
        ? const AsyncData(<Endereco>[])
        : ref.watch(
            enderecosStreamProvider(
              EnderecosFiltro(
                entidade: TipoEntidadeEndereco.obra,
                entidadeId: widget.obra!.id,
              ),
            ),
          );

    endereco.whenData((items) {
      if (!_enderecoCarregado && items.isNotEmpty) {
        _preencherEndereco(items.first);
      }
    });

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
              controller: _nomeController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _numeroContratoController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Numero do contrato',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valorContratoController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Valor do contrato',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            empresas.when(
              data: (items) => _EmpresaDropdown(
                empresas: items,
                value: _empresaId,
                onChanged: (value) => setState(() => _empresaId = value),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, stackTrace) {
                return Text('Erro ao carregar empresas: $error');
              },
            ),
            const SizedBox(height: 12),
            contratantes.when(
              data: (items) => _ContratanteDropdown(
                contratantes: items,
                value: _contratanteId,
                onChanged: (value) => setState(() => _contratanteId = value),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, stackTrace) {
                return Text('Erro ao carregar contratantes: $error');
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _responsavelNomeController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Responsavel da obra',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _responsavelContatoController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Contato do responsavel',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Endereco da obra',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _enderecoTipoController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cidadeController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 96,
                  child: TextField(
                    controller: _estadoController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _logradouroController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Logradouro',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _numeroController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Numero',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _cepController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'CEP',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bairroController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Bairro',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _complementoController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Complemento',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _paisController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Pais',
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
          empresaId: _empresaId ?? '',
          contratanteId: _contratanteId,
          enderecoId: _enderecoId,
          nome: _nomeController.text,
          numeroContrato: _numeroContratoController.text,
          valorContrato: _valorContratoController.text,
          responsavelNome: _responsavelNomeController.text,
          responsavelContato: _responsavelContatoController.text,
          dataInicio: _dataInicio,
          dataFim: _dataFim,
          status: _status,
          enderecoTipo: _enderecoTipoController.text,
          enderecoCep: _cepController.text,
          enderecoLogradouro: _logradouroController.text,
          enderecoNumero: _numeroController.text,
          enderecoComplemento: _complementoController.text,
          enderecoBairro: _bairroController.text,
          enderecoCidade: _cidadeController.text,
          enderecoEstado: _estadoController.text,
          enderecoPais: _paisController.text,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(obrasControllerProvider);
    if (!state.hasError) {
      Navigator.of(context).pop();
    }
  }

  void _preencherEndereco(Endereco endereco) {
    _enderecoCarregado = true;
    _enderecoId = endereco.id;
    _enderecoTipoController.text = endereco.tipo;
    _cepController.text = endereco.cep ?? '';
    _logradouroController.text = endereco.logradouro ?? '';
    _numeroController.text = endereco.numero ?? '';
    _complementoController.text = endereco.complemento ?? '';
    _bairroController.text = endereco.bairro ?? '';
    _cidadeController.text = endereco.cidade;
    _estadoController.text = endereco.estado;
    _paisController.text = endereco.pais;
  }
}

class _EmpresaDropdown extends StatelessWidget {
  const _EmpresaDropdown({
    required this.empresas,
    required this.value,
    required this.onChanged,
  });

  final List<Empresa> empresas;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (empresas.isEmpty) {
      return const Text('Cadastre uma empresa antes de criar a obra.');
    }

    final selected =
        empresas.any((empresa) => empresa.id == value) ? value : null;

    return DropdownButtonFormField<String>(
      initialValue: selected,
      decoration: const InputDecoration(
        labelText: 'Empresa',
        border: OutlineInputBorder(),
      ),
      items: [
        for (final empresa in empresas)
          DropdownMenuItem(
            value: empresa.id,
            child: Text(empresa.nome),
          ),
      ],
      onChanged: onChanged,
    );
  }
}

class _ContratanteDropdown extends StatelessWidget {
  const _ContratanteDropdown({
    required this.contratantes,
    required this.value,
    required this.onChanged,
  });

  final List<Contratante> contratantes;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (contratantes.isEmpty) {
      return const Text('Cadastre um contratante antes de criar a obra.');
    }

    final selected = contratantes.any((contratante) => contratante.id == value)
        ? value
        : null;

    return DropdownButtonFormField<String>(
      initialValue: selected,
      decoration: const InputDecoration(
        labelText: 'Contratante',
        border: OutlineInputBorder(),
      ),
      items: [
        for (final contratante in contratantes)
          DropdownMenuItem(
            value: contratante.id,
            child: Text(contratante.nome),
          ),
      ],
      onChanged: onChanged,
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
