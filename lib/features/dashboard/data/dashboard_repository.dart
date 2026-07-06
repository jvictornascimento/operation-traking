import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/domain/domain_enums.dart';
import '../domain/dashboard_resumo.dart';

abstract class DashboardRepository {
  Stream<DashboardResumo> watchResumo();
}

class DriftDashboardRepository implements DashboardRepository {
  const DriftDashboardRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<DashboardResumo> watchResumo() {
    return _database
        .customSelect(
          '''
          SELECT
            (SELECT COUNT(*) FROM obras) AS total_obras,
            (SELECT COUNT(*) FROM vistorias_servico) AS total_fiscalizacoes,
            (SELECT COUNT(*) FROM vistorias_fotos) AS total_fotos,
            (SELECT COUNT(*) FROM obras WHERE status = ?) AS obras_atrasadas,
            CAST(COALESCE((SELECT AVG(progresso_fisico) FROM obras), 0) AS REAL)
              AS progresso_medio_obras
          ''',
          variables: [
            Variable<String>(StatusExecucao.atrasada.name),
          ],
          readsFrom: {
            _database.obras,
            _database.vistoriasServico,
            _database.vistoriasFotos,
          },
        )
        .watchSingle()
        .map(_mapResumo);
  }

  DashboardResumo _mapResumo(QueryRow row) {
    return DashboardResumo(
      totalObras: row.read<int>('total_obras'),
      totalFiscalizacoes: row.read<int>('total_fiscalizacoes'),
      totalFotos: row.read<int>('total_fotos'),
      obrasAtrasadas: row.read<int>('obras_atrasadas'),
      progressoMedioObras: _arredondar(
        row.read<double>('progresso_medio_obras'),
      ),
    );
  }

  double _arredondar(double value) {
    return double.parse(value.toStringAsFixed(2));
  }
}
