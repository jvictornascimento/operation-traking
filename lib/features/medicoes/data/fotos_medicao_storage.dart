import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract class FotosMedicaoStorage {
  Future<String> salvarFotoMedicao({
    required String medicaoId,
    required String caminhoOrigem,
  });
}

class ArquivoFotoInvalidoException implements Exception {
  const ArquivoFotoInvalidoException(this.caminho);

  final String caminho;

  @override
  String toString() {
    return 'Arquivo de foto invalido: $caminho';
  }
}

class LocalFotosMedicaoStorage implements FotosMedicaoStorage {
  const LocalFotosMedicaoStorage();

  @override
  Future<String> salvarFotoMedicao({
    required String medicaoId,
    required String caminhoOrigem,
  }) async {
    final arquivoOrigem = File(caminhoOrigem);
    if (!await arquivoOrigem.exists()) {
      throw ArquivoFotoInvalidoException(caminhoOrigem);
    }

    final directory = await getApplicationDocumentsDirectory();
    final fotosDir = Directory(
      p.join(directory.path, 'fotos', 'medicoes', medicaoId),
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
