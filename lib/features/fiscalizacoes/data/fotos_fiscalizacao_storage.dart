import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class FotosFiscalizacaoStorage {
  Future<FotoFiscalizacaoStorageResult> salvarFotoFiscalizacao({
    required String vistoriaServicoId,
    required String caminhoOrigem,
    required bool publicarNaGaleria,
  });
}

class FotoFiscalizacaoStorageResult {
  const FotoFiscalizacaoStorageResult({
    required this.caminhoArquivo,
    this.uriGaleria,
  });

  final String caminhoArquivo;
  final String? uriGaleria;
}

abstract class FotosFiscalizacaoGaleria {
  Future<String> publicarFoto({
    required String caminhoArquivo,
    required String titulo,
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

class PermissaoGaleriaFotosNegadaException implements Exception {
  const PermissaoGaleriaFotosNegadaException();

  @override
  String toString() {
    return 'Permissao para salvar a foto na galeria foi negada.';
  }
}

class PhotoManagerFotosFiscalizacaoGaleria implements FotosFiscalizacaoGaleria {
  const PhotoManagerFotosFiscalizacaoGaleria();

  @override
  Future<String> publicarFoto({
    required String caminhoArquivo,
    required String titulo,
  }) async {
    final permission = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        androidPermission: AndroidPermission(
          type: RequestType.image,
          mediaLocation: false,
        ),
      ),
    );

    if (!permission.hasAccess) {
      throw const PermissaoGaleriaFotosNegadaException();
    }

    final asset = await PhotoManager.editor.saveImageWithPath(
      caminhoArquivo,
      title: titulo,
      relativePath: 'Pictures/belis-oversight',
    );

    return 'photo_manager://asset/${Uri.encodeComponent(asset.id)}';
  }
}

class LocalFotosFiscalizacaoStorage implements FotosFiscalizacaoStorage {
  const LocalFotosFiscalizacaoStorage({
    FotosFiscalizacaoGaleria? galeria,
  }) : _galeria = galeria;

  final FotosFiscalizacaoGaleria? _galeria;

  @override
  Future<FotoFiscalizacaoStorageResult> salvarFotoFiscalizacao({
    required String vistoriaServicoId,
    required String caminhoOrigem,
    required bool publicarNaGaleria,
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
    final uriGaleria = publicarNaGaleria
        ? await (_galeria ?? const PhotoManagerFotosFiscalizacaoGaleria())
            .publicarFoto(
            caminhoArquivo: destino.path,
            titulo: nomeArquivo,
          )
        : null;

    return FotoFiscalizacaoStorageResult(
      caminhoArquivo: destino.path,
      uriGaleria: uriGaleria,
    );
  }
}
