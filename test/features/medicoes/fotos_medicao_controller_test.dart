import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:operational_tracking/features/medicoes/data/fotos_medicao_repository.dart';
import 'package:operational_tracking/features/medicoes/data/fotos_medicao_storage.dart';
import 'package:operational_tracking/features/medicoes/domain/foto_medicao.dart';
import 'package:operational_tracking/features/medicoes/presentation/medicoes_controller.dart';

void main() {
  group('Story 5.2 - FotosMedicaoController', () {
    test('rejeita foto sem medicao', () async {
      final repository = _FakeFotosMedicaoRepository();
      final storage = _FakeFotosMedicaoStorage();
      final controller = FotosMedicaoController(
        repository: repository,
        storage: storage,
      );

      await controller.salvarArquivo(
        medicaoId: ' ',
        caminhoOrigem: '/tmp/foto.jpg',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.fotos, isEmpty);
    });

    test('rejeita foto sem arquivo de origem', () async {
      final repository = _FakeFotosMedicaoRepository();
      final storage = _FakeFotosMedicaoStorage();
      final controller = FotosMedicaoController(
        repository: repository,
        storage: storage,
      );

      await controller.salvarArquivo(
        medicaoId: 'medicao-1',
        caminhoOrigem: ' ',
      );

      expect(controller.state, isA<AsyncError<void>>());
      expect(repository.fotos, isEmpty);
    });

    test('salva foto no storage e persiste caminho local', () async {
      final repository = _FakeFotosMedicaoRepository();
      final storage = _FakeFotosMedicaoStorage();
      final controller = FotosMedicaoController(
        repository: repository,
        storage: storage,
      );

      await controller.salvarArquivo(
        medicaoId: ' medicao-1 ',
        caminhoOrigem: ' /tmp/origem.jpg ',
      );

      expect(controller.state, isA<AsyncData<void>>());
      expect(storage.medicaoId, 'medicao-1');
      expect(storage.caminhoOrigem, '/tmp/origem.jpg');
      expect(repository.fotos, hasLength(1));
      expect(repository.fotos.single.medicaoId, 'medicao-1');
      expect(repository.fotos.single.caminhoArquivo, '/local/medicao-1.jpg');
    });

    test('remove foto da medicao', () async {
      final repository = _FakeFotosMedicaoRepository();
      final storage = _FakeFotosMedicaoStorage();
      final controller = FotosMedicaoController(
        repository: repository,
        storage: storage,
      );

      await controller.salvarArquivo(
        medicaoId: 'medicao-1',
        caminhoOrigem: '/tmp/origem.jpg',
      );
      await controller.remover(repository.fotos.single.id);

      expect(controller.state, isA<AsyncData<void>>());
      expect(repository.fotos, isEmpty);
    });
  });
}

class _FakeFotosMedicaoRepository implements FotosMedicaoRepository {
  final fotos = <FotoMedicao>[];

  @override
  Future<void> salvarFoto(FotoMedicao foto) async {
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
  Stream<List<FotoMedicao>> watchFotosDaMedicao(String medicaoId) {
    return Stream.value(
      fotos.where((foto) => foto.medicaoId == medicaoId).toList(),
    );
  }
}

class _FakeFotosMedicaoStorage implements FotosMedicaoStorage {
  String? medicaoId;
  String? caminhoOrigem;

  @override
  Future<String> salvarFotoMedicao({
    required String medicaoId,
    required String caminhoOrigem,
  }) async {
    this.medicaoId = medicaoId;
    this.caminhoOrigem = caminhoOrigem;
    return '/local/$medicaoId.jpg';
  }
}
