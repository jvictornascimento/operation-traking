import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';

import '../../../core/domain/domain_enums.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_loading.dart';
import '../../cadastros/domain/funcionario.dart';
import '../../cadastros/presentation/funcionarios_controller.dart';
import '../../relatorios/domain/relatorio.dart';
import '../../relatorios/presentation/relatorio_actions.dart';
import '../../relatorios/presentation/relatorios_controller.dart';
import '../domain/foto_fiscalizacao.dart';
import '../domain/vistoria_mao_de_obra.dart';
import '../domain/vistoria_periodo.dart';
import '../domain/vistoria_servico.dart';
import 'fiscalizacoes_controller.dart';

class FiscalizacoesPage extends ConsumerStatefulWidget {
  const FiscalizacoesPage({super.key, this.etapaId, this.servicoId});

  final String? etapaId;
  final String? servicoId;

  @override
  ConsumerState<FiscalizacoesPage> createState() => _FiscalizacoesPageState();
}

class _FiscalizacoesPageState extends ConsumerState<FiscalizacoesPage> {
  final _numeroFiltroController = TextEditingController();
  StatusFiscalizacao? _statusFiltro;
  DateTime? _dataFiltro;

  @override
  void dispose() {
    _numeroFiltroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final etapaId = widget.etapaId;
    final servicoId = widget.servicoId;
    final vistorias = ref.watch(
      fiscalizacoesFiltroStreamProvider(
        FiscalizacoesFiltro(
          etapaId: etapaId,
          servicoId: servicoId,
          numero: _numeroFiltroController.text,
          status: _statusFiltro,
          data: _dataFiltro,
        ),
      ),
    );

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
        title: Text(
          etapaId == null ? 'Fiscalizacoes' : 'Fiscalizacoes da etapa',
        ),
      ),
      body: Column(
        children: [
          _FiscalizacoesFilters(
            numeroController: _numeroFiltroController,
            status: _statusFiltro,
            data: _dataFiltro,
            onNumeroChanged: (_) => setState(() {}),
            onStatusChanged: (value) {
              setState(() => _statusFiltro = value);
            },
            onClearStatus: () => setState(() => _statusFiltro = null),
            onSelectData: _selecionarDataFiltro,
            onClearData: () => setState(() => _dataFiltro = null),
          ),
          if (widget.etapaId == null)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Para criar fiscalizacao, abra uma etapa dentro da obra.',
                ),
              ),
            ),
          Expanded(
            child: vistorias.when(
              data: (items) => _FiscalizacoesList(vistorias: items),
              loading: () => const AppLoadingPage(),
              error: (error, stackTrace) => Center(
                child: Text('Erro ao carregar fiscalizacoes: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: etapaId == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _abrirFormulario(context, etapaId: etapaId),
              icon: const Icon(Icons.add),
              label: const Text('Fiscalizacao'),
            ),
    );
  }

  Future<void> _selecionarDataFiltro() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _dataFiltro ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() => _dataFiltro = selected);
    }
  }

  Future<void> _abrirFormulario(
    BuildContext context, {
    required String etapaId,
    VistoriaServico? vistoria,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FiscalizacaoForm(
        etapaId: etapaId,
        vistoria: vistoria,
      ),
    );
  }
}

class _FiscalizacoesFilters extends StatelessWidget {
  const _FiscalizacoesFilters({
    required this.numeroController,
    required this.status,
    required this.data,
    required this.onNumeroChanged,
    required this.onStatusChanged,
    required this.onClearStatus,
    required this.onSelectData,
    required this.onClearData,
  });

