import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:belis_oversight/features/fiscalizacoes/data/fotos_fiscalizacao_repository.dart';
import 'package:belis_oversight/features/fiscalizacoes/data/fotos_fiscalizacao_storage.dart';
import 'package:belis_oversight/features/fiscalizacoes/domain/foto_fiscalizacao.dart';
import 'package:belis_oversight/features/fiscalizacoes/presentation/fiscalizacoes_controller.dart';

void main() {
  group('Issue 28 - FotosFiscalizacaoController', () {
    test('rejeita foto sem fiscalizacao', () async {
      final repository = _FakeFotosFiscalizacaoRepository();
      final storage = _FakeFotosFiscalizacaoStorage();
      final controller = FotosFiscalizacaoController(
        repository: repository,
        storage: storage,
      );

      await controller.salvarArquivo(
        vistoriaServicoId: ' ',
        caminhoOrigem: '/tmp/foto.jpg',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.fotos, isEmpty);
    });

    test('rejeita foto sem arquivo de origem', () async {
      final repository = _FakeFotosFiscalizacaoRepository();
      final storage = _FakeFotosFiscalizacaoStorage();
      final controller = FotosFiscalizacaoController(
        repository: repository,
        storage: storage,
      );

      await controller.salvarArquivo(
        vistoriaServicoId: 'vistoria-1',
        caminhoOrigem: ' ',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.fotos, isEmpty);
    });

    test('salva foto da camera com uri da galeria e legenda opcional',
        () async {
      final repository = _FakeFotosFiscalizacaoRepository();
      final storage = _FakeFotosFiscalizacaoStorage();
      final controller = FotosFiscalizacaoController(
        repository: repository,
        storage: storage,
      );

      await controller.salvarArquivo(
        vistoriaServicoId: ' vistoria-1 ',
        caminhoOrigem: ' /tmp/origem.jpg ',
        publicarNaGaleria: true,
        legenda: ' Frente norte ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(storage.vistoriaServicoId, 'vistoria-1');
      expect(storage.caminhoOrigem, '/tmp/origem.jpg');
      expect(storage.publicarNaGaleria, isTrue);
      expect(repository.fotos, hasLength(1));
      expect(repository.fotos.single.vistoriaServicoId, 'vistoria-1');
      expect(repository.fotos.single.caminhoArquivo, '/local/vistoria-1.jpg');
      expect(repository.fotos.single.uriGaleria, 'photo_manager://asset/123');
      expect(repository.fotos.single.legenda, 'Frente norte');
    });

    test('salva foto selecionada da galeria sem publicar duplicata', () async {
      final repository = _FakeFotosFiscalizacaoRepository();
      final storage = _FakeFotosFiscalizacaoStorage();
      final controller = FotosFiscalizacaoController(
        repository: repository,
        storage: storage,
      );

      await controller.salvarArquivo(
        vistoriaServicoId: 'vistoria-1',
        caminhoOrigem: '/tmp/origem.jpg',
        publicarNaGaleria: false,
        legenda: ' ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(storage.publicarNaGaleria, isFalse);
      expect(repository.fotos.single.uriGaleria, isNull);
      expect(repository.fotos.single.legenda, isNull);
    });

    test('remove foto da fiscalizacao', () async {
      final repository = _FakeFotosFiscalizacaoRepository();
      final storage = _FakeFotosFiscalizacaoStorage();
      final controller = FotosFiscalizacaoController(
        repository: repository,
        storage: storage,
      );

      await controller.salvarArquivo(
        vistoriaServicoId: 'vistoria-1',
        caminhoOrigem: '/tmp/origem.jpg',
      );
      await controller.remover(repository.fotos.single.id);

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.fotos, isEmpty);
    });
  });
}

class _FakeFotosFiscalizacaoRepository implements FotosFiscalizacaoRepository {
  final fotos = <FotoFiscalizacao>[];

  @override
  Future<void> salvarFoto(FotoFiscalizacao foto) async {
    final index = fotos.indexWhere((item) => item.id == foto.id);
    if (index == -1) {
      fotos.add(foto);
      return;
    }

    fotos[index] = foto;
  }

  @override
  Future<void> removerFoto(String id) async {
    fotos.removeWhere((foto) => foto.id == id);
  }

  @override
  Stream<List<FotoFiscalizacao>> watchFotosDaFiscalizacao(
    String vistoriaServicoId,
  ) {
    return Stream.value(
      fotos
          .where((foto) => foto.vistoriaServicoId == vistoriaServicoId)
          .toList(),
    );
  }
}

class _FakeFotosFiscalizacaoStorage implements FotosFiscalizacaoStorage {
  String? vistoriaServicoId;
  String? caminhoOrigem;
  bool? publicarNaGaleria;

  @override
  Future<FotoFiscalizacaoStorageResult> salvarFotoFiscalizacao({
    required String vistoriaServicoId,
    required String caminhoOrigem,
    required bool publicarNaGaleria,
  }) async {
    this.vistoriaServicoId = vistoriaServicoId;
    this.caminhoOrigem = caminhoOrigem;
    this.publicarNaGaleria = publicarNaGaleria;

    return FotoFiscalizacaoStorageResult(
      caminhoArquivo: '/local/$vistoriaServicoId.jpg',
      uriGaleria: publicarNaGaleria ? 'photo_manager://asset/123' : null,
    );
  }
}
