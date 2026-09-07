import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/domain/domain_enums.dart';
import '../domain/relatorio_fiscalizacao_dados.dart';
import '../domain/relatorio_obra_dados.dart';

class RelatorioPdfGenerator {
  const RelatorioPdfGenerator();

  static const _appName = 'Operational Tracking';
  static const _appVersion = 'Versao 0.1.0';

  Future<Uint8List> gerarRelatorioObra(RelatorioObraDados dados) async {
    final document = pw.Document();

    document.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.all(32),
        ),
        footer: _footer,
        build: (context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Relatorio da obra'),
            ),
            _obraResumo(dados),
            _sectionTitle('Fiscalizacoes'),
            _fiscalizacoesTable(dados),
            _sectionTitle('Mao de obra'),
            _maoDeObraTable(dados),
            _sectionTitle('Fotos'),
            ..._fotos(dados),
            pw.SizedBox(height: 24),
            _assinatura(dados.assinatura),
          ];
        },
      ),
    );

    return document.save();
  }

  Future<Uint8List> gerarRelatorioFiscalizacao(
    RelatorioFiscalizacaoDados dados,
  ) async {
    final document = pw.Document();

    document.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.all(32),
        ),
        footer: _footer,
        build: (context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Relatorio da fiscalizacao'),
            ),
            _fiscalizacaoResumo(dados),
            _sectionTitle('Periodos'),
            _periodosTable(dados),
            _sectionTitle('Mao de obra'),
            _maoDeObraFiscalizacaoTable(dados),
            _sectionTitle('Fotos'),
            ..._fotosFiscalizacao(dados),
            pw.SizedBox(height: 24),
            _assinatura(dados.assinatura),
          ];
        },
      ),
    );

    return document.save();
  }

  pw.Widget _obraResumo(RelatorioObraDados dados) {
    final obra = dados.obra;

    return _headerResumo(
      titulo: obra.nome,
      subtitulo: 'Relatorio geral da obra',
      status: _statusExecucaoLabel(obra.status),
      statusColor: _statusExecucaoColor(obra.status),
      items: [
        _HeaderInfoItem(
          label: 'Prazo',
          value: '${obra.progressoPrazoDias} dias',
        ),
        _HeaderInfoItem(
          label: 'Inicio',
          value: _formatarData(obra.dataInicio),
        ),
        _HeaderInfoItem(
          label: 'Fim',
          value: _formatarData(obra.dataFim),
        ),
      ],
    );
  }

  pw.Widget _fiscalizacoesTable(RelatorioObraDados dados) {
    if (dados.fiscalizacoes.isEmpty) {
      return pw.Text('Nenhuma fiscalizacao cadastrada.');
    }

    return pw.TableHelper.fromTextArray(
      headers: const ['Data', 'Numero', 'Status', 'Ocorrencia', 'Comentario'],
      data: [
        for (final fiscalizacao in dados.fiscalizacoes)
          [
            _formatarData(fiscalizacao.data),
            fiscalizacao.numero,
            _statusFiscalizacaoLabel(fiscalizacao.status),
            fiscalizacao.ocorrencia ?? '',
            fiscalizacao.comentario ?? '',
          ],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  pw.Widget _maoDeObraTable(RelatorioObraDados dados) {
    if (dados.maoDeObra.isEmpty) {
      return pw.Text('Nenhuma mao de obra cadastrada.');
    }

    return pw.TableHelper.fromTextArray(
      headers: const ['Fiscalizacao', 'Funcionario', 'Funcao', 'Observacao'],
      data: [
        for (final maoDeObra in dados.maoDeObra)
          [
            maoDeObra.vistoriaServicoId,
            _funcionarioLabel(maoDeObra),
            maoDeObra.funcaoNoDia ?? '',
            maoDeObra.observacao ?? '',
          ],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  pw.Widget _headerResumo({
    required String titulo,
    required String subtitulo,
    required String status,
    required PdfColor statusColor,
    required List<_HeaderInfoItem> items,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(14),
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey900,
              borderRadius: pw.BorderRadius.only(
                topLeft: pw.Radius.circular(6),
                topRight: pw.Radius.circular(6),
              ),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        subtitulo,
                        style: const pw.TextStyle(
                          color: PdfColors.grey300,
                          fontSize: 9,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        titulo,
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    color: statusColor,
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(14),
                    ),
                  ),
                  child: pw.Text(
                    status,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in items)
                  _headerInfoCard(
                    label: item.label,
                    value: item.value,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _headerInfoCard({
    required String label,
    required String value,
  }) {
    return pw.Container(
      width: 154,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(
              color: PdfColors.grey700,
              fontSize: 8,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _fiscalizacaoResumo(RelatorioFiscalizacaoDados dados) {
    final fiscalizacao = dados.fiscalizacao;

    return _headerResumo(
      titulo: dados.obra.nome,
      subtitulo: 'Fiscalizacao ${fiscalizacao.numero}',
      status: _statusFiscalizacaoLabel(fiscalizacao.status),
      statusColor: _statusFiscalizacaoColor(fiscalizacao.status),
      items: [
        _HeaderInfoItem(
          label: 'Data',
          value: _formatarData(fiscalizacao.data),
        ),
        _HeaderInfoItem(
          label: 'Etapa',
          value: dados.etapa.nome,
        ),
        _HeaderInfoItem(
          label: 'Atividade',
          value: fiscalizacao.atividade ?? '-',
        ),
        _HeaderInfoItem(
          label: 'Ocorrencia',
          value: fiscalizacao.ocorrencia ?? '-',
        ),
        _HeaderInfoItem(
          label: 'Comentario',
          value: fiscalizacao.comentario ?? '-',
        ),
      ],
    );
  }

  pw.Widget _periodosTable(RelatorioFiscalizacaoDados dados) {
    if (dados.periodos.isEmpty) {
      return pw.Text('Nenhum periodo cadastrado.');
    }

    return pw.TableHelper.fromTextArray(
      headers: const ['Periodo', 'Tempo', 'Condicao'],
      data: [
        for (final periodo in dados.periodos)
          [
            _periodoLabel(periodo.periodo),
            _tempoLabel(periodo.tempo),
            _condicaoLabel(periodo.condicao),
          ],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  pw.Widget _maoDeObraFiscalizacaoTable(RelatorioFiscalizacaoDados dados) {
    if (dados.maoDeObra.isEmpty) {
      return pw.Text('Nenhuma mao de obra cadastrada.');
    }

    return pw.TableHelper.fromTextArray(
      headers: const ['Funcionario', 'Funcao', 'Observacao'],
      data: [
        for (final maoDeObra in dados.maoDeObra)
          [
            _funcionarioLabel(maoDeObra),
            maoDeObra.funcaoNoDia ?? '',
            maoDeObra.observacao ?? '',
          ],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  List<pw.Widget> _fotos(RelatorioObraDados dados) {
    if (dados.fotos.isEmpty) {
      return [pw.Text('Nenhuma foto cadastrada.')];
    }

    return [_fotosGrid(dados.fotos)];
  }

  List<pw.Widget> _fotosFiscalizacao(RelatorioFiscalizacaoDados dados) {
    if (dados.fotos.isEmpty) {
      return [pw.Text('Nenhuma foto cadastrada.')];
    }

    return [_fotosGrid(dados.fotos)];
  }

  pw.Widget _fotosGrid(List<RelatorioFotoInfo> fotos) {
    return pw.Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final foto in fotos)
          _fotoEvidenciaCard(
            caminhoArquivo: foto.caminhoArquivo,
            legenda: foto.legenda,
          ),
      ],
    );
  }

  pw.Widget _fotoEvidenciaCard({
    required String caminhoArquivo,
    String? legenda,
  }) {
    final file = File(caminhoArquivo);
    final existe = file.existsSync();
    final legendaNormalizada = legenda?.trim();

    return pw.Container(
      width: 160,
      padding: const pw.EdgeInsets.all(6),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey500),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (existe)
            pw.SizedBox(
              width: 148,
              height: 112,
              child: pw.Image(
                pw.MemoryImage(file.readAsBytesSync()),
                fit: pw.BoxFit.cover,
              ),
            )
          else
            pw.SizedBox(
              width: 148,
              height: 112,
              child: pw.Center(
                child: pw.Text(
                  'Foto nao encontrada',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(
                    color: PdfColors.red700,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          if (legendaNormalizada != null && legendaNormalizada.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              legendaNormalizada,
              style: const pw.TextStyle(fontSize: 8),
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _sectionTitle(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 18, bottom: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  pw.Widget _assinatura(RelatorioAssinaturaInfo? assinatura) {
    final assinaturaPath = assinatura?.assinaturaPath?.trim();
    final assinaturaFile = assinaturaPath == null || assinaturaPath.isEmpty
        ? null
        : File(assinaturaPath);
    final possuiArquivo = assinaturaFile != null && assinaturaFile.existsSync();
    final nome = assinatura?.nome.trim();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Divider(),
        pw.SizedBox(height: 18),
        if (possuiArquivo) ...[
          pw.Image(
            pw.MemoryImage(assinaturaFile.readAsBytesSync()),
            height: 58,
            fit: pw.BoxFit.contain,
          ),
          pw.SizedBox(height: 6),
        ] else
          pw.SizedBox(height: 42),
        pw.Container(
          width: 220,
          height: 1,
          color: PdfColors.grey700,
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          nome == null || nome.isEmpty ? 'Representante do contratante' : nome,
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  pw.Widget _footer(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            _appName,
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
          pw.Text(
            _appVersion,
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year}';
  }

  String _statusExecucaoLabel(StatusExecucao status) {
    return switch (status) {
      StatusExecucao.naoComecou => 'Nao comecou',
      StatusExecucao.emAndamento => 'Em andamento',
      StatusExecucao.parada => 'Parada',
      StatusExecucao.embargada => 'Embargada',
      StatusExecucao.atrasada => 'Atrasada',
      StatusExecucao.concluida => 'Concluida',
    };
  }

  PdfColor _statusExecucaoColor(StatusExecucao status) {
    return switch (status) {
      StatusExecucao.naoComecou => PdfColors.blueGrey600,
      StatusExecucao.emAndamento => PdfColors.blue700,
      StatusExecucao.parada => PdfColors.orange700,
      StatusExecucao.embargada => PdfColors.deepOrange700,
      StatusExecucao.atrasada => PdfColors.red700,
      StatusExecucao.concluida => PdfColors.green700,
    };
  }

  String _statusFiscalizacaoLabel(StatusFiscalizacao status) {
    return switch (status) {
      StatusFiscalizacao.emAndamento => 'Em andamento',
      StatusFiscalizacao.aprovada => 'Aprovada',
      StatusFiscalizacao.negada => 'Negada',
    };
  }

  PdfColor _statusFiscalizacaoColor(StatusFiscalizacao status) {
    return switch (status) {
      StatusFiscalizacao.emAndamento => PdfColors.blue700,
      StatusFiscalizacao.aprovada => PdfColors.green700,
      StatusFiscalizacao.negada => PdfColors.red700,
    };
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

  String _funcionarioLabel(RelatorioMaoDeObraInfo maoDeObra) {
    final nome = maoDeObra.funcionarioNome?.trim();
    if (nome != null && nome.isNotEmpty) {
      return nome;
    }

    return maoDeObra.funcionarioId;
  }
}

class _HeaderInfoItem {
  const _HeaderInfoItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}