  final TextEditingController numeroController;
  final StatusFiscalizacao? status;
  final DateTime? data;
  final ValueChanged<String> onNumeroChanged;
  final ValueChanged<StatusFiscalizacao?> onStatusChanged;
  final VoidCallback onClearStatus;
  final VoidCallback onSelectData;
  final VoidCallback onClearData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: numeroController,
            decoration: const InputDecoration(
              labelText: 'Buscar por numero',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: onNumeroChanged,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<StatusFiscalizacao>(
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
            items: StatusFiscalizacao.values
                .map(
                  (status) => DropdownMenuItem(
                    value: status,
                    child: Text(_statusFiscalizacaoLabel(status.name)),
                  ),
                )
                .toList(),
            onChanged: onStatusChanged,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSelectData,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                    data == null ? 'Filtrar por data' : _formatarData(data!),
                  ),
                ),
              ),
              if (data != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Limpar data',
                  icon: const Icon(Icons.clear),
                  onPressed: onClearData,
                ),
              ],
            ],
          ),
        ],
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Historico da fiscalizacao',
                icon: const Icon(Icons.history),
                onPressed: () {
                  context.push(_historicoPath('fiscalizacao', vistoria.id));
                },
              ),
              const Icon(Icons.edit),
            ],
          ),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => _FiscalizacaoForm(
              etapaId: vistoria.etapaId ?? '',
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
    return '${_formatarData(vistoria.data)} | '
        '${_statusFiscalizacaoLabel(vistoria.status.name)} | '
        'obra ${vistoria.obraId}';
  }
}

class FiscalizacoesAbertasPage extends ConsumerWidget {
  const FiscalizacoesAbertasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fiscalizacoes = ref.watch(
      fiscalizacoesFiltroStreamProvider(
        const FiscalizacoesFiltro(status: StatusFiscalizacao.emAndamento),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Fiscalizacoes em aberto'),
      ),
      body: fiscalizacoes.when(
        data: (items) => _FiscalizacoesAbertasList(fiscalizacoes: items),
        loading: () => const AppLoadingPage(),
        error: (error, stackTrace) => Center(
          child: Text('Erro ao carregar fiscalizacoes abertas: $error'),
        ),
      ),
    );
  }
}

class _FiscalizacoesAbertasList extends StatelessWidget {
  const _FiscalizacoesAbertasList({required this.fiscalizacoes});

  final List<VistoriaServico> fiscalizacoes;

  @override
  Widget build(BuildContext context) {
    if (fiscalizacoes.isEmpty) {
      return const Center(
        child: Text('Nenhuma fiscalizacao em aberto'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final fiscalizacao = fiscalizacoes[index];
        return ListTile(
          title: Text(fiscalizacao.numero),
          subtitle: Text(_subtitle(fiscalizacao)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _RelatorioFiscalizacaoExistenteButton(
                fiscalizacao: fiscalizacao,
              ),
              IconButton(
                tooltip: 'Editar fiscalizacao',
                icon: const Icon(Icons.edit),
                onPressed: () => _abrirEdicao(context, fiscalizacao),
              ),
            ],
          ),
          onTap: () => _abrirEdicao(context, fiscalizacao),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: fiscalizacoes.length,
    );
  }

  void _abrirEdicao(BuildContext context, VistoriaServico fiscalizacao) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FiscalizacaoForm(
        etapaId: fiscalizacao.etapaId ?? '',
        vistoria: fiscalizacao,
      ),
    );
  }

  String _subtitle(VistoriaServico fiscalizacao) {
    return '${_formatarData(fiscalizacao.data)} | '
        '${_statusFiscalizacaoLabel(fiscalizacao.status.name)} | '
        'etapa ${fiscalizacao.etapaId ?? '-'}';
  }
}

class _RelatorioFiscalizacaoExistenteButton extends ConsumerWidget {
  const _RelatorioFiscalizacaoExistenteButton({required this.fiscalizacao});

  final VistoriaServico fiscalizacao;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relatorio = ref.watch(
      relatorioFiscalizacaoExistenteProvider(fiscalizacao.id),
    );

