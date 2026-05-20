import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/contratante.dart';
import 'contratantes_controller.dart';

class ContratantesPage extends ConsumerWidget {
  const ContratantesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contratantes = ref.watch(contratantesStreamProvider);
    ref.listen(contratantesControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Contratantes')),
      body: contratantes.when(
        data: (items) => _ContratantesList(contratantes: items),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Erro ao carregar contratantes: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(context),
        icon: const Icon(Icons.add),
        label: const Text('Contratante'),
      ),
    );
  }

  Future<void> _abrirFormulario(
    BuildContext context, {
    Contratante? contratante,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ContratanteForm(contratante: contratante),
    );
  }
}

class _ContratantesList extends StatelessWidget {
  const _ContratantesList({required this.contratantes});

  final List<Contratante> contratantes;

  @override
  Widget build(BuildContext context) {
    if (contratantes.isEmpty) {
      return const Center(
        child: Text('Nenhum contratante cadastrado'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final contratante = contratantes[index];
        return ListTile(
          title: Text(contratante.nome),
          subtitle: Text(_subtitle(contratante)),
          trailing: const Icon(Icons.edit),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => _ContratanteForm(contratante: contratante),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: contratantes.length,
    );
  }

  String _subtitle(Contratante contratante) {
    final dados = [
      if (contratante.cnpj != null) 'CNPJ: ${contratante.cnpj}',
      if (contratante.ie != null) 'IE: ${contratante.ie}',
    ];

    if (dados.isEmpty) {
      return 'Sem CNPJ ou IE';
    }

    return dados.join(' | ');
  }
}

class _ContratanteForm extends ConsumerStatefulWidget {
  const _ContratanteForm({this.contratante});

  final Contratante? contratante;

  @override
  ConsumerState<_ContratanteForm> createState() => _ContratanteFormState();
}

class _ContratanteFormState extends ConsumerState<_ContratanteForm> {
  late final TextEditingController _nomeController;
  late final TextEditingController _cnpjController;
  late final TextEditingController _ieController;

  @override
  void initState() {
    super.initState();
    final contratante = widget.contratante;
    _nomeController = TextEditingController(text: contratante?.nome);
    _cnpjController = TextEditingController(text: contratante?.cnpj);
    _ieController = TextEditingController(text: contratante?.ie);
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
    final saving = ref.watch(contratantesControllerProvider).isLoading;

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
              widget.contratante == null
                  ? 'Novo contratante'
                  : 'Editar contratante',
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
    await ref.read(contratantesControllerProvider.notifier).salvar(
          id: widget.contratante?.id,
          nome: _nomeController.text,
          cnpj: _cnpjController.text,
          ie: _ieController.text,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(contratantesControllerProvider);
    if (!state.hasError) {
      Navigator.of(context).pop();
    }
  }
}
