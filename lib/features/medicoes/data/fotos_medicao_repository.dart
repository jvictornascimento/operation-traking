import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../domain/foto_medicao.dart';

abstract class FotosMedicaoRepository {
  Stream<List<FotoMedicao>> watchFotosDaMedicao(String medicaoId);

  Future<void> salvarFoto(FotoMedicao foto);

  Future<void> removerFoto(String id);
}

class CaminhoFotoVazioException implements Exception {
  const CaminhoFotoVazioException();

  @override
  String toString() {
    return 'Caminho do arquivo da foto e obrigatorio.';
  }
}

class DriftFotosMedicaoRepository implements FotosMedicaoRepository {
  const DriftFotosMedicaoRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<FotoMedicao>> watchFotosDaMedicao(String medicaoId) {
    final query = _database.select(_database.fotos)
      ..where((table) => table.medicaoId.equals(medicaoId))
      ..orderBy([(table) => OrderingTerm.asc(table.id)]);

    return query.watch().map((rows) => rows.map(_mapFoto).toList());
  }

  @override
  Future<void> salvarFoto(FotoMedicao foto) {
    if (foto.caminhoArquivo.trim().isEmpty) {
      throw const CaminhoFotoVazioException();
    }

    return _database.into(_database.fotos).insertOnConflictUpdate(
          db.FotosCompanion.insert(
            id: foto.id,
            medicaoId: foto.medicaoId,
            caminhoArquivo: foto.caminhoArquivo,
          ),
        );
  }

  @override
  Future<void> removerFoto(String id) {
    return (_database.delete(_database.fotos)
          ..where((table) => table.id.equals(id)))
        .go();
  }

  FotoMedicao _mapFoto(db.Foto row) {
    return FotoMedicao(
      id: row.id,
      medicaoId: row.medicaoId,
      caminhoArquivo: row.caminhoArquivo,
    );
  }
}