    return relatorio.when(
      data: (value) {
        final encontrado = value != null;
        return IconButton(
          tooltip: encontrado
              ? 'Visualizar relatorio gerado'
              : 'Nenhum relatorio gerado',
          icon: Icon(
            Icons.visibility,
            color: encontrado ? null : Theme.of(context).disabledColor,
          ),
          onPressed: encontrado ? () => _visualizar(value) : null,
        );
      },
      loading: () => const SizedBox.square(
        dimension: 48,
        child: Padding(
          padding: EdgeInsets.all(14),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, stackTrace) {
        return const IconButton(
          tooltip: 'Erro ao localizar relatorio',
          icon: Icon(Icons.visibility_off),
          onPressed: null,
        );
      },
    );
  }

  Future<void> _visualizar(Relatorio relatorio) {
    return Printing.layoutPdf(
      onLayout: (_) => File(relatorio.caminhoArquivo).readAsBytes(),
    );
  }
}

String _historicoPath(String entidade, String entidadeId) {
  return '/historico/${Uri.encodeComponent(entidade)}/'
      '${Uri.encodeComponent(entidadeId)}';
}

String _formatarData(DateTime data) {
  return '${data.day.toString().padLeft(2, '0')}/'
      '${data.month.toString().padLeft(2, '0')}/'
      '${data.year.toString().padLeft(4, '0')}';
}

String _statusFiscalizacaoLabel(String value) {
  return switch (value) {
    'emAndamento' => 'Em andamento',
    'aprovada' => 'Aprovada',
    'negada' => 'Negada',
    _ => value,
  };
}

class _FiscalizacaoForm extends ConsumerStatefulWidget {
  const _FiscalizacaoForm({
    required this.etapaId,
    this.vistoria,
  });

  final String etapaId;
  final VistoriaServico? vistoria;

  @override
  ConsumerState<_FiscalizacaoForm> createState() => _FiscalizacaoFormState();
}

class _FiscalizacaoFormState extends ConsumerState<_FiscalizacaoForm> {
  late final TextEditingController _atividadeController;
  late final TextEditingController _ocorrenciaController;
  late final TextEditingController _comentarioController;
  late DateTime _data;
  late StatusFiscalizacao _status;
  Timer? _autoSaveTimer;
  String? _vistoriaCriadaId;
  String? _ultimaOcorrenciaSalva;
  String? _ultimoComentarioSalvo;
  bool _autoSaveHabilitado = false;
  _AutoSaveStatus _autoSaveStatus = _AutoSaveStatus.salvo;

  @override
  void initState() {
    super.initState();
    final vistoria = widget.vistoria;
    _atividadeController = TextEditingController(text: vistoria?.atividade);
    _ocorrenciaController = TextEditingController(text: vistoria?.ocorrencia);
    _comentarioController = TextEditingController(text: vistoria?.comentario);
    _data = vistoria?.data ?? DateTime.now();
    _status = vistoria?.status ?? StatusFiscalizacao.emAndamento;
    _ultimaOcorrenciaSalva = _normalizarTextoOpcional(vistoria?.ocorrencia);
    _ultimoComentarioSalvo = _normalizarTextoOpcional(vistoria?.comentario);

    if (vistoria != null) {
      _habilitarAutoSaveTextos();
    } else if (widget.etapaId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _criarFiscalizacaoInicial();
      });
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _atividadeController.dispose();
    _ocorrenciaController.dispose();
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(fiscalizacoesControllerProvider);
    final saving = controllerState.isLoading;
    final vistoria = widget.vistoria;
    final vistoriaServicoId = _vistoriaServicoIdAtual;
    final fiscalizacaoSalva = vistoriaServicoId != null;

