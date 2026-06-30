import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_loading.dart';
import '../domain/empresa.dart';
import '../domain/funcionario.dart';
import 'empresas_controller.dart';
import 'funcionarios_controller.dart';

class EmpresasPage extends ConsumerWidget {
  const EmpresasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final empresas = ref.watch(empresasStreamProvider);
    ref.listen(empresasControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Empresas'),
      ),
      body: empresas.when(
        data: (items) => _EmpresasList(empresas: items),
        loading: () => const AppLoadingPage(),
        error: (error, stackTrace) => Center(
          child: Text('Erro ao carregar empresas: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(context),
        icon: const Icon(Icons.add),
        label: const Text('Empresa'),
      ),
    );
  }

  Future<void> _abrirFormulario(BuildContext context, {Empresa? empresa}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EmpresaForm(empresa: empresa),
    );
  }
}

class _EmpresasList extends StatelessWidget {
  const _EmpresasList({required this.empresas});

  final List<Empresa> empresas;

  @override
  Widget build(BuildContext context) {
    if (empresas.isEmpty) {
      return const Center(
        child: Text('Nenhuma empresa cadastrada'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final empresa = empresas[index];
        return ListTile(
          title: Text(empresa.nome),
          subtitle: Text(_subtitle(empresa)),
          trailing: IconButton(
            tooltip: 'Editar empresa',
            icon: const Icon(Icons.edit),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (context) => _EmpresaForm(empresa: empresa),
            ),
          ),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => _EmpresaDetalheSheet(empresa: empresa),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: empresas.length,
    );
  }

  String _subtitle(Empresa empresa) {
    final dados = [
      if (empresa.cnpj != null) 'CNPJ: ${empresa.cnpj}',
      if (empresa.ie != null) 'IE: ${empresa.ie}',
    ];

    if (dados.isEmpty) {
      return 'Sem CNPJ ou IE';
    }

    return dados.join(' | ');
  }
}

class _EmpresaDetalheSheet extends StatelessWidget {
  const _EmpresaDetalheSheet({required this.empresa});

  final Empresa empresa;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.88,
        minChildSize: 0.55,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      empresa.nome,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Editar empresa',
                    icon: const Icon(Icons.edit),
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => _EmpresaForm(empresa: empresa),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(_dadosEmpresa(empresa)),
              const SizedBox(height: 20),
              _FuncionariosEmpresaSection(empresaId: empresa.id),
            ],
          );
        },
      ),
    );
  }

  String _dadosEmpresa(Empresa empresa) {
    final dados = [
      if (empresa.cnpj != null) 'CNPJ: ${empresa.cnpj}',
      if (empresa.ie != null) 'IE: ${empresa.ie}',
    ];

    if (dados.isEmpty) {
      return 'Sem CNPJ ou IE';
    }

    return dados.join(' | ');
  }
}

class _FuncionariosEmpresaSection extends ConsumerWidget {
  const _FuncionariosEmpresaSection({required this.empresaId});

  final String empresaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final funcionarios =
        ref.watch(funcionariosEmpresaStreamProvider(empresaId));

    ref.listen(funcionariosControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Funcionarios',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            FilledButton.icon(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (context) => _FuncionarioEmpresaForm(
                  empresaId: empresaId,
                ),
              ),
              icon: const Icon(Icons.person_add),
              label: const Text('Funcionario'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        funcionarios.when(
          data: (items) {
            if (items.isEmpty) {
              return const Text('Nenhum funcionario cadastrado');
            }

            return Column(
              children: [
                for (final funcionario in items)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(funcionario.nome),
                    subtitle: Text(_subtitle(funcionario)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Editar funcionario',
                          icon: const Icon(Icons.edit),
                          onPressed: () => showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => _FuncionarioEmpresaForm(
                              empresaId: empresaId,
                              funcionario: funcionario,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remover funcionario',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => ref
                              .read(funcionariosControllerProvider.notifier)
                              .remover(funcionario.id),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
          loading: () => const AppInlineLoading(),
          error: (error, stackTrace) {
            return Text('Erro ao carregar funcionarios: $error');
          },
        ),
      ],
    );
  }

  String _subtitle(Funcionario funcionario) {
    final dados = [
      funcionario.cargo,
      if (funcionario.telefone != null) funcionario.telefone,
    ];

    return dados.join(' | ');
  }
}

class _FuncionarioEmpresaForm extends ConsumerStatefulWidget {
  const _FuncionarioEmpresaForm({
    required this.empresaId,
    this.funcionario,
  });

  final String empresaId;
  final Funcionario? funcionario;

  @override
  ConsumerState<_FuncionarioEmpresaForm> createState() =>
      _FuncionarioEmpresaFormState();
}

class _FuncionarioEmpresaFormState
    extends ConsumerState<_FuncionarioEmpresaForm> {
  late final TextEditingController _nomeController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _cargoController;

  @override
  void initState() {
    super.initState();
    final funcionario = widget.funcionario;
    _nomeController = TextEditingController(text: funcionario?.nome);
    _telefoneController = TextEditingController(text: funcionario?.telefone);
    _cargoController = TextEditingController(text: funcionario?.cargo);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _cargoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(funcionariosControllerProvider).isLoading;

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
              widget.funcionario == null
                  ? 'Novo funcionario'
                  : 'Editar funcionario',
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
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cargoController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Cargo',
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

  Future<void> _salvar() async {
    await ref.read(funcionariosControllerProvider.notifier).salvar(
          id: widget.funcionario?.id,
          empresaId: widget.empresaId,
          nome: _nomeController.text,
          telefone: _telefoneController.text,
          cargo: _cargoController.text,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(funcionariosControllerProvider);
    if (!state.hasError) {
      Navigator.of(context).pop();
    }
  }
}

class _EmpresaForm extends ConsumerStatefulWidget {
  const _EmpresaForm({this.empresa});

  final Empresa? empresa;

  @override
  ConsumerState<_EmpresaForm> createState() => _EmpresaFormState();
}

class _EmpresaFormState extends ConsumerState<_EmpresaForm> {
  late final TextEditingController _nomeController;
  late final TextEditingController _cnpjController;
  late final TextEditingController _ieController;

  @override
  void initState() {
    super.initState();
    final empresa = widget.empresa;
    _nomeController = TextEditingController(text: empresa?.nome);
    _cnpjController = TextEditingController(text: empresa?.cnpj);
    _ieController = TextEditingController(text: empresa?.ie);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cnpjController.dispose();
    _ieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(empresasControllerProvider).isLoading;

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
              widget.empresa == null ? 'Nova empresa' : 'Editar empresa',
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
              controller: _cnpjController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'CNPJ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ieController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'IE',
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

  Future<void> _salvar() async {
    await ref.read(empresasControllerProvider.notifier).salvar(
          id: widget.empresa?.id,
          nome: _nomeController.text,
          cnpj: _cnpjController.text,
          ie: _ieController.text,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(empresasControllerProvider);
    if (!state.hasError) {
      Navigator.of(context).pop();
    }
  }
}
