import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_back_button.dart';
import '../domain/empresa.dart';
import 'empresas_controller.dart';

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
        loading: () => const Center(child: CircularProgressIndicator()),
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
          trailing: const Icon(Icons.edit),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => _EmpresaForm(empresa: empresa),
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