    ref.listen(fiscalizacoesControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_mensagemErro(next.error))),
        );
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
              vistoria == null ? 'Nova fiscalizacao' : 'Editar fiscalizacao',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (controllerState.hasError) ...[
              _FormStatusMessage(
                icon: Icons.error_outline,
                text: _mensagemErro(controllerState.error),
                isError: true,
              ),
              const SizedBox(height: 12),
            ] else if (saving && !fiscalizacaoSalva) ...[
              const _FormStatusMessage(
                icon: Icons.sync,
                text: 'Preparando a fiscalizacao da etapa...',
              ),
              const SizedBox(height: 12),
            ] else if (!fiscalizacaoSalva) ...[
              const _FormStatusMessage(
                icon: Icons.info_outline,
                text: 'A fiscalizacao sera vinculada automaticamente a etapa.',
              ),
              const SizedBox(height: 12),
            ],
            _DateTile(
              label: 'Data',
              value: _data,
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
              controller: _atividadeController,
              textInputAction: TextInputAction.newline,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Atividade',
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
            if (fiscalizacaoSalva) ...[
              const SizedBox(height: 8),
              _AutoSaveTextStatus(status: _autoSaveStatus),
            ],
            if (fiscalizacaoSalva) ...[
              const SizedBox(height: 16),
              _PeriodosSection(vistoriaServicoId: vistoriaServicoId),
              const SizedBox(height: 16),
              _MaoDeObraSection(vistoriaServicoId: vistoriaServicoId),
              const SizedBox(height: 16),
              _FotosFiscalizacaoSection(vistoriaServicoId: vistoriaServicoId),
              const SizedBox(height: 16),
              _RelatorioFiscalizacaoSection(
                vistoriaServicoId: vistoriaServicoId,
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
    final novaFiscalizacao = vistoria == null && _vistoriaCriadaId == null;
    final id = vistoria?.id ?? _vistoriaCriadaId ?? _novoId();

    await ref.read(fiscalizacoesControllerProvider.notifier).salvar(
          id: id,
          etapaId: widget.etapaId,
          data: _data,
          status: _status,
          atividade: _atividadeController.text,
          ocorrencia: _ocorrenciaController.text,
          comentario: _comentarioController.text,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(fiscalizacoesControllerProvider);
    if (!state.hasError) {
      if (novaFiscalizacao) {
        setState(() {
          _vistoriaCriadaId = id;
          _autoSaveStatus = _AutoSaveStatus.salvo;
          _ultimaOcorrenciaSalva =
              _normalizarTextoOpcional(_ocorrenciaController.text);
          _ultimoComentarioSalvo =
              _normalizarTextoOpcional(_comentarioController.text);
        });
        _habilitarAutoSaveTextos();
        return;
      }

      Navigator.of(context).pop();
    }
  }

  Future<void> _criarFiscalizacaoInicial() async {
    if (!mounted || _vistoriaServicoIdAtual != null) {
      return;
    }

    await _salvar();
  }

  void _agendarAutoSaveTextos() {
    final ocorrencia = _normalizarTextoOpcional(_ocorrenciaController.text);
    final comentario = _normalizarTextoOpcional(_comentarioController.text);

    if (ocorrencia == _ultimaOcorrenciaSalva &&
        comentario == _ultimoComentarioSalvo) {
      return;
    }

    _autoSaveTimer?.cancel();
    setState(() => _autoSaveStatus = _AutoSaveStatus.pendente);
    _autoSaveTimer = Timer(
      const Duration(milliseconds: 800),
      _salvarTextosAutomaticamente,
    );
  }

  Future<void> _salvarTextosAutomaticamente() async {
    final vistoriaServicoId = _vistoriaServicoIdAtual;
    if (vistoriaServicoId == null) {
      return;
    }

    final ocorrencia = _normalizarTextoOpcional(_ocorrenciaController.text);
    final comentario = _normalizarTextoOpcional(_comentarioController.text);

    if (ocorrencia == _ultimaOcorrenciaSalva &&
        comentario == _ultimoComentarioSalvo) {
      if (mounted) {
        setState(() => _autoSaveStatus = _AutoSaveStatus.salvo);
      }
      return;
    }

    if (mounted) {
      setState(() => _autoSaveStatus = _AutoSaveStatus.salvando);
    }

    await ref.read(fiscalizacoesControllerProvider.notifier).salvarTextos(
          id: vistoriaServicoId,
          ocorrencia: ocorrencia,
          comentario: comentario,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(fiscalizacoesControllerProvider);
    if (state.hasError) {
      setState(() => _autoSaveStatus = _AutoSaveStatus.erro);
      return;
    }

    _ultimaOcorrenciaSalva = ocorrencia;
    _ultimoComentarioSalvo = comentario;
    setState(() => _autoSaveStatus = _AutoSaveStatus.salvo);
  }

  String? _normalizarTextoOpcional(String? value) {
    final texto = value?.trim();
    if (texto == null || texto.isEmpty) {
      return null;
    }
    return texto;
  }

  String? get _vistoriaServicoIdAtual =>
      widget.vistoria?.id ?? _vistoriaCriadaId;

  String _novoId() {
    return 'vistoria-${DateTime.now().microsecondsSinceEpoch}';
  }

  void _habilitarAutoSaveTextos() {
    if (_autoSaveHabilitado) {
      return;
    }

    _autoSaveHabilitado = true;
    _ocorrenciaController.addListener(_agendarAutoSaveTextos);
    _comentarioController.addListener(_agendarAutoSaveTextos);
  }

  String _mensagemErro(Object? error) {
    if (error == null) {
      return 'Nao foi possivel concluir a operacao.';
    }

    final texto = error.toString();
    return texto.replaceFirst('Invalid argument(s): ', '');
  }
}

class _FormStatusMessage extends StatelessWidget {
  const _FormStatusMessage({
    required this.icon,
    required this.text,
    this.isError = false,
  });

  final IconData icon;
  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background =
        isError ? colorScheme.errorContainer : colorScheme.secondaryContainer;
    final foreground = isError
        ? colorScheme.onErrorContainer
        : colorScheme.onSecondaryContainer;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: foreground),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _AutoSaveStatus {
  salvo,
  pendente,
  salvando,
  erro,
}

class _AutoSaveTextStatus extends StatelessWidget {
  const _AutoSaveTextStatus({required this.status});

  final _AutoSaveStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (icon, label, color) = switch (status) {
      _AutoSaveStatus.salvo => (
          Icons.check_circle_outline,
          'Textos salvos',
          colorScheme.primary,
        ),
      _AutoSaveStatus.pendente => (
          Icons.schedule,
          'Salvamento pendente',
          colorScheme.secondary,
        ),
      _AutoSaveStatus.salvando => (
          Icons.sync,
          'Salvando textos...',
          colorScheme.secondary,
        ),
      _AutoSaveStatus.erro => (
          Icons.error_outline,
          'Erro ao salvar textos',
          colorScheme.error,
        ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
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
      loading: () => const AppLoadingPage(),
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
          DropdownButtonFormField<TempoPeriodo>(
            initialValue: tempo,
            decoration: const InputDecoration(
              labelText: 'Clima',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final option in TempoPeriodo.values)
                DropdownMenuItem(
                  value: option,
                  child: Text(_tempoLabel(option)),
                ),
            ],
            onChanged: (selected) {
              if (selected != null) {
                _salvar(ref, tempo: selected, condicao: condicao);
              }
            },
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<CondicaoPeriodo>(
            initialValue: condicao,
            decoration: const InputDecoration(
              labelText: 'Condicao',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final option in CondicaoPeriodo.values)
                DropdownMenuItem(
                  value: option,
                  child: Text(_condicaoLabel(option)),
                ),
            ],
            onChanged: (selected) {
              if (selected != null) {
                _salvar(ref, tempo: tempo, condicao: selected);
              }
            },
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
  final _funcaoNoDiaController = TextEditingController();
  final _observacaoController = TextEditingController();
  String? _funcionarioId;

  @override
  void dispose() {
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
    final empresaId = ref.watch(
      empresaIdDaVistoriaProvider(widget.vistoriaServicoId),
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
          'Equipe de trabalho',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: funcionarios.when(
                data: (items) => _FuncionarioDropdown(
                  funcionarios: items,
                  value: _funcionarioId,
                  onChanged: (funcionario) {
                    setState(() {
                      _funcionarioId = funcionario?.id;
                      _funcaoNoDiaController.text = funcionario?.cargo ?? '';
                    });
                  },
                ),
                loading: () => const AppInlineLoading(),
                error: (error, stackTrace) {
                  return Text('Erro ao carregar funcionarios: $error');
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              tooltip: 'Novo funcionario',
              onPressed: empresaId.maybeWhen(
                data: (id) => id == null
                    ? null
                    : () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => _FuncionarioRapidoForm(
                            empresaId: id,
                          ),
                        ),
                orElse: () => null,
              ),
              icon: const Icon(Icons.person_add),
            ),
          ],
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
            onPressed: saving || _funcionarioId == null ? null : _salvar,
            icon: const Icon(Icons.group_add),
            label: Text(saving ? 'Salvando...' : 'Adicionar'),
          ),
        ),
        const SizedBox(height: 12),
        funcionarios.when(
          data: (funcionariosItems) => maoDeObra.when(
            data: (items) => _MaoDeObraSelecionadaList(
              maoDeObra: items,
              funcionarios: funcionariosItems,
              onRemove: (item) {
                ref
                    .read(maoDeObraFiscalizacaoControllerProvider.notifier)
                    .remover(item.id);
              },
            ),
            loading: () => const AppInlineLoading(),
            error: (error, stackTrace) {
              return Text('Erro ao carregar mao de obra: $error');
            },
          ),
          loading: () => const SizedBox.shrink(),
          error: (error, stackTrace) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Future<void> _salvar() async {
    await ref.read(maoDeObraFiscalizacaoControllerProvider.notifier).salvar(
          vistoriaServicoId: widget.vistoriaServicoId,
          funcionarioId: _funcionarioId ?? '',
          funcaoNoDia: _funcaoNoDiaController.text,
          observacao: _observacaoController.text,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(maoDeObraFiscalizacaoControllerProvider);
    if (!state.hasError) {
      setState(() => _funcionarioId = null);
      _funcaoNoDiaController.clear();
      _observacaoController.clear();
    }
  }
}

class _FuncionarioDropdown extends StatelessWidget {
  const _FuncionarioDropdown({
    required this.funcionarios,
    required this.value,
    required this.onChanged,
  });

  final List<Funcionario> funcionarios;
  final String? value;
  final ValueChanged<Funcionario?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (funcionarios.isEmpty) {
      return const Text('Nenhum funcionario da empresa encontrado');
    }

    final selected = funcionarios.any((funcionario) => funcionario.id == value)
        ? value
        : null;

    return DropdownButtonFormField<String>(
      initialValue: selected,
      decoration: const InputDecoration(
        labelText: 'Funcionario',
        border: OutlineInputBorder(),
      ),
      items: [
        for (final funcionario in funcionarios)
          DropdownMenuItem(
            value: funcionario.id,
            child: Text('${funcionario.nome} - ${funcionario.cargo}'),
          ),
      ],
      onChanged: (id) {
        final funcionario = funcionarios
            .where((item) => item.id == id)
            .cast<Funcionario?>()
            .firstOrNull;
        onChanged(funcionario);
      },
    );
  }
}

class _MaoDeObraSelecionadaList extends StatelessWidget {
  const _MaoDeObraSelecionadaList({
    required this.maoDeObra,
    required this.funcionarios,
    required this.onRemove,
  });

  final List<VistoriaMaoDeObra> maoDeObra;
  final List<Funcionario> funcionarios;
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
            title: Text(_nomeFuncionario(item.funcionarioId)),
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

  String _nomeFuncionario(String funcionarioId) {
    for (final funcionario in funcionarios) {
      if (funcionario.id == funcionarioId) {
        return funcionario.nome;
      }
    }

    return funcionarioId;
  }
}

class _FuncionarioRapidoForm extends ConsumerStatefulWidget {
  const _FuncionarioRapidoForm({required this.empresaId});

  final String empresaId;

  @override
  ConsumerState<_FuncionarioRapidoForm> createState() =>
      _FuncionarioRapidoFormState();
}

class _FuncionarioRapidoFormState
    extends ConsumerState<_FuncionarioRapidoForm> {
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cargoController = TextEditingController();

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
              'Novo funcionario',
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

class _FotosFiscalizacaoSection extends ConsumerWidget {
  const _FotosFiscalizacaoSection({required this.vistoriaServicoId});

  final String vistoriaServicoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fotos = ref.watch(fotosFiscalizacaoStreamProvider(vistoriaServicoId));
    final saving = ref.watch(fotosFiscalizacaoControllerProvider).isLoading;

    ref.listen(fotosFiscalizacaoControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_mensagemErroFoto(next.error))),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fotos',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: saving
                    ? null
                    : () => _selecionarFoto(
                          ref,
                          source: ImageSource.camera,
                        ),
                icon: const Icon(Icons.photo_camera),
                label: const Text('Tirar foto'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: saving
                    ? null
                    : () => _selecionarFoto(
                          ref,
                          source: ImageSource.gallery,
                        ),
                icon: const Icon(Icons.photo_library),
                label: const Text('Galeria'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        fotos.when(
          data: (items) => _FotosFiscalizacaoList(fotos: items),
          loading: () => const AppInlineLoading(),
          error: (error, stackTrace) {
            return Text('Erro ao carregar fotos da fiscalizacao: $error');
          },
        ),
      ],
    );
  }

  Future<void> _selecionarFoto(
    WidgetRef ref, {
    required ImageSource source,
  }) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );

    if (picked == null) {
      return;
    }

    await ref.read(fotosFiscalizacaoControllerProvider.notifier).salvarArquivo(
          vistoriaServicoId: vistoriaServicoId,
          caminhoOrigem: picked.path,
        );
  }

  String _mensagemErroFoto(Object? error) {
    if (error == null) {
      return 'Nao foi possivel salvar a foto da fiscalizacao.';
    }

    return error.toString().replaceFirst('Invalid argument(s): ', '');
  }
}

class _FotosFiscalizacaoList extends ConsumerWidget {
  const _FotosFiscalizacaoList({required this.fotos});

  final List<FotoFiscalizacao> fotos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (fotos.isEmpty) {
      return const Text('Nenhuma foto vinculada a esta fiscalizacao');
    }

    return Column(
      children: [
        for (final foto in fotos)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: _FotoFiscalizacaoPreview(
              caminhoArquivo: foto.caminhoArquivo,
            ),
            title: const Text('Foto do relatorio'),
            subtitle: Text(foto.caminhoArquivo),
            trailing: IconButton(
              tooltip: 'Remover foto',
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                ref
                    .read(fotosFiscalizacaoControllerProvider.notifier)
                    .remover(foto.id);
              },
            ),
          ),
      ],
    );
  }
}

class _FotoFiscalizacaoPreview extends StatelessWidget {
  const _FotoFiscalizacaoPreview({required this.caminhoArquivo});

  final String caminhoArquivo;

  @override
  Widget build(BuildContext context) {
    final file = File(caminhoArquivo);
    if (!file.existsSync()) {
      return const SizedBox.square(
        dimension: 48,
        child: Icon(Icons.image_not_supported),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.file(
        file,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _RelatorioFiscalizacaoSection extends ConsumerWidget {
  const _RelatorioFiscalizacaoSection({required this.vistoriaServicoId});

  final String vistoriaServicoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(relatoriosControllerProvider);
    final relatorio = state.valueOrNull?.fiscalizacaoId == vistoriaServicoId
        ? state.valueOrNull
        : null;

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
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
        ),
        if (relatorio != null) ...[
          const SizedBox(height: 12),
          RelatorioActionsCard(relatorio: relatorio),
        ],
      ],
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
