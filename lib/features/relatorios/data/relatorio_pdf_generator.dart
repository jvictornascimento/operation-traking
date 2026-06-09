import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

  List<pw.Widget> _fotos(RelatorioObraDados dados) {
    if (dados.fotos.isEmpty) {
      return [pw.Text('Nenhuma foto cadastrada.')];
    }

    final widgets = <pw.Widget>[];
    for (final foto in dados.fotos) {
      final file = File(foto.caminhoArquivo);
      widgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Text('Medicao ${foto.medicaoId}: ${foto.caminhoArquivo}'),
        ),
      );

      if (file.existsSync()) {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 12),
            child: pw.Image(
              pw.MemoryImage(file.readAsBytesSync()),
              height: 180,
              fit: pw.BoxFit.contain,
            ),
          ),
        );
      }
    }

    return widgets;
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
