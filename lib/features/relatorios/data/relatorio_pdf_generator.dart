import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
            _sectionTitle('Servicos'),
            _servicosTable(dados),
            _sectionTitle('Medicoes'),
            _medicoesTable(dados),
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
            _sectionTitle('Medicoes'),
            _medicoesFiscalizacaoTable(dados),
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
        ['Status', obra.status.name],
        ['Progresso fisico', '${obra.progressoFisico}%'],
        ['Prazo', '${obra.progressoPrazoDias} dias'],
        ['Inicio', _formatarData(obra.dataInicio)],
        ['Fim', _formatarData(obra.dataFim)],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  pw.Widget _servicosTable(RelatorioObraDados dados) {
    if (dados.servicos.isEmpty) {
      return pw.Text('Nenhum servico cadastrado.');
    }

    return pw.TableHelper.fromTextArray(
      headers: const ['Servico', 'Status', 'Progresso', 'Quantidade', 'Custo'],
      data: [
        for (final servico in dados.servicos)
          [
            servico.nome,
            servico.status.name,
            '${servico.progressoFisico}%',
            '${servico.quantidade} ${servico.unidade}',
            servico.precoTotal.toStringAsFixed(2),
          ],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  pw.Widget _medicoesTable(RelatorioObraDados dados) {
    if (dados.medicoes.isEmpty) {
      return pw.Text('Nenhuma medicao cadastrada.');
    }

    return pw.TableHelper.fromTextArray(
      headers: const ['Data', 'Servico', 'Percentual', 'Observacao'],
      data: [
        for (final medicao in dados.medicoes)
          [
            _formatarData(medicao.data),
            medicao.servicoId,
            '${medicao.percentualExecutado}%',
            medicao.observacao ?? '',
          ],
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
            fiscalizacao.status.name,
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
            maoDeObra.funcionarioId,
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
        ['Status', fiscalizacao.status.name],
        ['Obra', dados.obra.nome],
        ['Servico', dados.servico.nome],
        ['Progresso do servico', '${dados.servico.progressoFisico}%'],
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
            periodo.periodo.name,
            periodo.tempo.name,
            periodo.condicao.name,
          ],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  pw.Widget _medicoesFiscalizacaoTable(RelatorioFiscalizacaoDados dados) {
    if (dados.medicoes.isEmpty) {
      return pw.Text('Nenhuma medicao cadastrada.');
    }

    return pw.TableHelper.fromTextArray(
      headers: const ['Data', 'Percentual', 'Observacao'],
      data: [
        for (final medicao in dados.medicoes)
          [
            _formatarData(medicao.data),
            '${medicao.percentualExecutado}%',
            medicao.observacao ?? '',
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
            maoDeObra.funcionarioId,
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

    return [
      for (final foto in dados.fotos)
        _fotoEvidenciaCard(
          titulo: 'Medicao ${foto.medicaoId}',
          caminhoArquivo: foto.caminhoArquivo,
        ),
    ];
  }

  List<pw.Widget> _fotosFiscalizacao(RelatorioFiscalizacaoDados dados) {
    if (dados.fotos.isEmpty) {
      return [pw.Text('Nenhuma foto cadastrada.')];
    }

    return [
      for (var index = 0; index < dados.fotos.length; index++)
        _fotoEvidenciaCard(
          titulo: 'Foto ${index + 1} - Medicao ${dados.fotos[index].medicaoId}',
          caminhoArquivo: dados.fotos[index].caminhoArquivo,
        ),
    ];
  }

  pw.Widget _fotoEvidenciaCard({
    required String titulo,
    required String caminhoArquivo,
  }) {
    final file = File(caminhoArquivo);
    final existe = file.existsSync();

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 14),
      padding: const pw.EdgeInsets.all(8),
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
          pw.Text(
            caminhoArquivo,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 8),
          if (existe)
            pw.Center(
              child: pw.Image(
                pw.MemoryImage(file.readAsBytesSync()),
                height: 220,
                fit: pw.BoxFit.contain,
              ),
            )
          else
            pw.Text(
              'Arquivo da foto nao encontrado no dispositivo.',
              style: const pw.TextStyle(color: PdfColors.red700),
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
}
