import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract class FotosFiscalizacaoStorage {
  Future<String> salvarFotoFiscalizacao({
    required String vistoriaServicoId,
    required String caminhoOrigem,
  });
}

class ArquivoFotoFiscalizacaoInvalidoException implements Exception {
  const ArquivoFotoFiscalizacaoInvalidoException(this.caminho);

  final String caminho;

  @override
  String toString() {
    return 'Arquivo de foto invalido: $caminho';
  }
}

class LocalFotosFiscalizacaoStorage implements FotosFiscalizacaoStorage {
  const LocalFotosFiscalizacaoStorage();

  @override
  Future<String> salvarFotoFiscalizacao({
    required String vistoriaServicoId,
    required String caminhoOrigem,
  }) async {
    final arquivoOrigem = File(caminhoOrigem);
    if (!await arquivoOrigem.exists()) {
      throw ArquivoFotoFiscalizacaoInvalidoException(caminhoOrigem);
    }

    final directory = await getApplicationDocumentsDirectory();
    final fotosDir = Directory(
      p.join(directory.path, 'fotos', 'fiscalizacoes', vistoriaServicoId),
    );

    if (!await fotosDir.exists()) {
      await fotosDir.create(recursive: true);
    }

    final extensao = p.extension(caminhoOrigem);
    final nomeArquivo =
        'foto-${DateTime.now().microsecondsSinceEpoch}$extensao';
    final destino = File(p.join(fotosDir.path, nomeArquivo));

    await arquivoOrigem.copy(destino.path);
    return destino.path;
  }
}
