import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart' as db;
import '../domain/foto_fiscalizacao.dart';

abstract class FotosFiscalizacaoRepository {
  Stream<List<FotoFiscalizacao>> watchFotosDaFiscalizacao(
    String vistoriaServicoId,
  );

  Future<void> salvarFoto(FotoFiscalizacao foto);

  Future<void> removerFoto(String id);
}

class CaminhoFotoFiscalizacaoVazioException implements Exception {
  const CaminhoFotoFiscalizacaoVazioException();

  @override
  String toString() {
    return 'Caminho do arquivo da foto e obrigatorio.';
  }
}

class DriftFotosFiscalizacaoRepository implements FotosFiscalizacaoRepository {
  const DriftFotosFiscalizacaoRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<FotoFiscalizacao>> watchFotosDaFiscalizacao(
    String vistoriaServicoId,
  ) {
    final query = _database.select(_database.vistoriasFotos)
      ..where((table) => table.vistoriaServicoId.equals(vistoriaServicoId))
      ..orderBy([(table) => OrderingTerm.asc(table.id)]);

    return query.watch().map((rows) => rows.map(_mapFoto).toList());
  }

  @override
  Future<void> salvarFoto(FotoFiscalizacao foto) {
    if (foto.caminhoArquivo.trim().isEmpty) {
      throw const CaminhoFotoFiscalizacaoVazioException();
    }

    return _database.into(_database.vistoriasFotos).insertOnConflictUpdate(
          db.VistoriasFotosCompanion.insert(
            id: foto.id,
            vistoriaServicoId: foto.vistoriaServicoId,
            caminhoArquivo: foto.caminhoArquivo,
            uriGaleria: Value(foto.uriGaleria),
            legenda: Value(foto.legenda),
          ),
        );
  }

  @override
  Future<void> removerFoto(String id) {
    return (_database.delete(_database.vistoriasFotos)
          ..where((table) => table.id.equals(id)))
        .go();
  }

  FotoFiscalizacao _mapFoto(db.VistoriasFoto row) {
    return FotoFiscalizacao(
      id: row.id,
      vistoriaServicoId: row.vistoriaServicoId,
      caminhoArquivo: row.caminhoArquivo,
      uriGaleria: row.uriGaleria,
      legenda: row.legenda,
    );
  }
}
