import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/domain/domain_enums.dart';
import '../domain/relatorio_fiscalizacao_dados.dart';
import '../domain/relatorio_obra_dados.dart';

class RelatorioPdfGenerator {
  const RelatorioPdfGenerator();

  Future<Uint8List> gerarRelatorioObra(RelatorioObraDados dados) async {
    final document = pw.Document();

    document.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.all(32),
        ),
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
            pw.Divider(),
            pw.Text('Assinatura: ________________________________'),
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
            pw.Divider(),
            pw.Text('Assinatura: ________________________________'),
          ];
        },
      ),
    );

    return document.save();
  }

  pw.Widget _obraResumo(RelatorioObraDados dados) {
    final obra = dados.obra;

    return pw.TableHelper.fromTextArray(
      headers: const ['Campo', 'Valor'],
      data: [
        ['Obra', obra.nome],
        ['Status', _statusExecucaoLabel(obra.status)],
        ['Prazo', '${obra.progressoPrazoDias} dias'],
        ['Inicio', _formatarData(obra.dataInicio)],
        ['Fim', _formatarData(obra.dataFim)],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
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

  pw.Widget _fiscalizacaoResumo(RelatorioFiscalizacaoDados dados) {
    final fiscalizacao = dados.fiscalizacao;

    return pw.TableHelper.fromTextArray(
      headers: const ['Campo', 'Valor'],
      data: [
        ['Fiscalizacao', fiscalizacao.numero],
        ['Data', _formatarData(fiscalizacao.data)],
        ['Status', _statusFiscalizacaoLabel(fiscalizacao.status)],
        ['Obra', dados.obra.nome],
        ['Etapa', dados.etapa.nome],
        ['Progresso da etapa', '${dados.etapa.progressoFisico}%'],
        ['Atividade', fiscalizacao.atividade ?? ''],
        ['Ocorrencia', fiscalizacao.ocorrencia ?? ''],
        ['Comentario', fiscalizacao.comentario ?? ''],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
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
        for (var index = 0; index < fotos.length; index++)
          _fotoEvidenciaCard(
            titulo: 'Foto ${index + 1}',
            caminhoArquivo: fotos[index].caminhoArquivo,
          ),
      ],
    );
  }

  pw.Widget _fotoEvidenciaCard({
    required String titulo,
    required String caminhoArquivo,
  }) {
    final file = File(caminhoArquivo);
    final existe = file.existsSync();

    return pw.Container(
      width: 118,
      padding: const pw.EdgeInsets.all(6),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey500),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            titulo,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          if (existe)
            pw.SizedBox(
              width: 106,
              height: 86,
              child: pw.Image(
                pw.MemoryImage(file.readAsBytesSync()),
                fit: pw.BoxFit.cover,
              ),
            )
          else
            pw.SizedBox(
              width: 106,
              height: 86,
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

  String _statusFiscalizacaoLabel(StatusFiscalizacao status) {
    return switch (status) {
      StatusFiscalizacao.emAndamento => 'Em andamento',
      StatusFiscalizacao.aprovada => 'Aprovada',
      StatusFiscalizacao.negada => 'Negada',
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
