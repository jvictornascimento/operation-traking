import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_loading.dart';
import '../domain/contratante.dart';
import '../domain/funcionario.dart';
import 'contratantes_controller.dart';
import 'funcionarios_controller.dart';

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
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Contratantes'),
      ),
      body: contratantes.when(
        data: (items) => _ContratantesList(contratantes: items),
        loading: () => const AppLoadingPage(),
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
          trailing: IconButton(
            tooltip: 'Editar contratante',
            icon: const Icon(Icons.edit),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (context) => _ContratanteForm(contratante: contratante),
            ),
          ),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => _ContratanteDetalheSheet(
              contratante: contratante,
            ),
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

class _ContratanteDetalheSheet extends StatelessWidget {
  const _ContratanteDetalheSheet({required this.contratante});

  final Contratante contratante;

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
                      contratante.nome,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Editar contratante',
                    icon: const Icon(Icons.edit),
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => _ContratanteForm(
                        contratante: contratante,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(_dadosContratante(contratante)),
              const SizedBox(height: 20),
              _FuncionariosContratanteSection(
                contratanteId: contratante.id,
              ),
            ],
          );
        },
      ),
    );
  }

  String _dadosContratante(Contratante contratante) {
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

class _FuncionariosContratanteSection extends ConsumerWidget {
  const _FuncionariosContratanteSection({required this.contratanteId});

  final String contratanteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final funcionarios = ref.watch(
      funcionariosContratanteStreamProvider(contratanteId),
    );

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
                builder: (context) => _FuncionarioContratanteForm(
                  contratanteId: contratanteId,
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
                            builder: (context) => _FuncionarioContratanteForm(
                              contratanteId: contratanteId,
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
      if (funcionario.assinaturaPath != null)
        'Assinatura PNG cadastrada'
      else
        'Sem assinatura',
    ];

    return dados.join(' | ');
  }
}

class _FuncionarioContratanteForm extends ConsumerStatefulWidget {
  const _FuncionarioContratanteForm({
    required this.contratanteId,
    this.funcionario,
  });

  final String contratanteId;
  final Funcionario? funcionario;

  @override
  ConsumerState<_FuncionarioContratanteForm> createState() =>
      _FuncionarioContratanteFormState();
}

class _FuncionarioContratanteFormState
    extends ConsumerState<_FuncionarioContratanteForm> {
  late final TextEditingController _nomeController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _cargoController;
  String? _assinaturaPath;

  @override
  void initState() {
    super.initState();
    final funcionario = widget.funcionario;
    _nomeController = TextEditingController(text: funcionario?.nome);
    _telefoneController = TextEditingController(text: funcionario?.telefone);
    _cargoController = TextEditingController(text: funcionario?.cargo);
    _assinaturaPath = funcionario?.assinaturaPath;
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
    final possuiAssinatura = _assinaturaPath != null;

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
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: saving ? null : _selecionarAssinatura,
              icon: const Icon(Icons.upload_file),
              label: Text(
                possuiAssinatura ? 'Trocar assinatura PNG' : 'Assinatura PNG',
              ),
            ),
            if (possuiAssinatura) ...[
              const SizedBox(height: 8),
              Text(
                'Assinatura PNG cadastrada',
                style: Theme.of(context).textTheme.bodySmall,
              ),
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

  Future<void> _selecionarAssinatura() async {
    final imagem = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagem == null) {
      return;
    }

    final extensao = p.extension(imagem.path).toLowerCase();
    if (extensao != '.png') {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um arquivo PNG para a assinatura.'),
        ),
      );
      return;
    }

    final caminho = await _copiarAssinaturaParaStorage(imagem);
    if (!mounted) {
      return;
    }

    setState(() {
      _assinaturaPath = caminho;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Assinatura PNG adicionada.')),
    );
  }

  Future<String> _copiarAssinaturaParaStorage(XFile imagem) async {
    final baseDir = await getApplicationDocumentsDirectory();
    final dir = Directory(
      p.join(
        baseDir.path,
        'assinaturas',
        'contratantes',
        widget.contratanteId,
      ),
    );

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final nomeArquivo =
        'assinatura-${DateTime.now().microsecondsSinceEpoch}.png';
    final destino = p.join(dir.path, nomeArquivo);
    await File(imagem.path).copy(destino);
    return destino;
  }

  Future<void> _salvar() async {
    await ref.read(funcionariosControllerProvider.notifier).salvar(
          id: widget.funcionario?.id,
          contratanteId: widget.contratanteId,
          nome: _nomeController.text,
          telefone: _telefoneController.text,
          cargo: _cargoController.text,
          assinaturaPath: _assinaturaPath,
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
