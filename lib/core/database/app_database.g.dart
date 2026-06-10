// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EmpresasTable extends Empresas with TableInfo<$EmpresasTable, Empresa> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmpresasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cnpjMeta = const VerificationMeta('cnpj');
  @override
  late final GeneratedColumn<String> cnpj = GeneratedColumn<String>(
      'cnpj', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ieMeta = const VerificationMeta('ie');
  @override
  late final GeneratedColumn<String> ie = GeneratedColumn<String>(
      'ie', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, nome, cnpj, ie];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'empresas';
  @override
  VerificationContext validateIntegrity(Insertable<Empresa> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('cnpj')) {
      context.handle(
          _cnpjMeta, cnpj.isAcceptableOrUnknown(data['cnpj']!, _cnpjMeta));
    }
    if (data.containsKey('ie')) {
      context.handle(_ieMeta, ie.isAcceptableOrUnknown(data['ie']!, _ieMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Empresa map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Empresa(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      cnpj: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cnpj']),
      ie: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ie']),
    );
  }

  @override
  $EmpresasTable createAlias(String alias) {
    return $EmpresasTable(attachedDatabase, alias);
  }
}

class Empresa extends DataClass implements Insertable<Empresa> {
  final String id;
  final String nome;
  final String? cnpj;
  final String? ie;
  const Empresa({required this.id, required this.nome, this.cnpj, this.ie});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || cnpj != null) {
      map['cnpj'] = Variable<String>(cnpj);
    }
    if (!nullToAbsent || ie != null) {
      map['ie'] = Variable<String>(ie);
    }
    return map;
  }

  EmpresasCompanion toCompanion(bool nullToAbsent) {
    return EmpresasCompanion(
      id: Value(id),
      nome: Value(nome),
      cnpj: cnpj == null && nullToAbsent ? const Value.absent() : Value(cnpj),
      ie: ie == null && nullToAbsent ? const Value.absent() : Value(ie),
    );
  }

  factory Empresa.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Empresa(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      cnpj: serializer.fromJson<String?>(json['cnpj']),
      ie: serializer.fromJson<String?>(json['ie']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'cnpj': serializer.toJson<String?>(cnpj),
      'ie': serializer.toJson<String?>(ie),
    };
  }

  Empresa copyWith(
          {String? id,
          String? nome,
          Value<String?> cnpj = const Value.absent(),
          Value<String?> ie = const Value.absent()}) =>
      Empresa(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        cnpj: cnpj.present ? cnpj.value : this.cnpj,
        ie: ie.present ? ie.value : this.ie,
      );
  Empresa copyWithCompanion(EmpresasCompanion data) {
    return Empresa(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      cnpj: data.cnpj.present ? data.cnpj.value : this.cnpj,
      ie: data.ie.present ? data.ie.value : this.ie,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Empresa(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('cnpj: $cnpj, ')
          ..write('ie: $ie')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, cnpj, ie);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Empresa &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.cnpj == this.cnpj &&
          other.ie == this.ie);
}

class EmpresasCompanion extends UpdateCompanion<Empresa> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String?> cnpj;
  final Value<String?> ie;
  final Value<int> rowid;
  const EmpresasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.cnpj = const Value.absent(),
    this.ie = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmpresasCompanion.insert({
    required String id,
    required String nome,
    this.cnpj = const Value.absent(),
    this.ie = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nome = Value(nome);
  static Insertable<Empresa> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? cnpj,
    Expression<String>? ie,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (cnpj != null) 'cnpj': cnpj,
      if (ie != null) 'ie': ie,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmpresasCompanion copyWith(
      {Value<String>? id,
      Value<String>? nome,
      Value<String?>? cnpj,
      Value<String?>? ie,
      Value<int>? rowid}) {
    return EmpresasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cnpj: cnpj ?? this.cnpj,
      ie: ie ?? this.ie,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (cnpj.present) {
      map['cnpj'] = Variable<String>(cnpj.value);
    }
    if (ie.present) {
      map['ie'] = Variable<String>(ie.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmpresasCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('cnpj: $cnpj, ')
          ..write('ie: $ie, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContratantesTable extends Contratantes
    with TableInfo<$ContratantesTable, Contratante> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContratantesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cnpjMeta = const VerificationMeta('cnpj');
  @override
  late final GeneratedColumn<String> cnpj = GeneratedColumn<String>(
      'cnpj', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ieMeta = const VerificationMeta('ie');
  @override
  late final GeneratedColumn<String> ie = GeneratedColumn<String>(
      'ie', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, nome, cnpj, ie];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contratantes';
  @override
  VerificationContext validateIntegrity(Insertable<Contratante> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('cnpj')) {
      context.handle(
          _cnpjMeta, cnpj.isAcceptableOrUnknown(data['cnpj']!, _cnpjMeta));
    }
    if (data.containsKey('ie')) {
      context.handle(_ieMeta, ie.isAcceptableOrUnknown(data['ie']!, _ieMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contratante map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contratante(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      cnpj: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cnpj']),
      ie: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ie']),
    );
  }

  @override
  $ContratantesTable createAlias(String alias) {
    return $ContratantesTable(attachedDatabase, alias);
  }
}

class Contratante extends DataClass implements Insertable<Contratante> {
  final String id;
  final String nome;
  final String? cnpj;
  final String? ie;
  const Contratante({required this.id, required this.nome, this.cnpj, this.ie});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || cnpj != null) {
      map['cnpj'] = Variable<String>(cnpj);
    }
    if (!nullToAbsent || ie != null) {
      map['ie'] = Variable<String>(ie);
    }
    return map;
  }

  ContratantesCompanion toCompanion(bool nullToAbsent) {
    return ContratantesCompanion(
      id: Value(id),
      nome: Value(nome),
      cnpj: cnpj == null && nullToAbsent ? const Value.absent() : Value(cnpj),
      ie: ie == null && nullToAbsent ? const Value.absent() : Value(ie),
    );
  }

  factory Contratante.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contratante(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      cnpj: serializer.fromJson<String?>(json['cnpj']),
      ie: serializer.fromJson<String?>(json['ie']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'cnpj': serializer.toJson<String?>(cnpj),
      'ie': serializer.toJson<String?>(ie),
    };
  }

  Contratante copyWith(
          {String? id,
          String? nome,
          Value<String?> cnpj = const Value.absent(),
          Value<String?> ie = const Value.absent()}) =>
      Contratante(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        cnpj: cnpj.present ? cnpj.value : this.cnpj,
        ie: ie.present ? ie.value : this.ie,
      );
  Contratante copyWithCompanion(ContratantesCompanion data) {
    return Contratante(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      cnpj: data.cnpj.present ? data.cnpj.value : this.cnpj,
      ie: data.ie.present ? data.ie.value : this.ie,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contratante(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('cnpj: $cnpj, ')
          ..write('ie: $ie')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, cnpj, ie);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contratante &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.cnpj == this.cnpj &&
          other.ie == this.ie);
}

class ContratantesCompanion extends UpdateCompanion<Contratante> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String?> cnpj;
  final Value<String?> ie;
  final Value<int> rowid;
  const ContratantesCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.cnpj = const Value.absent(),
    this.ie = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContratantesCompanion.insert({
    required String id,
    required String nome,
    this.cnpj = const Value.absent(),
    this.ie = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nome = Value(nome);
  static Insertable<Contratante> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? cnpj,
    Expression<String>? ie,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (cnpj != null) 'cnpj': cnpj,
      if (ie != null) 'ie': ie,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContratantesCompanion copyWith(
      {Value<String>? id,
      Value<String>? nome,
      Value<String?>? cnpj,
      Value<String?>? ie,
      Value<int>? rowid}) {
    return ContratantesCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cnpj: cnpj ?? this.cnpj,
      ie: ie ?? this.ie,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (cnpj.present) {
      map['cnpj'] = Variable<String>(cnpj.value);
    }
    if (ie.present) {
      map['ie'] = Variable<String>(ie.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContratantesCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('cnpj: $cnpj, ')
          ..write('ie: $ie, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FuncionariosTable extends Funcionarios
    with TableInfo<$FuncionariosTable, Funcionario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuncionariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _empresaIdMeta =
      const VerificationMeta('empresaId');
  @override
  late final GeneratedColumn<String> empresaId = GeneratedColumn<String>(
      'empresa_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES empresas (id)'));
  static const VerificationMeta _contratanteIdMeta =
      const VerificationMeta('contratanteId');
  @override
  late final GeneratedColumn<String> contratanteId = GeneratedColumn<String>(
      'contratante_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES contratantes (id)'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cpfMeta = const VerificationMeta('cpf');
  @override
  late final GeneratedColumn<String> cpf = GeneratedColumn<String>(
      'cpf', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cargoMeta = const VerificationMeta('cargo');
  @override
  late final GeneratedColumn<String> cargo = GeneratedColumn<String>(
      'cargo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, empresaId, contratanteId, nome, cpf, cargo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'funcionarios';
  @override
  VerificationContext validateIntegrity(Insertable<Funcionario> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('empresa_id')) {
      context.handle(_empresaIdMeta,
          empresaId.isAcceptableOrUnknown(data['empresa_id']!, _empresaIdMeta));
    }
    if (data.containsKey('contratante_id')) {
      context.handle(
          _contratanteIdMeta,
          contratanteId.isAcceptableOrUnknown(
              data['contratante_id']!, _contratanteIdMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('cpf')) {
      context.handle(
          _cpfMeta, cpf.isAcceptableOrUnknown(data['cpf']!, _cpfMeta));
    }
    if (data.containsKey('cargo')) {
      context.handle(
          _cargoMeta, cargo.isAcceptableOrUnknown(data['cargo']!, _cargoMeta));
    } else if (isInserting) {
      context.missing(_cargoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Funcionario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Funcionario(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      empresaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}empresa_id']),
      contratanteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contratante_id']),
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      cpf: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpf']),
      cargo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cargo'])!,
    );
  }

  @override
  $FuncionariosTable createAlias(String alias) {
    return $FuncionariosTable(attachedDatabase, alias);
  }
}

class Funcionario extends DataClass implements Insertable<Funcionario> {
  final String id;
  final String? empresaId;
  final String? contratanteId;
  final String nome;
  final String? cpf;
  final String cargo;
  const Funcionario(
      {required this.id,
      this.empresaId,
      this.contratanteId,
      required this.nome,
      this.cpf,
      required this.cargo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || empresaId != null) {
      map['empresa_id'] = Variable<String>(empresaId);
    }
    if (!nullToAbsent || contratanteId != null) {
      map['contratante_id'] = Variable<String>(contratanteId);
    }
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || cpf != null) {
      map['cpf'] = Variable<String>(cpf);
    }
    map['cargo'] = Variable<String>(cargo);
    return map;
  }

  FuncionariosCompanion toCompanion(bool nullToAbsent) {
    return FuncionariosCompanion(
      id: Value(id),
      empresaId: empresaId == null && nullToAbsent
          ? const Value.absent()
          : Value(empresaId),
      contratanteId: contratanteId == null && nullToAbsent
          ? const Value.absent()
          : Value(contratanteId),
      nome: Value(nome),
      cpf: cpf == null && nullToAbsent ? const Value.absent() : Value(cpf),
      cargo: Value(cargo),
    );
  }

  factory Funcionario.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Funcionario(
      id: serializer.fromJson<String>(json['id']),
      empresaId: serializer.fromJson<String?>(json['empresaId']),
      contratanteId: serializer.fromJson<String?>(json['contratanteId']),
      nome: serializer.fromJson<String>(json['nome']),
      cpf: serializer.fromJson<String?>(json['cpf']),
      cargo: serializer.fromJson<String>(json['cargo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'empresaId': serializer.toJson<String?>(empresaId),
      'contratanteId': serializer.toJson<String?>(contratanteId),
      'nome': serializer.toJson<String>(nome),
      'cpf': serializer.toJson<String?>(cpf),
      'cargo': serializer.toJson<String>(cargo),
    };
  }

  Funcionario copyWith(
          {String? id,
          Value<String?> empresaId = const Value.absent(),
          Value<String?> contratanteId = const Value.absent(),
          String? nome,
          Value<String?> cpf = const Value.absent(),
          String? cargo}) =>
      Funcionario(
        id: id ?? this.id,
        empresaId: empresaId.present ? empresaId.value : this.empresaId,
        contratanteId:
            contratanteId.present ? contratanteId.value : this.contratanteId,
        nome: nome ?? this.nome,
        cpf: cpf.present ? cpf.value : this.cpf,
        cargo: cargo ?? this.cargo,
      );
  Funcionario copyWithCompanion(FuncionariosCompanion data) {
    return Funcionario(
      id: data.id.present ? data.id.value : this.id,
      empresaId: data.empresaId.present ? data.empresaId.value : this.empresaId,
      contratanteId: data.contratanteId.present
          ? data.contratanteId.value
          : this.contratanteId,
      nome: data.nome.present ? data.nome.value : this.nome,
      cpf: data.cpf.present ? data.cpf.value : this.cpf,
      cargo: data.cargo.present ? data.cargo.value : this.cargo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Funcionario(')
          ..write('id: $id, ')
          ..write('empresaId: $empresaId, ')
          ..write('contratanteId: $contratanteId, ')
          ..write('nome: $nome, ')
          ..write('cpf: $cpf, ')
          ..write('cargo: $cargo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, empresaId, contratanteId, nome, cpf, cargo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Funcionario &&
          other.id == this.id &&
          other.empresaId == this.empresaId &&
          other.contratanteId == this.contratanteId &&
          other.nome == this.nome &&
          other.cpf == this.cpf &&
          other.cargo == this.cargo);
}

class FuncionariosCompanion extends UpdateCompanion<Funcionario> {
  final Value<String> id;
  final Value<String?> empresaId;
  final Value<String?> contratanteId;
  final Value<String> nome;
  final Value<String?> cpf;
  final Value<String> cargo;
  final Value<int> rowid;
  const FuncionariosCompanion({
    this.id = const Value.absent(),
    this.empresaId = const Value.absent(),
    this.contratanteId = const Value.absent(),
    this.nome = const Value.absent(),
    this.cpf = const Value.absent(),
    this.cargo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FuncionariosCompanion.insert({
    required String id,
    this.empresaId = const Value.absent(),
    this.contratanteId = const Value.absent(),
    required String nome,
    this.cpf = const Value.absent(),
    required String cargo,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nome = Value(nome),
        cargo = Value(cargo);
  static Insertable<Funcionario> custom({
    Expression<String>? id,
    Expression<String>? empresaId,
    Expression<String>? contratanteId,
    Expression<String>? nome,
    Expression<String>? cpf,
    Expression<String>? cargo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (empresaId != null) 'empresa_id': empresaId,
      if (contratanteId != null) 'contratante_id': contratanteId,
      if (nome != null) 'nome': nome,
      if (cpf != null) 'cpf': cpf,
      if (cargo != null) 'cargo': cargo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FuncionariosCompanion copyWith(
      {Value<String>? id,
      Value<String?>? empresaId,
      Value<String?>? contratanteId,
      Value<String>? nome,
      Value<String?>? cpf,
      Value<String>? cargo,
      Value<int>? rowid}) {
    return FuncionariosCompanion(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      contratanteId: contratanteId ?? this.contratanteId,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      cargo: cargo ?? this.cargo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (empresaId.present) {
      map['empresa_id'] = Variable<String>(empresaId.value);
    }
    if (contratanteId.present) {
      map['contratante_id'] = Variable<String>(contratanteId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (cpf.present) {
      map['cpf'] = Variable<String>(cpf.value);
    }
    if (cargo.present) {
      map['cargo'] = Variable<String>(cargo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FuncionariosCompanion(')
          ..write('id: $id, ')
          ..write('empresaId: $empresaId, ')
          ..write('contratanteId: $contratanteId, ')
          ..write('nome: $nome, ')
          ..write('cpf: $cpf, ')
          ..write('cargo: $cargo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EnderecosTable extends Enderecos
    with TableInfo<$EnderecosTable, Endereco> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnderecosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entidadeMeta =
      const VerificationMeta('entidade');
  @override
  late final GeneratedColumn<String> entidade = GeneratedColumn<String>(
      'entidade', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entidadeIdMeta =
      const VerificationMeta('entidadeId');
  @override
  late final GeneratedColumn<String> entidadeId = GeneratedColumn<String>(
      'entidade_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cepMeta = const VerificationMeta('cep');
  @override
  late final GeneratedColumn<String> cep = GeneratedColumn<String>(
      'cep', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logradouroMeta =
      const VerificationMeta('logradouro');
  @override
  late final GeneratedColumn<String> logradouro = GeneratedColumn<String>(
      'logradouro', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
      'numero', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _complementoMeta =
      const VerificationMeta('complemento');
  @override
  late final GeneratedColumn<String> complemento = GeneratedColumn<String>(
      'complemento', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bairroMeta = const VerificationMeta('bairro');
  @override
  late final GeneratedColumn<String> bairro = GeneratedColumn<String>(
      'bairro', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cidadeMeta = const VerificationMeta('cidade');
  @override
  late final GeneratedColumn<String> cidade = GeneratedColumn<String>(
      'cidade', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paisMeta = const VerificationMeta('pais');
  @override
  late final GeneratedColumn<String> pais = GeneratedColumn<String>(
      'pais', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Brasil'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entidade,
        entidadeId,
        tipo,
        cep,
        logradouro,
        numero,
        complemento,
        bairro,
        cidade,
        estado,
        pais
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'enderecos';
  @override
  VerificationContext validateIntegrity(Insertable<Endereco> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entidade')) {
      context.handle(_entidadeMeta,
          entidade.isAcceptableOrUnknown(data['entidade']!, _entidadeMeta));
    } else if (isInserting) {
      context.missing(_entidadeMeta);
    }
    if (data.containsKey('entidade_id')) {
      context.handle(
          _entidadeIdMeta,
          entidadeId.isAcceptableOrUnknown(
              data['entidade_id']!, _entidadeIdMeta));
    } else if (isInserting) {
      context.missing(_entidadeIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('cep')) {
      context.handle(
          _cepMeta, cep.isAcceptableOrUnknown(data['cep']!, _cepMeta));
    }
    if (data.containsKey('logradouro')) {
      context.handle(
          _logradouroMeta,
          logradouro.isAcceptableOrUnknown(
              data['logradouro']!, _logradouroMeta));
    }
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    }
    if (data.containsKey('complemento')) {
      context.handle(
          _complementoMeta,
          complemento.isAcceptableOrUnknown(
              data['complemento']!, _complementoMeta));
    }
    if (data.containsKey('bairro')) {
      context.handle(_bairroMeta,
          bairro.isAcceptableOrUnknown(data['bairro']!, _bairroMeta));
    }
    if (data.containsKey('cidade')) {
      context.handle(_cidadeMeta,
          cidade.isAcceptableOrUnknown(data['cidade']!, _cidadeMeta));
    } else if (isInserting) {
      context.missing(_cidadeMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('pais')) {
      context.handle(
          _paisMeta, pais.isAcceptableOrUnknown(data['pais']!, _paisMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Endereco map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Endereco(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entidade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entidade'])!,
      entidadeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entidade_id'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      cep: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cep']),
      logradouro: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logradouro']),
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero']),
      complemento: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}complemento']),
      bairro: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bairro']),
      cidade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cidade'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      pais: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pais'])!,
    );
  }

  @override
  $EnderecosTable createAlias(String alias) {
    return $EnderecosTable(attachedDatabase, alias);
  }
}

class Endereco extends DataClass implements Insertable<Endereco> {
  final String id;
  final String entidade;
  final String entidadeId;
  final String tipo;
  final String? cep;
  final String? logradouro;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String cidade;
  final String estado;
  final String pais;
  const Endereco(
      {required this.id,
      required this.entidade,
      required this.entidadeId,
      required this.tipo,
      this.cep,
      this.logradouro,
      this.numero,
      this.complemento,
      this.bairro,
      required this.cidade,
      required this.estado,
      required this.pais});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entidade'] = Variable<String>(entidade);
    map['entidade_id'] = Variable<String>(entidadeId);
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || cep != null) {
      map['cep'] = Variable<String>(cep);
    }
    if (!nullToAbsent || logradouro != null) {
      map['logradouro'] = Variable<String>(logradouro);
    }
    if (!nullToAbsent || numero != null) {
      map['numero'] = Variable<String>(numero);
    }
    if (!nullToAbsent || complemento != null) {
      map['complemento'] = Variable<String>(complemento);
    }
    if (!nullToAbsent || bairro != null) {
      map['bairro'] = Variable<String>(bairro);
    }
    map['cidade'] = Variable<String>(cidade);
    map['estado'] = Variable<String>(estado);
    map['pais'] = Variable<String>(pais);
    return map;
  }

  EnderecosCompanion toCompanion(bool nullToAbsent) {
    return EnderecosCompanion(
      id: Value(id),
      entidade: Value(entidade),
      entidadeId: Value(entidadeId),
      tipo: Value(tipo),
      cep: cep == null && nullToAbsent ? const Value.absent() : Value(cep),
      logradouro: logradouro == null && nullToAbsent
          ? const Value.absent()
          : Value(logradouro),
      numero:
          numero == null && nullToAbsent ? const Value.absent() : Value(numero),
      complemento: complemento == null && nullToAbsent
          ? const Value.absent()
          : Value(complemento),
      bairro:
          bairro == null && nullToAbsent ? const Value.absent() : Value(bairro),
      cidade: Value(cidade),
      estado: Value(estado),
      pais: Value(pais),
    );
  }

  factory Endereco.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Endereco(
      id: serializer.fromJson<String>(json['id']),
      entidade: serializer.fromJson<String>(json['entidade']),
      entidadeId: serializer.fromJson<String>(json['entidadeId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cep: serializer.fromJson<String?>(json['cep']),
      logradouro: serializer.fromJson<String?>(json['logradouro']),
      numero: serializer.fromJson<String?>(json['numero']),
      complemento: serializer.fromJson<String?>(json['complemento']),
      bairro: serializer.fromJson<String?>(json['bairro']),
      cidade: serializer.fromJson<String>(json['cidade']),
      estado: serializer.fromJson<String>(json['estado']),
      pais: serializer.fromJson<String>(json['pais']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entidade': serializer.toJson<String>(entidade),
      'entidadeId': serializer.toJson<String>(entidadeId),
      'tipo': serializer.toJson<String>(tipo),
      'cep': serializer.toJson<String?>(cep),
      'logradouro': serializer.toJson<String?>(logradouro),
      'numero': serializer.toJson<String?>(numero),
      'complemento': serializer.toJson<String?>(complemento),
      'bairro': serializer.toJson<String?>(bairro),
      'cidade': serializer.toJson<String>(cidade),
      'estado': serializer.toJson<String>(estado),
      'pais': serializer.toJson<String>(pais),
    };
  }

  Endereco copyWith(
          {String? id,
          String? entidade,
          String? entidadeId,
          String? tipo,
          Value<String?> cep = const Value.absent(),
          Value<String?> logradouro = const Value.absent(),
          Value<String?> numero = const Value.absent(),
          Value<String?> complemento = const Value.absent(),
          Value<String?> bairro = const Value.absent(),
          String? cidade,
          String? estado,
          String? pais}) =>
      Endereco(
        id: id ?? this.id,
        entidade: entidade ?? this.entidade,
        entidadeId: entidadeId ?? this.entidadeId,
        tipo: tipo ?? this.tipo,
        cep: cep.present ? cep.value : this.cep,
        logradouro: logradouro.present ? logradouro.value : this.logradouro,
        numero: numero.present ? numero.value : this.numero,
        complemento: complemento.present ? complemento.value : this.complemento,
        bairro: bairro.present ? bairro.value : this.bairro,
        cidade: cidade ?? this.cidade,
        estado: estado ?? this.estado,
        pais: pais ?? this.pais,
      );
  Endereco copyWithCompanion(EnderecosCompanion data) {
    return Endereco(
      id: data.id.present ? data.id.value : this.id,
      entidade: data.entidade.present ? data.entidade.value : this.entidade,
      entidadeId:
          data.entidadeId.present ? data.entidadeId.value : this.entidadeId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cep: data.cep.present ? data.cep.value : this.cep,
      logradouro:
          data.logradouro.present ? data.logradouro.value : this.logradouro,
      numero: data.numero.present ? data.numero.value : this.numero,
      complemento:
          data.complemento.present ? data.complemento.value : this.complemento,
      bairro: data.bairro.present ? data.bairro.value : this.bairro,
      cidade: data.cidade.present ? data.cidade.value : this.cidade,
      estado: data.estado.present ? data.estado.value : this.estado,
      pais: data.pais.present ? data.pais.value : this.pais,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Endereco(')
          ..write('id: $id, ')
          ..write('entidade: $entidade, ')
          ..write('entidadeId: $entidadeId, ')
          ..write('tipo: $tipo, ')
          ..write('cep: $cep, ')
          ..write('logradouro: $logradouro, ')
          ..write('numero: $numero, ')
          ..write('complemento: $complemento, ')
          ..write('bairro: $bairro, ')
          ..write('cidade: $cidade, ')
          ..write('estado: $estado, ')
          ..write('pais: $pais')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entidade, entidadeId, tipo, cep,
      logradouro, numero, complemento, bairro, cidade, estado, pais);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Endereco &&
          other.id == this.id &&
          other.entidade == this.entidade &&
          other.entidadeId == this.entidadeId &&
          other.tipo == this.tipo &&
          other.cep == this.cep &&
          other.logradouro == this.logradouro &&
          other.numero == this.numero &&
          other.complemento == this.complemento &&
          other.bairro == this.bairro &&
          other.cidade == this.cidade &&
          other.estado == this.estado &&
          other.pais == this.pais);
}

class EnderecosCompanion extends UpdateCompanion<Endereco> {
  final Value<String> id;
  final Value<String> entidade;
  final Value<String> entidadeId;
  final Value<String> tipo;
  final Value<String?> cep;
  final Value<String?> logradouro;
  final Value<String?> numero;
  final Value<String?> complemento;
  final Value<String?> bairro;
  final Value<String> cidade;
  final Value<String> estado;
  final Value<String> pais;
  final Value<int> rowid;
  const EnderecosCompanion({
    this.id = const Value.absent(),
    this.entidade = const Value.absent(),
    this.entidadeId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cep = const Value.absent(),
    this.logradouro = const Value.absent(),
    this.numero = const Value.absent(),
    this.complemento = const Value.absent(),
    this.bairro = const Value.absent(),
    this.cidade = const Value.absent(),
    this.estado = const Value.absent(),
    this.pais = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnderecosCompanion.insert({
    required String id,
    required String entidade,
    required String entidadeId,
    required String tipo,
    this.cep = const Value.absent(),
    this.logradouro = const Value.absent(),
    this.numero = const Value.absent(),
    this.complemento = const Value.absent(),
    this.bairro = const Value.absent(),
    required String cidade,
    required String estado,
    this.pais = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entidade = Value(entidade),
        entidadeId = Value(entidadeId),
        tipo = Value(tipo),
        cidade = Value(cidade),
        estado = Value(estado);
  static Insertable<Endereco> custom({
    Expression<String>? id,
    Expression<String>? entidade,
    Expression<String>? entidadeId,
    Expression<String>? tipo,
    Expression<String>? cep,
    Expression<String>? logradouro,
    Expression<String>? numero,
    Expression<String>? complemento,
    Expression<String>? bairro,
    Expression<String>? cidade,
    Expression<String>? estado,
    Expression<String>? pais,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entidade != null) 'entidade': entidade,
      if (entidadeId != null) 'entidade_id': entidadeId,
      if (tipo != null) 'tipo': tipo,
      if (cep != null) 'cep': cep,
      if (logradouro != null) 'logradouro': logradouro,
      if (numero != null) 'numero': numero,
      if (complemento != null) 'complemento': complemento,
      if (bairro != null) 'bairro': bairro,
      if (cidade != null) 'cidade': cidade,
      if (estado != null) 'estado': estado,
      if (pais != null) 'pais': pais,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnderecosCompanion copyWith(
      {Value<String>? id,
      Value<String>? entidade,
      Value<String>? entidadeId,
      Value<String>? tipo,
      Value<String?>? cep,
      Value<String?>? logradouro,
      Value<String?>? numero,
      Value<String?>? complemento,
      Value<String?>? bairro,
      Value<String>? cidade,
      Value<String>? estado,
      Value<String>? pais,
      Value<int>? rowid}) {
    return EnderecosCompanion(
      id: id ?? this.id,
      entidade: entidade ?? this.entidade,
      entidadeId: entidadeId ?? this.entidadeId,
      tipo: tipo ?? this.tipo,
      cep: cep ?? this.cep,
      logradouro: logradouro ?? this.logradouro,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      pais: pais ?? this.pais,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entidade.present) {
      map['entidade'] = Variable<String>(entidade.value);
    }
    if (entidadeId.present) {
      map['entidade_id'] = Variable<String>(entidadeId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cep.present) {
      map['cep'] = Variable<String>(cep.value);
    }
    if (logradouro.present) {
      map['logradouro'] = Variable<String>(logradouro.value);
    }
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (complemento.present) {
      map['complemento'] = Variable<String>(complemento.value);
    }
    if (bairro.present) {
      map['bairro'] = Variable<String>(bairro.value);
    }
    if (cidade.present) {
      map['cidade'] = Variable<String>(cidade.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (pais.present) {
      map['pais'] = Variable<String>(pais.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnderecosCompanion(')
          ..write('id: $id, ')
          ..write('entidade: $entidade, ')
          ..write('entidadeId: $entidadeId, ')
          ..write('tipo: $tipo, ')
          ..write('cep: $cep, ')
          ..write('logradouro: $logradouro, ')
          ..write('numero: $numero, ')
          ..write('complemento: $complemento, ')
          ..write('bairro: $bairro, ')
          ..write('cidade: $cidade, ')
          ..write('estado: $estado, ')
          ..write('pais: $pais, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContatosTable extends Contatos with TableInfo<$ContatosTable, Contato> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContatosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entidadeMeta =
      const VerificationMeta('entidade');
  @override
  late final GeneratedColumn<String> entidade = GeneratedColumn<String>(
      'entidade', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entidadeIdMeta =
      const VerificationMeta('entidadeId');
  @override
  late final GeneratedColumn<String> entidadeId = GeneratedColumn<String>(
      'entidade_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<String> valor = GeneratedColumn<String>(
      'valor', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _observacaoMeta =
      const VerificationMeta('observacao');
  @override
  late final GeneratedColumn<String> observacao = GeneratedColumn<String>(
      'observacao', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, entidade, entidadeId, tipo, valor, observacao];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contatos';
  @override
  VerificationContext validateIntegrity(Insertable<Contato> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entidade')) {
      context.handle(_entidadeMeta,
          entidade.isAcceptableOrUnknown(data['entidade']!, _entidadeMeta));
    } else if (isInserting) {
      context.missing(_entidadeMeta);
    }
    if (data.containsKey('entidade_id')) {
      context.handle(
          _entidadeIdMeta,
          entidadeId.isAcceptableOrUnknown(
              data['entidade_id']!, _entidadeIdMeta));
    } else if (isInserting) {
      context.missing(_entidadeIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
          _valorMeta, valor.isAcceptableOrUnknown(data['valor']!, _valorMeta));
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('observacao')) {
      context.handle(
          _observacaoMeta,
          observacao.isAcceptableOrUnknown(
              data['observacao']!, _observacaoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contato map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contato(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entidade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entidade'])!,
      entidadeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entidade_id'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      valor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valor'])!,
      observacao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacao']),
    );
  }

  @override
  $ContatosTable createAlias(String alias) {
    return $ContatosTable(attachedDatabase, alias);
  }
}

class Contato extends DataClass implements Insertable<Contato> {
  final String id;
  final String entidade;
  final String entidadeId;
  final String tipo;
  final String valor;
  final String? observacao;
  const Contato(
      {required this.id,
      required this.entidade,
      required this.entidadeId,
      required this.tipo,
      required this.valor,
      this.observacao});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entidade'] = Variable<String>(entidade);
    map['entidade_id'] = Variable<String>(entidadeId);
    map['tipo'] = Variable<String>(tipo);
    map['valor'] = Variable<String>(valor);
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    return map;
  }

  ContatosCompanion toCompanion(bool nullToAbsent) {
    return ContatosCompanion(
      id: Value(id),
      entidade: Value(entidade),
      entidadeId: Value(entidadeId),
      tipo: Value(tipo),
      valor: Value(valor),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
    );
  }

  factory Contato.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contato(
      id: serializer.fromJson<String>(json['id']),
      entidade: serializer.fromJson<String>(json['entidade']),
      entidadeId: serializer.fromJson<String>(json['entidadeId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      valor: serializer.fromJson<String>(json['valor']),
      observacao: serializer.fromJson<String?>(json['observacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entidade': serializer.toJson<String>(entidade),
      'entidadeId': serializer.toJson<String>(entidadeId),
      'tipo': serializer.toJson<String>(tipo),
      'valor': serializer.toJson<String>(valor),
      'observacao': serializer.toJson<String?>(observacao),
    };
  }

  Contato copyWith(
          {String? id,
          String? entidade,
          String? entidadeId,
          String? tipo,
          String? valor,
          Value<String?> observacao = const Value.absent()}) =>
      Contato(
        id: id ?? this.id,
        entidade: entidade ?? this.entidade,
        entidadeId: entidadeId ?? this.entidadeId,
        tipo: tipo ?? this.tipo,
        valor: valor ?? this.valor,
        observacao: observacao.present ? observacao.value : this.observacao,
      );
  Contato copyWithCompanion(ContatosCompanion data) {
    return Contato(
      id: data.id.present ? data.id.value : this.id,
      entidade: data.entidade.present ? data.entidade.value : this.entidade,
      entidadeId:
          data.entidadeId.present ? data.entidadeId.value : this.entidadeId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      valor: data.valor.present ? data.valor.value : this.valor,
      observacao:
          data.observacao.present ? data.observacao.value : this.observacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contato(')
          ..write('id: $id, ')
          ..write('entidade: $entidade, ')
          ..write('entidadeId: $entidadeId, ')
          ..write('tipo: $tipo, ')
          ..write('valor: $valor, ')
          ..write('observacao: $observacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entidade, entidadeId, tipo, valor, observacao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contato &&
          other.id == this.id &&
          other.entidade == this.entidade &&
          other.entidadeId == this.entidadeId &&
          other.tipo == this.tipo &&
          other.valor == this.valor &&
          other.observacao == this.observacao);
}

class ContatosCompanion extends UpdateCompanion<Contato> {
  final Value<String> id;
  final Value<String> entidade;
  final Value<String> entidadeId;
  final Value<String> tipo;
  final Value<String> valor;
  final Value<String?> observacao;
  final Value<int> rowid;
  const ContatosCompanion({
    this.id = const Value.absent(),
    this.entidade = const Value.absent(),
    this.entidadeId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.valor = const Value.absent(),
    this.observacao = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContatosCompanion.insert({
    required String id,
    required String entidade,
    required String entidadeId,
    required String tipo,
    required String valor,
    this.observacao = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entidade = Value(entidade),
        entidadeId = Value(entidadeId),
        tipo = Value(tipo),
        valor = Value(valor);
  static Insertable<Contato> custom({
    Expression<String>? id,
    Expression<String>? entidade,
    Expression<String>? entidadeId,
    Expression<String>? tipo,
    Expression<String>? valor,
    Expression<String>? observacao,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entidade != null) 'entidade': entidade,
      if (entidadeId != null) 'entidade_id': entidadeId,
      if (tipo != null) 'tipo': tipo,
      if (valor != null) 'valor': valor,
      if (observacao != null) 'observacao': observacao,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContatosCompanion copyWith(
      {Value<String>? id,
      Value<String>? entidade,
      Value<String>? entidadeId,
      Value<String>? tipo,
      Value<String>? valor,
      Value<String?>? observacao,
      Value<int>? rowid}) {
    return ContatosCompanion(
      id: id ?? this.id,
      entidade: entidade ?? this.entidade,
      entidadeId: entidadeId ?? this.entidadeId,
      tipo: tipo ?? this.tipo,
      valor: valor ?? this.valor,
      observacao: observacao ?? this.observacao,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entidade.present) {
      map['entidade'] = Variable<String>(entidade.value);
    }
    if (entidadeId.present) {
      map['entidade_id'] = Variable<String>(entidadeId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (valor.present) {
      map['valor'] = Variable<String>(valor.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContatosCompanion(')
          ..write('id: $id, ')
          ..write('entidade: $entidade, ')
          ..write('entidadeId: $entidadeId, ')
          ..write('tipo: $tipo, ')
          ..write('valor: $valor, ')
          ..write('observacao: $observacao, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ObrasTable extends Obras with TableInfo<$ObrasTable, Obra> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ObrasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _empresaIdMeta =
      const VerificationMeta('empresaId');
  @override
  late final GeneratedColumn<String> empresaId = GeneratedColumn<String>(
      'empresa_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES empresas (id)'));
  static const VerificationMeta _enderecoIdMeta =
      const VerificationMeta('enderecoId');
  @override
  late final GeneratedColumn<String> enderecoId = GeneratedColumn<String>(
      'endereco_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES enderecos (id)'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataInicioMeta =
      const VerificationMeta('dataInicio');
  @override
  late final GeneratedColumn<DateTime> dataInicio = GeneratedColumn<DateTime>(
      'data_inicio', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dataFimMeta =
      const VerificationMeta('dataFim');
  @override
  late final GeneratedColumn<DateTime> dataFim = GeneratedColumn<DateTime>(
      'data_fim', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressoFisicoMeta =
      const VerificationMeta('progressoFisico');
  @override
  late final GeneratedColumn<double> progressoFisico = GeneratedColumn<double>(
      'progresso_fisico', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _progressoPrazoDiasMeta =
      const VerificationMeta('progressoPrazoDias');
  @override
  late final GeneratedColumn<int> progressoPrazoDias = GeneratedColumn<int>(
      'progresso_prazo_dias', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        empresaId,
        enderecoId,
        nome,
        dataInicio,
        dataFim,
        status,
        progressoFisico,
        progressoPrazoDias
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'obras';
  @override
  VerificationContext validateIntegrity(Insertable<Obra> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('empresa_id')) {
      context.handle(_empresaIdMeta,
          empresaId.isAcceptableOrUnknown(data['empresa_id']!, _empresaIdMeta));
    } else if (isInserting) {
      context.missing(_empresaIdMeta);
    }
    if (data.containsKey('endereco_id')) {
      context.handle(
          _enderecoIdMeta,
          enderecoId.isAcceptableOrUnknown(
              data['endereco_id']!, _enderecoIdMeta));
    } else if (isInserting) {
      context.missing(_enderecoIdMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('data_inicio')) {
      context.handle(
          _dataInicioMeta,
          dataInicio.isAcceptableOrUnknown(
              data['data_inicio']!, _dataInicioMeta));
    } else if (isInserting) {
      context.missing(_dataInicioMeta);
    }
    if (data.containsKey('data_fim')) {
      context.handle(_dataFimMeta,
          dataFim.isAcceptableOrUnknown(data['data_fim']!, _dataFimMeta));
    } else if (isInserting) {
      context.missing(_dataFimMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('progresso_fisico')) {
      context.handle(
          _progressoFisicoMeta,
          progressoFisico.isAcceptableOrUnknown(
              data['progresso_fisico']!, _progressoFisicoMeta));
    }
    if (data.containsKey('progresso_prazo_dias')) {
      context.handle(
          _progressoPrazoDiasMeta,
          progressoPrazoDias.isAcceptableOrUnknown(
              data['progresso_prazo_dias']!, _progressoPrazoDiasMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Obra map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Obra(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      empresaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}empresa_id'])!,
      enderecoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}endereco_id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      dataInicio: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_inicio'])!,
      dataFim: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_fim'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      progressoFisico: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}progresso_fisico'])!,
      progressoPrazoDias: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}progresso_prazo_dias'])!,
    );
  }

  @override
  $ObrasTable createAlias(String alias) {
    return $ObrasTable(attachedDatabase, alias);
  }
}

class Obra extends DataClass implements Insertable<Obra> {
  final String id;
  final String empresaId;
  final String enderecoId;
  final String nome;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String status;
  final double progressoFisico;
  final int progressoPrazoDias;
  const Obra(
      {required this.id,
      required this.empresaId,
      required this.enderecoId,
      required this.nome,
      required this.dataInicio,
      required this.dataFim,
      required this.status,
      required this.progressoFisico,
      required this.progressoPrazoDias});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['empresa_id'] = Variable<String>(empresaId);
    map['endereco_id'] = Variable<String>(enderecoId);
    map['nome'] = Variable<String>(nome);
    map['data_inicio'] = Variable<DateTime>(dataInicio);
    map['data_fim'] = Variable<DateTime>(dataFim);
    map['status'] = Variable<String>(status);
    map['progresso_fisico'] = Variable<double>(progressoFisico);
    map['progresso_prazo_dias'] = Variable<int>(progressoPrazoDias);
    return map;
  }

  ObrasCompanion toCompanion(bool nullToAbsent) {
    return ObrasCompanion(
      id: Value(id),
      empresaId: Value(empresaId),
      enderecoId: Value(enderecoId),
      nome: Value(nome),
      dataInicio: Value(dataInicio),
      dataFim: Value(dataFim),
      status: Value(status),
      progressoFisico: Value(progressoFisico),
      progressoPrazoDias: Value(progressoPrazoDias),
    );
  }

  factory Obra.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Obra(
      id: serializer.fromJson<String>(json['id']),
      empresaId: serializer.fromJson<String>(json['empresaId']),
      enderecoId: serializer.fromJson<String>(json['enderecoId']),
      nome: serializer.fromJson<String>(json['nome']),
      dataInicio: serializer.fromJson<DateTime>(json['dataInicio']),
      dataFim: serializer.fromJson<DateTime>(json['dataFim']),
      status: serializer.fromJson<String>(json['status']),
      progressoFisico: serializer.fromJson<double>(json['progressoFisico']),
      progressoPrazoDias: serializer.fromJson<int>(json['progressoPrazoDias']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'empresaId': serializer.toJson<String>(empresaId),
      'enderecoId': serializer.toJson<String>(enderecoId),
      'nome': serializer.toJson<String>(nome),
      'dataInicio': serializer.toJson<DateTime>(dataInicio),
      'dataFim': serializer.toJson<DateTime>(dataFim),
      'status': serializer.toJson<String>(status),
      'progressoFisico': serializer.toJson<double>(progressoFisico),
      'progressoPrazoDias': serializer.toJson<int>(progressoPrazoDias),
    };
  }

  Obra copyWith(
          {String? id,
          String? empresaId,
          String? enderecoId,
          String? nome,
          DateTime? dataInicio,
          DateTime? dataFim,
          String? status,
          double? progressoFisico,
          int? progressoPrazoDias}) =>
      Obra(
        id: id ?? this.id,
        empresaId: empresaId ?? this.empresaId,
        enderecoId: enderecoId ?? this.enderecoId,
        nome: nome ?? this.nome,
        dataInicio: dataInicio ?? this.dataInicio,
        dataFim: dataFim ?? this.dataFim,
        status: status ?? this.status,
        progressoFisico: progressoFisico ?? this.progressoFisico,
        progressoPrazoDias: progressoPrazoDias ?? this.progressoPrazoDias,
      );
  Obra copyWithCompanion(ObrasCompanion data) {
    return Obra(
      id: data.id.present ? data.id.value : this.id,
      empresaId: data.empresaId.present ? data.empresaId.value : this.empresaId,
      enderecoId:
          data.enderecoId.present ? data.enderecoId.value : this.enderecoId,
      nome: data.nome.present ? data.nome.value : this.nome,
      dataInicio:
          data.dataInicio.present ? data.dataInicio.value : this.dataInicio,
      dataFim: data.dataFim.present ? data.dataFim.value : this.dataFim,
      status: data.status.present ? data.status.value : this.status,
      progressoFisico: data.progressoFisico.present
          ? data.progressoFisico.value
          : this.progressoFisico,
      progressoPrazoDias: data.progressoPrazoDias.present
          ? data.progressoPrazoDias.value
          : this.progressoPrazoDias,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Obra(')
          ..write('id: $id, ')
          ..write('empresaId: $empresaId, ')
          ..write('enderecoId: $enderecoId, ')
          ..write('nome: $nome, ')
          ..write('dataInicio: $dataInicio, ')
          ..write('dataFim: $dataFim, ')
          ..write('status: $status, ')
          ..write('progressoFisico: $progressoFisico, ')
          ..write('progressoPrazoDias: $progressoPrazoDias')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, empresaId, enderecoId, nome, dataInicio,
      dataFim, status, progressoFisico, progressoPrazoDias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Obra &&
          other.id == this.id &&
          other.empresaId == this.empresaId &&
          other.enderecoId == this.enderecoId &&
          other.nome == this.nome &&
          other.dataInicio == this.dataInicio &&
          other.dataFim == this.dataFim &&
          other.status == this.status &&
          other.progressoFisico == this.progressoFisico &&
          other.progressoPrazoDias == this.progressoPrazoDias);
}

class ObrasCompanion extends UpdateCompanion<Obra> {
  final Value<String> id;
  final Value<String> empresaId;
  final Value<String> enderecoId;
  final Value<String> nome;
  final Value<DateTime> dataInicio;
  final Value<DateTime> dataFim;
  final Value<String> status;
  final Value<double> progressoFisico;
  final Value<int> progressoPrazoDias;
  final Value<int> rowid;
  const ObrasCompanion({
    this.id = const Value.absent(),
    this.empresaId = const Value.absent(),
    this.enderecoId = const Value.absent(),
    this.nome = const Value.absent(),
    this.dataInicio = const Value.absent(),
    this.dataFim = const Value.absent(),
    this.status = const Value.absent(),
    this.progressoFisico = const Value.absent(),
    this.progressoPrazoDias = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ObrasCompanion.insert({
    required String id,
    required String empresaId,
    required String enderecoId,
    required String nome,
    required DateTime dataInicio,
    required DateTime dataFim,
    required String status,
    this.progressoFisico = const Value.absent(),
    this.progressoPrazoDias = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        empresaId = Value(empresaId),
        enderecoId = Value(enderecoId),
        nome = Value(nome),
        dataInicio = Value(dataInicio),
        dataFim = Value(dataFim),
        status = Value(status);
  static Insertable<Obra> custom({
    Expression<String>? id,
    Expression<String>? empresaId,
    Expression<String>? enderecoId,
    Expression<String>? nome,
    Expression<DateTime>? dataInicio,
    Expression<DateTime>? dataFim,
    Expression<String>? status,
    Expression<double>? progressoFisico,
    Expression<int>? progressoPrazoDias,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (empresaId != null) 'empresa_id': empresaId,
      if (enderecoId != null) 'endereco_id': enderecoId,
      if (nome != null) 'nome': nome,
      if (dataInicio != null) 'data_inicio': dataInicio,
      if (dataFim != null) 'data_fim': dataFim,
      if (status != null) 'status': status,
      if (progressoFisico != null) 'progresso_fisico': progressoFisico,
      if (progressoPrazoDias != null)
        'progresso_prazo_dias': progressoPrazoDias,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ObrasCompanion copyWith(
      {Value<String>? id,
      Value<String>? empresaId,
      Value<String>? enderecoId,
      Value<String>? nome,
      Value<DateTime>? dataInicio,
      Value<DateTime>? dataFim,
      Value<String>? status,
      Value<double>? progressoFisico,
      Value<int>? progressoPrazoDias,
      Value<int>? rowid}) {
    return ObrasCompanion(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      enderecoId: enderecoId ?? this.enderecoId,
      nome: nome ?? this.nome,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      status: status ?? this.status,
      progressoFisico: progressoFisico ?? this.progressoFisico,
      progressoPrazoDias: progressoPrazoDias ?? this.progressoPrazoDias,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (empresaId.present) {
      map['empresa_id'] = Variable<String>(empresaId.value);
    }
    if (enderecoId.present) {
      map['endereco_id'] = Variable<String>(enderecoId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (dataInicio.present) {
      map['data_inicio'] = Variable<DateTime>(dataInicio.value);
    }
    if (dataFim.present) {
      map['data_fim'] = Variable<DateTime>(dataFim.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (progressoFisico.present) {
      map['progresso_fisico'] = Variable<double>(progressoFisico.value);
    }
    if (progressoPrazoDias.present) {
      map['progresso_prazo_dias'] = Variable<int>(progressoPrazoDias.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObrasCompanion(')
          ..write('id: $id, ')
          ..write('empresaId: $empresaId, ')
          ..write('enderecoId: $enderecoId, ')
          ..write('nome: $nome, ')
          ..write('dataInicio: $dataInicio, ')
          ..write('dataFim: $dataFim, ')
          ..write('status: $status, ')
          ..write('progressoFisico: $progressoFisico, ')
          ..write('progressoPrazoDias: $progressoPrazoDias, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EtapasTable extends Etapas with TableInfo<$EtapasTable, Etapa> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EtapasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _obraIdMeta = const VerificationMeta('obraId');
  @override
  late final GeneratedColumn<String> obraId = GeneratedColumn<String>(
      'obra_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES obras (id)'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataInicioMeta =
      const VerificationMeta('dataInicio');
  @override
  late final GeneratedColumn<DateTime> dataInicio = GeneratedColumn<DateTime>(
      'data_inicio', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dataFimMeta =
      const VerificationMeta('dataFim');
  @override
  late final GeneratedColumn<DateTime> dataFim = GeneratedColumn<DateTime>(
      'data_fim', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressoFisicoMeta =
      const VerificationMeta('progressoFisico');
  @override
  late final GeneratedColumn<double> progressoFisico = GeneratedColumn<double>(
      'progresso_fisico', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _progressoPrazoDiasMeta =
      const VerificationMeta('progressoPrazoDias');
  @override
  late final GeneratedColumn<int> progressoPrazoDias = GeneratedColumn<int>(
      'progresso_prazo_dias', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        obraId,
        nome,
        dataInicio,
        dataFim,
        status,
        progressoFisico,
        progressoPrazoDias
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'etapas';
  @override
  VerificationContext validateIntegrity(Insertable<Etapa> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('obra_id')) {
      context.handle(_obraIdMeta,
          obraId.isAcceptableOrUnknown(data['obra_id']!, _obraIdMeta));
    } else if (isInserting) {
      context.missing(_obraIdMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('data_inicio')) {
      context.handle(
          _dataInicioMeta,
          dataInicio.isAcceptableOrUnknown(
              data['data_inicio']!, _dataInicioMeta));
    } else if (isInserting) {
      context.missing(_dataInicioMeta);
    }
    if (data.containsKey('data_fim')) {
      context.handle(_dataFimMeta,
          dataFim.isAcceptableOrUnknown(data['data_fim']!, _dataFimMeta));
    } else if (isInserting) {
      context.missing(_dataFimMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('progresso_fisico')) {
      context.handle(
          _progressoFisicoMeta,
          progressoFisico.isAcceptableOrUnknown(
              data['progresso_fisico']!, _progressoFisicoMeta));
    }
    if (data.containsKey('progresso_prazo_dias')) {
      context.handle(
          _progressoPrazoDiasMeta,
          progressoPrazoDias.isAcceptableOrUnknown(
              data['progresso_prazo_dias']!, _progressoPrazoDiasMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Etapa map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Etapa(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      obraId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}obra_id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      dataInicio: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_inicio'])!,
      dataFim: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_fim'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      progressoFisico: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}progresso_fisico'])!,
      progressoPrazoDias: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}progresso_prazo_dias'])!,
    );
  }

  @override
  $EtapasTable createAlias(String alias) {
    return $EtapasTable(attachedDatabase, alias);
  }
}

class Etapa extends DataClass implements Insertable<Etapa> {
  final String id;
  final String obraId;
  final String nome;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String status;
  final double progressoFisico;
  final int progressoPrazoDias;
  const Etapa(
      {required this.id,
      required this.obraId,
      required this.nome,
      required this.dataInicio,
      required this.dataFim,
      required this.status,
      required this.progressoFisico,
      required this.progressoPrazoDias});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['obra_id'] = Variable<String>(obraId);
    map['nome'] = Variable<String>(nome);
    map['data_inicio'] = Variable<DateTime>(dataInicio);
    map['data_fim'] = Variable<DateTime>(dataFim);
    map['status'] = Variable<String>(status);
    map['progresso_fisico'] = Variable<double>(progressoFisico);
    map['progresso_prazo_dias'] = Variable<int>(progressoPrazoDias);
    return map;
  }

  EtapasCompanion toCompanion(bool nullToAbsent) {
    return EtapasCompanion(
      id: Value(id),
      obraId: Value(obraId),
      nome: Value(nome),
      dataInicio: Value(dataInicio),
      dataFim: Value(dataFim),
      status: Value(status),
      progressoFisico: Value(progressoFisico),
      progressoPrazoDias: Value(progressoPrazoDias),
    );
  }

  factory Etapa.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Etapa(
      id: serializer.fromJson<String>(json['id']),
      obraId: serializer.fromJson<String>(json['obraId']),
      nome: serializer.fromJson<String>(json['nome']),
      dataInicio: serializer.fromJson<DateTime>(json['dataInicio']),
      dataFim: serializer.fromJson<DateTime>(json['dataFim']),
      status: serializer.fromJson<String>(json['status']),
      progressoFisico: serializer.fromJson<double>(json['progressoFisico']),
      progressoPrazoDias: serializer.fromJson<int>(json['progressoPrazoDias']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'obraId': serializer.toJson<String>(obraId),
      'nome': serializer.toJson<String>(nome),
      'dataInicio': serializer.toJson<DateTime>(dataInicio),
      'dataFim': serializer.toJson<DateTime>(dataFim),
      'status': serializer.toJson<String>(status),
      'progressoFisico': serializer.toJson<double>(progressoFisico),
      'progressoPrazoDias': serializer.toJson<int>(progressoPrazoDias),
    };
  }

  Etapa copyWith(
          {String? id,
          String? obraId,
          String? nome,
          DateTime? dataInicio,
          DateTime? dataFim,
          String? status,
          double? progressoFisico,
          int? progressoPrazoDias}) =>
      Etapa(
        id: id ?? this.id,
        obraId: obraId ?? this.obraId,
        nome: nome ?? this.nome,
        dataInicio: dataInicio ?? this.dataInicio,
        dataFim: dataFim ?? this.dataFim,
        status: status ?? this.status,
        progressoFisico: progressoFisico ?? this.progressoFisico,
        progressoPrazoDias: progressoPrazoDias ?? this.progressoPrazoDias,
      );
  Etapa copyWithCompanion(EtapasCompanion data) {
    return Etapa(
      id: data.id.present ? data.id.value : this.id,
      obraId: data.obraId.present ? data.obraId.value : this.obraId,
      nome: data.nome.present ? data.nome.value : this.nome,
      dataInicio:
          data.dataInicio.present ? data.dataInicio.value : this.dataInicio,
      dataFim: data.dataFim.present ? data.dataFim.value : this.dataFim,
      status: data.status.present ? data.status.value : this.status,
      progressoFisico: data.progressoFisico.present
          ? data.progressoFisico.value
          : this.progressoFisico,
      progressoPrazoDias: data.progressoPrazoDias.present
          ? data.progressoPrazoDias.value
          : this.progressoPrazoDias,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Etapa(')
          ..write('id: $id, ')
          ..write('obraId: $obraId, ')
          ..write('nome: $nome, ')
          ..write('dataInicio: $dataInicio, ')
          ..write('dataFim: $dataFim, ')
          ..write('status: $status, ')
          ..write('progressoFisico: $progressoFisico, ')
          ..write('progressoPrazoDias: $progressoPrazoDias')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, obraId, nome, dataInicio, dataFim, status,
      progressoFisico, progressoPrazoDias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Etapa &&
          other.id == this.id &&
          other.obraId == this.obraId &&
          other.nome == this.nome &&
          other.dataInicio == this.dataInicio &&
          other.dataFim == this.dataFim &&
          other.status == this.status &&
          other.progressoFisico == this.progressoFisico &&
          other.progressoPrazoDias == this.progressoPrazoDias);
}

class EtapasCompanion extends UpdateCompanion<Etapa> {
  final Value<String> id;
  final Value<String> obraId;
  final Value<String> nome;
  final Value<DateTime> dataInicio;
  final Value<DateTime> dataFim;
  final Value<String> status;
  final Value<double> progressoFisico;
  final Value<int> progressoPrazoDias;
  final Value<int> rowid;
  const EtapasCompanion({
    this.id = const Value.absent(),
    this.obraId = const Value.absent(),
    this.nome = const Value.absent(),
    this.dataInicio = const Value.absent(),
    this.dataFim = const Value.absent(),
    this.status = const Value.absent(),
    this.progressoFisico = const Value.absent(),
    this.progressoPrazoDias = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EtapasCompanion.insert({
    required String id,
    required String obraId,
    required String nome,
    required DateTime dataInicio,
    required DateTime dataFim,
    required String status,
    this.progressoFisico = const Value.absent(),
    this.progressoPrazoDias = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        obraId = Value(obraId),
        nome = Value(nome),
        dataInicio = Value(dataInicio),
        dataFim = Value(dataFim),
        status = Value(status);
  static Insertable<Etapa> custom({
    Expression<String>? id,
    Expression<String>? obraId,
    Expression<String>? nome,
    Expression<DateTime>? dataInicio,
    Expression<DateTime>? dataFim,
    Expression<String>? status,
    Expression<double>? progressoFisico,
    Expression<int>? progressoPrazoDias,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (obraId != null) 'obra_id': obraId,
      if (nome != null) 'nome': nome,
      if (dataInicio != null) 'data_inicio': dataInicio,
      if (dataFim != null) 'data_fim': dataFim,
      if (status != null) 'status': status,
      if (progressoFisico != null) 'progresso_fisico': progressoFisico,
      if (progressoPrazoDias != null)
        'progresso_prazo_dias': progressoPrazoDias,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EtapasCompanion copyWith(
      {Value<String>? id,
      Value<String>? obraId,
      Value<String>? nome,
      Value<DateTime>? dataInicio,
      Value<DateTime>? dataFim,
      Value<String>? status,
      Value<double>? progressoFisico,
      Value<int>? progressoPrazoDias,
      Value<int>? rowid}) {
    return EtapasCompanion(
      id: id ?? this.id,
      obraId: obraId ?? this.obraId,
      nome: nome ?? this.nome,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      status: status ?? this.status,
      progressoFisico: progressoFisico ?? this.progressoFisico,
      progressoPrazoDias: progressoPrazoDias ?? this.progressoPrazoDias,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (obraId.present) {
      map['obra_id'] = Variable<String>(obraId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (dataInicio.present) {
      map['data_inicio'] = Variable<DateTime>(dataInicio.value);
    }
    if (dataFim.present) {
      map['data_fim'] = Variable<DateTime>(dataFim.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (progressoFisico.present) {
      map['progresso_fisico'] = Variable<double>(progressoFisico.value);
    }
    if (progressoPrazoDias.present) {
      map['progresso_prazo_dias'] = Variable<int>(progressoPrazoDias.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EtapasCompanion(')
          ..write('id: $id, ')
          ..write('obraId: $obraId, ')
          ..write('nome: $nome, ')
          ..write('dataInicio: $dataInicio, ')
          ..write('dataFim: $dataFim, ')
          ..write('status: $status, ')
          ..write('progressoFisico: $progressoFisico, ')
          ..write('progressoPrazoDias: $progressoPrazoDias, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServicosTable extends Servicos with TableInfo<$ServicosTable, Servico> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _etapaIdMeta =
      const VerificationMeta('etapaId');
  @override
  late final GeneratedColumn<String> etapaId = GeneratedColumn<String>(
      'etapa_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES etapas (id)'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _precoTotalMeta =
      const VerificationMeta('precoTotal');
  @override
  late final GeneratedColumn<double> precoTotal = GeneratedColumn<double>(
      'preco_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unidadeMeta =
      const VerificationMeta('unidade');
  @override
  late final GeneratedColumn<String> unidade = GeneratedColumn<String>(
      'unidade', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantidadeMeta =
      const VerificationMeta('quantidade');
  @override
  late final GeneratedColumn<double> quantidade = GeneratedColumn<double>(
      'quantidade', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dataInicioMeta =
      const VerificationMeta('dataInicio');
  @override
  late final GeneratedColumn<DateTime> dataInicio = GeneratedColumn<DateTime>(
      'data_inicio', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dataFimMeta =
      const VerificationMeta('dataFim');
  @override
  late final GeneratedColumn<DateTime> dataFim = GeneratedColumn<DateTime>(
      'data_fim', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressoFisicoMeta =
      const VerificationMeta('progressoFisico');
  @override
  late final GeneratedColumn<double> progressoFisico = GeneratedColumn<double>(
      'progresso_fisico', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _progressoPrazoDiasMeta =
      const VerificationMeta('progressoPrazoDias');
  @override
  late final GeneratedColumn<int> progressoPrazoDias = GeneratedColumn<int>(
      'progresso_prazo_dias', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        etapaId,
        nome,
        precoTotal,
        unidade,
        quantidade,
        dataInicio,
        dataFim,
        status,
        progressoFisico,
        progressoPrazoDias
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servicos';
  @override
  VerificationContext validateIntegrity(Insertable<Servico> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('etapa_id')) {
      context.handle(_etapaIdMeta,
          etapaId.isAcceptableOrUnknown(data['etapa_id']!, _etapaIdMeta));
    } else if (isInserting) {
      context.missing(_etapaIdMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('preco_total')) {
      context.handle(
          _precoTotalMeta,
          precoTotal.isAcceptableOrUnknown(
              data['preco_total']!, _precoTotalMeta));
    } else if (isInserting) {
      context.missing(_precoTotalMeta);
    }
    if (data.containsKey('unidade')) {
      context.handle(_unidadeMeta,
          unidade.isAcceptableOrUnknown(data['unidade']!, _unidadeMeta));
    } else if (isInserting) {
      context.missing(_unidadeMeta);
    }
    if (data.containsKey('quantidade')) {
      context.handle(
          _quantidadeMeta,
          quantidade.isAcceptableOrUnknown(
              data['quantidade']!, _quantidadeMeta));
    } else if (isInserting) {
      context.missing(_quantidadeMeta);
    }
    if (data.containsKey('data_inicio')) {
      context.handle(
          _dataInicioMeta,
          dataInicio.isAcceptableOrUnknown(
              data['data_inicio']!, _dataInicioMeta));
    } else if (isInserting) {
      context.missing(_dataInicioMeta);
    }
    if (data.containsKey('data_fim')) {
      context.handle(_dataFimMeta,
          dataFim.isAcceptableOrUnknown(data['data_fim']!, _dataFimMeta));
    } else if (isInserting) {
      context.missing(_dataFimMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('progresso_fisico')) {
      context.handle(
          _progressoFisicoMeta,
          progressoFisico.isAcceptableOrUnknown(
              data['progresso_fisico']!, _progressoFisicoMeta));
    }
    if (data.containsKey('progresso_prazo_dias')) {
      context.handle(
          _progressoPrazoDiasMeta,
          progressoPrazoDias.isAcceptableOrUnknown(
              data['progresso_prazo_dias']!, _progressoPrazoDiasMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Servico map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Servico(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      etapaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}etapa_id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      precoTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}preco_total'])!,
      unidade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unidade'])!,
      quantidade: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantidade'])!,
      dataInicio: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_inicio'])!,
      dataFim: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_fim'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      progressoFisico: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}progresso_fisico'])!,
      progressoPrazoDias: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}progresso_prazo_dias'])!,
    );
  }

  @override
  $ServicosTable createAlias(String alias) {
    return $ServicosTable(attachedDatabase, alias);
  }
}

class Servico extends DataClass implements Insertable<Servico> {
  final String id;
  final String etapaId;
  final String nome;
  final double precoTotal;
  final String unidade;
  final double quantidade;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String status;
  final double progressoFisico;
  final int progressoPrazoDias;
  const Servico(
      {required this.id,
      required this.etapaId,
      required this.nome,
      required this.precoTotal,
      required this.unidade,
      required this.quantidade,
      required this.dataInicio,
      required this.dataFim,
      required this.status,
      required this.progressoFisico,
      required this.progressoPrazoDias});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['etapa_id'] = Variable<String>(etapaId);
    map['nome'] = Variable<String>(nome);
    map['preco_total'] = Variable<double>(precoTotal);
    map['unidade'] = Variable<String>(unidade);
    map['quantidade'] = Variable<double>(quantidade);
    map['data_inicio'] = Variable<DateTime>(dataInicio);
    map['data_fim'] = Variable<DateTime>(dataFim);
    map['status'] = Variable<String>(status);
    map['progresso_fisico'] = Variable<double>(progressoFisico);
    map['progresso_prazo_dias'] = Variable<int>(progressoPrazoDias);
    return map;
  }

  ServicosCompanion toCompanion(bool nullToAbsent) {
    return ServicosCompanion(
      id: Value(id),
      etapaId: Value(etapaId),
      nome: Value(nome),
      precoTotal: Value(precoTotal),
      unidade: Value(unidade),
      quantidade: Value(quantidade),
      dataInicio: Value(dataInicio),
      dataFim: Value(dataFim),
      status: Value(status),
      progressoFisico: Value(progressoFisico),
      progressoPrazoDias: Value(progressoPrazoDias),
    );
  }

  factory Servico.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Servico(
      id: serializer.fromJson<String>(json['id']),
      etapaId: serializer.fromJson<String>(json['etapaId']),
      nome: serializer.fromJson<String>(json['nome']),
      precoTotal: serializer.fromJson<double>(json['precoTotal']),
      unidade: serializer.fromJson<String>(json['unidade']),
      quantidade: serializer.fromJson<double>(json['quantidade']),
      dataInicio: serializer.fromJson<DateTime>(json['dataInicio']),
      dataFim: serializer.fromJson<DateTime>(json['dataFim']),
      status: serializer.fromJson<String>(json['status']),
      progressoFisico: serializer.fromJson<double>(json['progressoFisico']),
      progressoPrazoDias: serializer.fromJson<int>(json['progressoPrazoDias']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'etapaId': serializer.toJson<String>(etapaId),
      'nome': serializer.toJson<String>(nome),
      'precoTotal': serializer.toJson<double>(precoTotal),
      'unidade': serializer.toJson<String>(unidade),
      'quantidade': serializer.toJson<double>(quantidade),
      'dataInicio': serializer.toJson<DateTime>(dataInicio),
      'dataFim': serializer.toJson<DateTime>(dataFim),
      'status': serializer.toJson<String>(status),
      'progressoFisico': serializer.toJson<double>(progressoFisico),
      'progressoPrazoDias': serializer.toJson<int>(progressoPrazoDias),
    };
  }

  Servico copyWith(
          {String? id,
          String? etapaId,
          String? nome,
          double? precoTotal,
          String? unidade,
          double? quantidade,
          DateTime? dataInicio,
          DateTime? dataFim,
          String? status,
          double? progressoFisico,
          int? progressoPrazoDias}) =>
      Servico(
        id: id ?? this.id,
        etapaId: etapaId ?? this.etapaId,
        nome: nome ?? this.nome,
        precoTotal: precoTotal ?? this.precoTotal,
        unidade: unidade ?? this.unidade,
        quantidade: quantidade ?? this.quantidade,
        dataInicio: dataInicio ?? this.dataInicio,
        dataFim: dataFim ?? this.dataFim,
        status: status ?? this.status,
        progressoFisico: progressoFisico ?? this.progressoFisico,
        progressoPrazoDias: progressoPrazoDias ?? this.progressoPrazoDias,
      );
  Servico copyWithCompanion(ServicosCompanion data) {
    return Servico(
      id: data.id.present ? data.id.value : this.id,
      etapaId: data.etapaId.present ? data.etapaId.value : this.etapaId,
      nome: data.nome.present ? data.nome.value : this.nome,
      precoTotal:
          data.precoTotal.present ? data.precoTotal.value : this.precoTotal,
      unidade: data.unidade.present ? data.unidade.value : this.unidade,
      quantidade:
          data.quantidade.present ? data.quantidade.value : this.quantidade,
      dataInicio:
          data.dataInicio.present ? data.dataInicio.value : this.dataInicio,
      dataFim: data.dataFim.present ? data.dataFim.value : this.dataFim,
      status: data.status.present ? data.status.value : this.status,
      progressoFisico: data.progressoFisico.present
          ? data.progressoFisico.value
          : this.progressoFisico,
      progressoPrazoDias: data.progressoPrazoDias.present
          ? data.progressoPrazoDias.value
          : this.progressoPrazoDias,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Servico(')
          ..write('id: $id, ')
          ..write('etapaId: $etapaId, ')
          ..write('nome: $nome, ')
          ..write('precoTotal: $precoTotal, ')
          ..write('unidade: $unidade, ')
          ..write('quantidade: $quantidade, ')
          ..write('dataInicio: $dataInicio, ')
          ..write('dataFim: $dataFim, ')
          ..write('status: $status, ')
          ..write('progressoFisico: $progressoFisico, ')
          ..write('progressoPrazoDias: $progressoPrazoDias')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      etapaId,
      nome,
      precoTotal,
      unidade,
      quantidade,
      dataInicio,
      dataFim,
      status,
      progressoFisico,
      progressoPrazoDias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Servico &&
          other.id == this.id &&
          other.etapaId == this.etapaId &&
          other.nome == this.nome &&
          other.precoTotal == this.precoTotal &&
          other.unidade == this.unidade &&
          other.quantidade == this.quantidade &&
          other.dataInicio == this.dataInicio &&
          other.dataFim == this.dataFim &&
          other.status == this.status &&
          other.progressoFisico == this.progressoFisico &&
          other.progressoPrazoDias == this.progressoPrazoDias);
}

class ServicosCompanion extends UpdateCompanion<Servico> {
  final Value<String> id;
  final Value<String> etapaId;
  final Value<String> nome;
  final Value<double> precoTotal;
  final Value<String> unidade;
  final Value<double> quantidade;
  final Value<DateTime> dataInicio;
  final Value<DateTime> dataFim;
  final Value<String> status;
  final Value<double> progressoFisico;
  final Value<int> progressoPrazoDias;
  final Value<int> rowid;
  const ServicosCompanion({
    this.id = const Value.absent(),
    this.etapaId = const Value.absent(),
    this.nome = const Value.absent(),
    this.precoTotal = const Value.absent(),
    this.unidade = const Value.absent(),
    this.quantidade = const Value.absent(),
    this.dataInicio = const Value.absent(),
    this.dataFim = const Value.absent(),
    this.status = const Value.absent(),
    this.progressoFisico = const Value.absent(),
    this.progressoPrazoDias = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServicosCompanion.insert({
    required String id,
    required String etapaId,
    required String nome,
    required double precoTotal,
    required String unidade,
    required double quantidade,
    required DateTime dataInicio,
    required DateTime dataFim,
    required String status,
    this.progressoFisico = const Value.absent(),
    this.progressoPrazoDias = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        etapaId = Value(etapaId),
        nome = Value(nome),
        precoTotal = Value(precoTotal),
        unidade = Value(unidade),
        quantidade = Value(quantidade),
        dataInicio = Value(dataInicio),
        dataFim = Value(dataFim),
        status = Value(status);
  static Insertable<Servico> custom({
    Expression<String>? id,
    Expression<String>? etapaId,
    Expression<String>? nome,
    Expression<double>? precoTotal,
    Expression<String>? unidade,
    Expression<double>? quantidade,
    Expression<DateTime>? dataInicio,
    Expression<DateTime>? dataFim,
    Expression<String>? status,
    Expression<double>? progressoFisico,
    Expression<int>? progressoPrazoDias,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (etapaId != null) 'etapa_id': etapaId,
      if (nome != null) 'nome': nome,
      if (precoTotal != null) 'preco_total': precoTotal,
      if (unidade != null) 'unidade': unidade,
      if (quantidade != null) 'quantidade': quantidade,
      if (dataInicio != null) 'data_inicio': dataInicio,
      if (dataFim != null) 'data_fim': dataFim,
      if (status != null) 'status': status,
      if (progressoFisico != null) 'progresso_fisico': progressoFisico,
      if (progressoPrazoDias != null)
        'progresso_prazo_dias': progressoPrazoDias,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServicosCompanion copyWith(
      {Value<String>? id,
      Value<String>? etapaId,
      Value<String>? nome,
      Value<double>? precoTotal,
      Value<String>? unidade,
      Value<double>? quantidade,
      Value<DateTime>? dataInicio,
      Value<DateTime>? dataFim,
      Value<String>? status,
      Value<double>? progressoFisico,
      Value<int>? progressoPrazoDias,
      Value<int>? rowid}) {
    return ServicosCompanion(
      id: id ?? this.id,
      etapaId: etapaId ?? this.etapaId,
      nome: nome ?? this.nome,
      precoTotal: precoTotal ?? this.precoTotal,
      unidade: unidade ?? this.unidade,
      quantidade: quantidade ?? this.quantidade,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      status: status ?? this.status,
      progressoFisico: progressoFisico ?? this.progressoFisico,
      progressoPrazoDias: progressoPrazoDias ?? this.progressoPrazoDias,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (etapaId.present) {
      map['etapa_id'] = Variable<String>(etapaId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (precoTotal.present) {
      map['preco_total'] = Variable<double>(precoTotal.value);
    }
    if (unidade.present) {
      map['unidade'] = Variable<String>(unidade.value);
    }
    if (quantidade.present) {
      map['quantidade'] = Variable<double>(quantidade.value);
    }
    if (dataInicio.present) {
      map['data_inicio'] = Variable<DateTime>(dataInicio.value);
    }
    if (dataFim.present) {
      map['data_fim'] = Variable<DateTime>(dataFim.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (progressoFisico.present) {
      map['progresso_fisico'] = Variable<double>(progressoFisico.value);
    }
    if (progressoPrazoDias.present) {
      map['progresso_prazo_dias'] = Variable<int>(progressoPrazoDias.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicosCompanion(')
          ..write('id: $id, ')
          ..write('etapaId: $etapaId, ')
          ..write('nome: $nome, ')
          ..write('precoTotal: $precoTotal, ')
          ..write('unidade: $unidade, ')
          ..write('quantidade: $quantidade, ')
          ..write('dataInicio: $dataInicio, ')
          ..write('dataFim: $dataFim, ')
          ..write('status: $status, ')
          ..write('progressoFisico: $progressoFisico, ')
          ..write('progressoPrazoDias: $progressoPrazoDias, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VistoriasServicoTable extends VistoriasServico
    with TableInfo<$VistoriasServicoTable, VistoriasServicoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VistoriasServicoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _servicoIdMeta =
      const VerificationMeta('servicoId');
  @override
  late final GeneratedColumn<String> servicoId = GeneratedColumn<String>(
      'servico_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES servicos (id)'));
  static const VerificationMeta _obraIdMeta = const VerificationMeta('obraId');
  @override
  late final GeneratedColumn<String> obraId = GeneratedColumn<String>(
      'obra_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES obras (id)'));
  static const VerificationMeta _contratanteIdMeta =
      const VerificationMeta('contratanteId');
  @override
  late final GeneratedColumn<String> contratanteId = GeneratedColumn<String>(
      'contratante_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES contratantes (id)'));
  static const VerificationMeta _responsavelIdMeta =
      const VerificationMeta('responsavelId');
  @override
  late final GeneratedColumn<String> responsavelId = GeneratedColumn<String>(
      'responsavel_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES funcionarios (id)'));
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
      'numero', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
      'data', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _diaSemanaMeta =
      const VerificationMeta('diaSemana');
  @override
  late final GeneratedColumn<int> diaSemana = GeneratedColumn<int>(
      'dia_semana', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ocorrenciaMeta =
      const VerificationMeta('ocorrencia');
  @override
  late final GeneratedColumn<String> ocorrencia = GeneratedColumn<String>(
      'ocorrencia', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _comentarioMeta =
      const VerificationMeta('comentario');
  @override
  late final GeneratedColumn<String> comentario = GeneratedColumn<String>(
      'comentario', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        servicoId,
        obraId,
        contratanteId,
        responsavelId,
        numero,
        data,
        diaSemana,
        status,
        ocorrencia,
        comentario
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vistorias_servico';
  @override
  VerificationContext validateIntegrity(
      Insertable<VistoriasServicoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('servico_id')) {
      context.handle(_servicoIdMeta,
          servicoId.isAcceptableOrUnknown(data['servico_id']!, _servicoIdMeta));
    } else if (isInserting) {
      context.missing(_servicoIdMeta);
    }
    if (data.containsKey('obra_id')) {
      context.handle(_obraIdMeta,
          obraId.isAcceptableOrUnknown(data['obra_id']!, _obraIdMeta));
    } else if (isInserting) {
      context.missing(_obraIdMeta);
    }
    if (data.containsKey('contratante_id')) {
      context.handle(
          _contratanteIdMeta,
          contratanteId.isAcceptableOrUnknown(
              data['contratante_id']!, _contratanteIdMeta));
    } else if (isInserting) {
      context.missing(_contratanteIdMeta);
    }
    if (data.containsKey('responsavel_id')) {
      context.handle(
          _responsavelIdMeta,
          responsavelId.isAcceptableOrUnknown(
              data['responsavel_id']!, _responsavelIdMeta));
    } else if (isInserting) {
      context.missing(_responsavelIdMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('dia_semana')) {
      context.handle(_diaSemanaMeta,
          diaSemana.isAcceptableOrUnknown(data['dia_semana']!, _diaSemanaMeta));
    } else if (isInserting) {
      context.missing(_diaSemanaMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('ocorrencia')) {
      context.handle(
          _ocorrenciaMeta,
          ocorrencia.isAcceptableOrUnknown(
              data['ocorrencia']!, _ocorrenciaMeta));
    }
    if (data.containsKey('comentario')) {
      context.handle(
          _comentarioMeta,
          comentario.isAcceptableOrUnknown(
              data['comentario']!, _comentarioMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {servicoId, data},
      ];
  @override
  VistoriasServicoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VistoriasServicoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      servicoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}servico_id'])!,
      obraId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}obra_id'])!,
      contratanteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contratante_id'])!,
      responsavelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}responsavel_id'])!,
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data'])!,
      diaSemana: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dia_semana'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      ocorrencia: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ocorrencia']),
      comentario: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comentario']),
    );
  }

  @override
  $VistoriasServicoTable createAlias(String alias) {
    return $VistoriasServicoTable(attachedDatabase, alias);
  }
}

class VistoriasServicoData extends DataClass
    implements Insertable<VistoriasServicoData> {
  final String id;
  final String servicoId;
  final String obraId;
  final String contratanteId;
  final String responsavelId;
  final String numero;
  final DateTime data;
  final int diaSemana;
  final String status;
  final String? ocorrencia;
  final String? comentario;
  const VistoriasServicoData(
      {required this.id,
      required this.servicoId,
      required this.obraId,
      required this.contratanteId,
      required this.responsavelId,
      required this.numero,
      required this.data,
      required this.diaSemana,
      required this.status,
      this.ocorrencia,
      this.comentario});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['servico_id'] = Variable<String>(servicoId);
    map['obra_id'] = Variable<String>(obraId);
    map['contratante_id'] = Variable<String>(contratanteId);
    map['responsavel_id'] = Variable<String>(responsavelId);
    map['numero'] = Variable<String>(numero);
    map['data'] = Variable<DateTime>(data);
    map['dia_semana'] = Variable<int>(diaSemana);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || ocorrencia != null) {
      map['ocorrencia'] = Variable<String>(ocorrencia);
    }
    if (!nullToAbsent || comentario != null) {
      map['comentario'] = Variable<String>(comentario);
    }
    return map;
  }

  VistoriasServicoCompanion toCompanion(bool nullToAbsent) {
    return VistoriasServicoCompanion(
      id: Value(id),
      servicoId: Value(servicoId),
      obraId: Value(obraId),
      contratanteId: Value(contratanteId),
      responsavelId: Value(responsavelId),
      numero: Value(numero),
      data: Value(data),
      diaSemana: Value(diaSemana),
      status: Value(status),
      ocorrencia: ocorrencia == null && nullToAbsent
          ? const Value.absent()
          : Value(ocorrencia),
      comentario: comentario == null && nullToAbsent
          ? const Value.absent()
          : Value(comentario),
    );
  }

  factory VistoriasServicoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VistoriasServicoData(
      id: serializer.fromJson<String>(json['id']),
      servicoId: serializer.fromJson<String>(json['servicoId']),
      obraId: serializer.fromJson<String>(json['obraId']),
      contratanteId: serializer.fromJson<String>(json['contratanteId']),
      responsavelId: serializer.fromJson<String>(json['responsavelId']),
      numero: serializer.fromJson<String>(json['numero']),
      data: serializer.fromJson<DateTime>(json['data']),
      diaSemana: serializer.fromJson<int>(json['diaSemana']),
      status: serializer.fromJson<String>(json['status']),
      ocorrencia: serializer.fromJson<String?>(json['ocorrencia']),
      comentario: serializer.fromJson<String?>(json['comentario']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'servicoId': serializer.toJson<String>(servicoId),
      'obraId': serializer.toJson<String>(obraId),
      'contratanteId': serializer.toJson<String>(contratanteId),
      'responsavelId': serializer.toJson<String>(responsavelId),
      'numero': serializer.toJson<String>(numero),
      'data': serializer.toJson<DateTime>(data),
      'diaSemana': serializer.toJson<int>(diaSemana),
      'status': serializer.toJson<String>(status),
      'ocorrencia': serializer.toJson<String?>(ocorrencia),
      'comentario': serializer.toJson<String?>(comentario),
    };
  }

  VistoriasServicoData copyWith(
          {String? id,
          String? servicoId,
          String? obraId,
          String? contratanteId,
          String? responsavelId,
          String? numero,
          DateTime? data,
          int? diaSemana,
          String? status,
          Value<String?> ocorrencia = const Value.absent(),
          Value<String?> comentario = const Value.absent()}) =>
      VistoriasServicoData(
        id: id ?? this.id,
        servicoId: servicoId ?? this.servicoId,
        obraId: obraId ?? this.obraId,
        contratanteId: contratanteId ?? this.contratanteId,
        responsavelId: responsavelId ?? this.responsavelId,
        numero: numero ?? this.numero,
        data: data ?? this.data,
        diaSemana: diaSemana ?? this.diaSemana,
        status: status ?? this.status,
        ocorrencia: ocorrencia.present ? ocorrencia.value : this.ocorrencia,
        comentario: comentario.present ? comentario.value : this.comentario,
      );
  VistoriasServicoData copyWithCompanion(VistoriasServicoCompanion data) {
    return VistoriasServicoData(
      id: data.id.present ? data.id.value : this.id,
      servicoId: data.servicoId.present ? data.servicoId.value : this.servicoId,
      obraId: data.obraId.present ? data.obraId.value : this.obraId,
      contratanteId: data.contratanteId.present
          ? data.contratanteId.value
          : this.contratanteId,
      responsavelId: data.responsavelId.present
          ? data.responsavelId.value
          : this.responsavelId,
      numero: data.numero.present ? data.numero.value : this.numero,
      data: data.data.present ? data.data.value : this.data,
      diaSemana: data.diaSemana.present ? data.diaSemana.value : this.diaSemana,
      status: data.status.present ? data.status.value : this.status,
      ocorrencia:
          data.ocorrencia.present ? data.ocorrencia.value : this.ocorrencia,
      comentario:
          data.comentario.present ? data.comentario.value : this.comentario,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VistoriasServicoData(')
          ..write('id: $id, ')
          ..write('servicoId: $servicoId, ')
          ..write('obraId: $obraId, ')
          ..write('contratanteId: $contratanteId, ')
          ..write('responsavelId: $responsavelId, ')
          ..write('numero: $numero, ')
          ..write('data: $data, ')
          ..write('diaSemana: $diaSemana, ')
          ..write('status: $status, ')
          ..write('ocorrencia: $ocorrencia, ')
          ..write('comentario: $comentario')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, servicoId, obraId, contratanteId,
      responsavelId, numero, data, diaSemana, status, ocorrencia, comentario);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VistoriasServicoData &&
          other.id == this.id &&
          other.servicoId == this.servicoId &&
          other.obraId == this.obraId &&
          other.contratanteId == this.contratanteId &&
          other.responsavelId == this.responsavelId &&
          other.numero == this.numero &&
          other.data == this.data &&
          other.diaSemana == this.diaSemana &&
          other.status == this.status &&
          other.ocorrencia == this.ocorrencia &&
          other.comentario == this.comentario);
}

class VistoriasServicoCompanion extends UpdateCompanion<VistoriasServicoData> {
  final Value<String> id;
  final Value<String> servicoId;
  final Value<String> obraId;
  final Value<String> contratanteId;
  final Value<String> responsavelId;
  final Value<String> numero;
  final Value<DateTime> data;
  final Value<int> diaSemana;
  final Value<String> status;
  final Value<String?> ocorrencia;
  final Value<String?> comentario;
  final Value<int> rowid;
  const VistoriasServicoCompanion({
    this.id = const Value.absent(),
    this.servicoId = const Value.absent(),
    this.obraId = const Value.absent(),
    this.contratanteId = const Value.absent(),
    this.responsavelId = const Value.absent(),
    this.numero = const Value.absent(),
    this.data = const Value.absent(),
    this.diaSemana = const Value.absent(),
    this.status = const Value.absent(),
    this.ocorrencia = const Value.absent(),
    this.comentario = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VistoriasServicoCompanion.insert({
    required String id,
    required String servicoId,
    required String obraId,
    required String contratanteId,
    required String responsavelId,
    required String numero,
    required DateTime data,
    required int diaSemana,
    required String status,
    this.ocorrencia = const Value.absent(),
    this.comentario = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        servicoId = Value(servicoId),
        obraId = Value(obraId),
        contratanteId = Value(contratanteId),
        responsavelId = Value(responsavelId),
        numero = Value(numero),
        data = Value(data),
        diaSemana = Value(diaSemana),
        status = Value(status);
  static Insertable<VistoriasServicoData> custom({
    Expression<String>? id,
    Expression<String>? servicoId,
    Expression<String>? obraId,
    Expression<String>? contratanteId,
    Expression<String>? responsavelId,
    Expression<String>? numero,
    Expression<DateTime>? data,
    Expression<int>? diaSemana,
    Expression<String>? status,
    Expression<String>? ocorrencia,
    Expression<String>? comentario,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (servicoId != null) 'servico_id': servicoId,
      if (obraId != null) 'obra_id': obraId,
      if (contratanteId != null) 'contratante_id': contratanteId,
      if (responsavelId != null) 'responsavel_id': responsavelId,
      if (numero != null) 'numero': numero,
      if (data != null) 'data': data,
      if (diaSemana != null) 'dia_semana': diaSemana,
      if (status != null) 'status': status,
      if (ocorrencia != null) 'ocorrencia': ocorrencia,
      if (comentario != null) 'comentario': comentario,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VistoriasServicoCompanion copyWith(
      {Value<String>? id,
      Value<String>? servicoId,
      Value<String>? obraId,
      Value<String>? contratanteId,
      Value<String>? responsavelId,
      Value<String>? numero,
      Value<DateTime>? data,
      Value<int>? diaSemana,
      Value<String>? status,
      Value<String?>? ocorrencia,
      Value<String?>? comentario,
      Value<int>? rowid}) {
    return VistoriasServicoCompanion(
      id: id ?? this.id,
      servicoId: servicoId ?? this.servicoId,
      obraId: obraId ?? this.obraId,
      contratanteId: contratanteId ?? this.contratanteId,
      responsavelId: responsavelId ?? this.responsavelId,
      numero: numero ?? this.numero,
      data: data ?? this.data,
      diaSemana: diaSemana ?? this.diaSemana,
      status: status ?? this.status,
      ocorrencia: ocorrencia ?? this.ocorrencia,
      comentario: comentario ?? this.comentario,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (servicoId.present) {
      map['servico_id'] = Variable<String>(servicoId.value);
    }
    if (obraId.present) {
      map['obra_id'] = Variable<String>(obraId.value);
    }
    if (contratanteId.present) {
      map['contratante_id'] = Variable<String>(contratanteId.value);
    }
    if (responsavelId.present) {
      map['responsavel_id'] = Variable<String>(responsavelId.value);
    }
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (diaSemana.present) {
      map['dia_semana'] = Variable<int>(diaSemana.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (ocorrencia.present) {
      map['ocorrencia'] = Variable<String>(ocorrencia.value);
    }
    if (comentario.present) {
      map['comentario'] = Variable<String>(comentario.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VistoriasServicoCompanion(')
          ..write('id: $id, ')
          ..write('servicoId: $servicoId, ')
          ..write('obraId: $obraId, ')
          ..write('contratanteId: $contratanteId, ')
          ..write('responsavelId: $responsavelId, ')
          ..write('numero: $numero, ')
          ..write('data: $data, ')
          ..write('diaSemana: $diaSemana, ')
          ..write('status: $status, ')
          ..write('ocorrencia: $ocorrencia, ')
          ..write('comentario: $comentario, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VistoriasPeriodoTable extends VistoriasPeriodo
    with TableInfo<$VistoriasPeriodoTable, VistoriasPeriodoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VistoriasPeriodoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _vistoriaServicoIdMeta =
      const VerificationMeta('vistoriaServicoId');
  @override
  late final GeneratedColumn<String> vistoriaServicoId =
      GeneratedColumn<String>('vistoria_servico_id', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES vistorias_servico (id)'));
  static const VerificationMeta _periodoMeta =
      const VerificationMeta('periodo');
  @override
  late final GeneratedColumn<String> periodo = GeneratedColumn<String>(
      'periodo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tempoMeta = const VerificationMeta('tempo');
  @override
  late final GeneratedColumn<String> tempo = GeneratedColumn<String>(
      'tempo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _condicaoMeta =
      const VerificationMeta('condicao');
  @override
  late final GeneratedColumn<String> condicao = GeneratedColumn<String>(
      'condicao', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, vistoriaServicoId, periodo, tempo, condicao];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vistorias_periodo';
  @override
  VerificationContext validateIntegrity(
      Insertable<VistoriasPeriodoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vistoria_servico_id')) {
      context.handle(
          _vistoriaServicoIdMeta,
          vistoriaServicoId.isAcceptableOrUnknown(
              data['vistoria_servico_id']!, _vistoriaServicoIdMeta));
    } else if (isInserting) {
      context.missing(_vistoriaServicoIdMeta);
    }
    if (data.containsKey('periodo')) {
      context.handle(_periodoMeta,
          periodo.isAcceptableOrUnknown(data['periodo']!, _periodoMeta));
    } else if (isInserting) {
      context.missing(_periodoMeta);
    }
    if (data.containsKey('tempo')) {
      context.handle(
          _tempoMeta, tempo.isAcceptableOrUnknown(data['tempo']!, _tempoMeta));
    } else if (isInserting) {
      context.missing(_tempoMeta);
    }
    if (data.containsKey('condicao')) {
      context.handle(_condicaoMeta,
          condicao.isAcceptableOrUnknown(data['condicao']!, _condicaoMeta));
    } else if (isInserting) {
      context.missing(_condicaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {vistoriaServicoId, periodo},
      ];
  @override
  VistoriasPeriodoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VistoriasPeriodoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      vistoriaServicoId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}vistoria_servico_id'])!,
      periodo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}periodo'])!,
      tempo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tempo'])!,
      condicao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condicao'])!,
    );
  }

  @override
  $VistoriasPeriodoTable createAlias(String alias) {
    return $VistoriasPeriodoTable(attachedDatabase, alias);
  }
}

class VistoriasPeriodoData extends DataClass
    implements Insertable<VistoriasPeriodoData> {
  final String id;
  final String vistoriaServicoId;
  final String periodo;
  final String tempo;
  final String condicao;
  const VistoriasPeriodoData(
      {required this.id,
      required this.vistoriaServicoId,
      required this.periodo,
      required this.tempo,
      required this.condicao});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vistoria_servico_id'] = Variable<String>(vistoriaServicoId);
    map['periodo'] = Variable<String>(periodo);
    map['tempo'] = Variable<String>(tempo);
    map['condicao'] = Variable<String>(condicao);
    return map;
  }

  VistoriasPeriodoCompanion toCompanion(bool nullToAbsent) {
    return VistoriasPeriodoCompanion(
      id: Value(id),
      vistoriaServicoId: Value(vistoriaServicoId),
      periodo: Value(periodo),
      tempo: Value(tempo),
      condicao: Value(condicao),
    );
  }

  factory VistoriasPeriodoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VistoriasPeriodoData(
      id: serializer.fromJson<String>(json['id']),
      vistoriaServicoId: serializer.fromJson<String>(json['vistoriaServicoId']),
      periodo: serializer.fromJson<String>(json['periodo']),
      tempo: serializer.fromJson<String>(json['tempo']),
      condicao: serializer.fromJson<String>(json['condicao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vistoriaServicoId': serializer.toJson<String>(vistoriaServicoId),
      'periodo': serializer.toJson<String>(periodo),
      'tempo': serializer.toJson<String>(tempo),
      'condicao': serializer.toJson<String>(condicao),
    };
  }

  VistoriasPeriodoData copyWith(
          {String? id,
          String? vistoriaServicoId,
          String? periodo,
          String? tempo,
          String? condicao}) =>
      VistoriasPeriodoData(
        id: id ?? this.id,
        vistoriaServicoId: vistoriaServicoId ?? this.vistoriaServicoId,
        periodo: periodo ?? this.periodo,
        tempo: tempo ?? this.tempo,
        condicao: condicao ?? this.condicao,
      );
  VistoriasPeriodoData copyWithCompanion(VistoriasPeriodoCompanion data) {
    return VistoriasPeriodoData(
      id: data.id.present ? data.id.value : this.id,
      vistoriaServicoId: data.vistoriaServicoId.present
          ? data.vistoriaServicoId.value
          : this.vistoriaServicoId,
      periodo: data.periodo.present ? data.periodo.value : this.periodo,
      tempo: data.tempo.present ? data.tempo.value : this.tempo,
      condicao: data.condicao.present ? data.condicao.value : this.condicao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VistoriasPeriodoData(')
          ..write('id: $id, ')
          ..write('vistoriaServicoId: $vistoriaServicoId, ')
          ..write('periodo: $periodo, ')
          ..write('tempo: $tempo, ')
          ..write('condicao: $condicao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, vistoriaServicoId, periodo, tempo, condicao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VistoriasPeriodoData &&
          other.id == this.id &&
          other.vistoriaServicoId == this.vistoriaServicoId &&
          other.periodo == this.periodo &&
          other.tempo == this.tempo &&
          other.condicao == this.condicao);
}

class VistoriasPeriodoCompanion extends UpdateCompanion<VistoriasPeriodoData> {
  final Value<String> id;
  final Value<String> vistoriaServicoId;
  final Value<String> periodo;
  final Value<String> tempo;
  final Value<String> condicao;
  final Value<int> rowid;
  const VistoriasPeriodoCompanion({
    this.id = const Value.absent(),
    this.vistoriaServicoId = const Value.absent(),
    this.periodo = const Value.absent(),
    this.tempo = const Value.absent(),
    this.condicao = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VistoriasPeriodoCompanion.insert({
    required String id,
    required String vistoriaServicoId,
    required String periodo,
    required String tempo,
    required String condicao,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        vistoriaServicoId = Value(vistoriaServicoId),
        periodo = Value(periodo),
        tempo = Value(tempo),
        condicao = Value(condicao);
  static Insertable<VistoriasPeriodoData> custom({
    Expression<String>? id,
    Expression<String>? vistoriaServicoId,
    Expression<String>? periodo,
    Expression<String>? tempo,
    Expression<String>? condicao,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vistoriaServicoId != null) 'vistoria_servico_id': vistoriaServicoId,
      if (periodo != null) 'periodo': periodo,
      if (tempo != null) 'tempo': tempo,
      if (condicao != null) 'condicao': condicao,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VistoriasPeriodoCompanion copyWith(
      {Value<String>? id,
      Value<String>? vistoriaServicoId,
      Value<String>? periodo,
      Value<String>? tempo,
      Value<String>? condicao,
      Value<int>? rowid}) {
    return VistoriasPeriodoCompanion(
      id: id ?? this.id,
      vistoriaServicoId: vistoriaServicoId ?? this.vistoriaServicoId,
      periodo: periodo ?? this.periodo,
      tempo: tempo ?? this.tempo,
      condicao: condicao ?? this.condicao,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vistoriaServicoId.present) {
      map['vistoria_servico_id'] = Variable<String>(vistoriaServicoId.value);
    }
    if (periodo.present) {
      map['periodo'] = Variable<String>(periodo.value);
    }
    if (tempo.present) {
      map['tempo'] = Variable<String>(tempo.value);
    }
    if (condicao.present) {
      map['condicao'] = Variable<String>(condicao.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VistoriasPeriodoCompanion(')
          ..write('id: $id, ')
          ..write('vistoriaServicoId: $vistoriaServicoId, ')
          ..write('periodo: $periodo, ')
          ..write('tempo: $tempo, ')
          ..write('condicao: $condicao, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VistoriasMaoDeObraTable extends VistoriasMaoDeObra
    with TableInfo<$VistoriasMaoDeObraTable, VistoriasMaoDeObraData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VistoriasMaoDeObraTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _vistoriaServicoIdMeta =
      const VerificationMeta('vistoriaServicoId');
  @override
  late final GeneratedColumn<String> vistoriaServicoId =
      GeneratedColumn<String>('vistoria_servico_id', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES vistorias_servico (id)'));
  static const VerificationMeta _funcionarioIdMeta =
      const VerificationMeta('funcionarioId');
  @override
  late final GeneratedColumn<String> funcionarioId = GeneratedColumn<String>(
      'funcionario_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES funcionarios (id)'));
  static const VerificationMeta _funcaoNoDiaMeta =
      const VerificationMeta('funcaoNoDia');
  @override
  late final GeneratedColumn<String> funcaoNoDia = GeneratedColumn<String>(
      'funcao_no_dia', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _observacaoMeta =
      const VerificationMeta('observacao');
  @override
  late final GeneratedColumn<String> observacao = GeneratedColumn<String>(
      'observacao', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, vistoriaServicoId, funcionarioId, funcaoNoDia, observacao];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vistorias_mao_de_obra';
  @override
  VerificationContext validateIntegrity(
      Insertable<VistoriasMaoDeObraData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vistoria_servico_id')) {
      context.handle(
          _vistoriaServicoIdMeta,
          vistoriaServicoId.isAcceptableOrUnknown(
              data['vistoria_servico_id']!, _vistoriaServicoIdMeta));
    } else if (isInserting) {
      context.missing(_vistoriaServicoIdMeta);
    }
    if (data.containsKey('funcionario_id')) {
      context.handle(
          _funcionarioIdMeta,
          funcionarioId.isAcceptableOrUnknown(
              data['funcionario_id']!, _funcionarioIdMeta));
    } else if (isInserting) {
      context.missing(_funcionarioIdMeta);
    }
    if (data.containsKey('funcao_no_dia')) {
      context.handle(
          _funcaoNoDiaMeta,
          funcaoNoDia.isAcceptableOrUnknown(
              data['funcao_no_dia']!, _funcaoNoDiaMeta));
    }
    if (data.containsKey('observacao')) {
      context.handle(
          _observacaoMeta,
          observacao.isAcceptableOrUnknown(
              data['observacao']!, _observacaoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VistoriasMaoDeObraData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VistoriasMaoDeObraData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      vistoriaServicoId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}vistoria_servico_id'])!,
      funcionarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}funcionario_id'])!,
      funcaoNoDia: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}funcao_no_dia']),
      observacao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacao']),
    );
  }

  @override
  $VistoriasMaoDeObraTable createAlias(String alias) {
    return $VistoriasMaoDeObraTable(attachedDatabase, alias);
  }
}

class VistoriasMaoDeObraData extends DataClass
    implements Insertable<VistoriasMaoDeObraData> {
  final String id;
  final String vistoriaServicoId;
  final String funcionarioId;
  final String? funcaoNoDia;
  final String? observacao;
  const VistoriasMaoDeObraData(
      {required this.id,
      required this.vistoriaServicoId,
      required this.funcionarioId,
      this.funcaoNoDia,
      this.observacao});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vistoria_servico_id'] = Variable<String>(vistoriaServicoId);
    map['funcionario_id'] = Variable<String>(funcionarioId);
    if (!nullToAbsent || funcaoNoDia != null) {
      map['funcao_no_dia'] = Variable<String>(funcaoNoDia);
    }
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    return map;
  }

  VistoriasMaoDeObraCompanion toCompanion(bool nullToAbsent) {
    return VistoriasMaoDeObraCompanion(
      id: Value(id),
      vistoriaServicoId: Value(vistoriaServicoId),
      funcionarioId: Value(funcionarioId),
      funcaoNoDia: funcaoNoDia == null && nullToAbsent
          ? const Value.absent()
          : Value(funcaoNoDia),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
    );
  }

  factory VistoriasMaoDeObraData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VistoriasMaoDeObraData(
      id: serializer.fromJson<String>(json['id']),
      vistoriaServicoId: serializer.fromJson<String>(json['vistoriaServicoId']),
      funcionarioId: serializer.fromJson<String>(json['funcionarioId']),
      funcaoNoDia: serializer.fromJson<String?>(json['funcaoNoDia']),
      observacao: serializer.fromJson<String?>(json['observacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vistoriaServicoId': serializer.toJson<String>(vistoriaServicoId),
      'funcionarioId': serializer.toJson<String>(funcionarioId),
      'funcaoNoDia': serializer.toJson<String?>(funcaoNoDia),
      'observacao': serializer.toJson<String?>(observacao),
    };
  }

  VistoriasMaoDeObraData copyWith(
          {String? id,
          String? vistoriaServicoId,
          String? funcionarioId,
          Value<String?> funcaoNoDia = const Value.absent(),
          Value<String?> observacao = const Value.absent()}) =>
      VistoriasMaoDeObraData(
        id: id ?? this.id,
        vistoriaServicoId: vistoriaServicoId ?? this.vistoriaServicoId,
        funcionarioId: funcionarioId ?? this.funcionarioId,
        funcaoNoDia: funcaoNoDia.present ? funcaoNoDia.value : this.funcaoNoDia,
        observacao: observacao.present ? observacao.value : this.observacao,
      );
  VistoriasMaoDeObraData copyWithCompanion(VistoriasMaoDeObraCompanion data) {
    return VistoriasMaoDeObraData(
      id: data.id.present ? data.id.value : this.id,
      vistoriaServicoId: data.vistoriaServicoId.present
          ? data.vistoriaServicoId.value
          : this.vistoriaServicoId,
      funcionarioId: data.funcionarioId.present
          ? data.funcionarioId.value
          : this.funcionarioId,
      funcaoNoDia:
          data.funcaoNoDia.present ? data.funcaoNoDia.value : this.funcaoNoDia,
      observacao:
          data.observacao.present ? data.observacao.value : this.observacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VistoriasMaoDeObraData(')
          ..write('id: $id, ')
          ..write('vistoriaServicoId: $vistoriaServicoId, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('funcaoNoDia: $funcaoNoDia, ')
          ..write('observacao: $observacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, vistoriaServicoId, funcionarioId, funcaoNoDia, observacao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VistoriasMaoDeObraData &&
          other.id == this.id &&
          other.vistoriaServicoId == this.vistoriaServicoId &&
          other.funcionarioId == this.funcionarioId &&
          other.funcaoNoDia == this.funcaoNoDia &&
          other.observacao == this.observacao);
}

class VistoriasMaoDeObraCompanion
    extends UpdateCompanion<VistoriasMaoDeObraData> {
  final Value<String> id;
  final Value<String> vistoriaServicoId;
  final Value<String> funcionarioId;
  final Value<String?> funcaoNoDia;
  final Value<String?> observacao;
  final Value<int> rowid;
  const VistoriasMaoDeObraCompanion({
    this.id = const Value.absent(),
    this.vistoriaServicoId = const Value.absent(),
    this.funcionarioId = const Value.absent(),
    this.funcaoNoDia = const Value.absent(),
    this.observacao = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VistoriasMaoDeObraCompanion.insert({
    required String id,
    required String vistoriaServicoId,
    required String funcionarioId,
    this.funcaoNoDia = const Value.absent(),
    this.observacao = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        vistoriaServicoId = Value(vistoriaServicoId),
        funcionarioId = Value(funcionarioId);
  static Insertable<VistoriasMaoDeObraData> custom({
    Expression<String>? id,
    Expression<String>? vistoriaServicoId,
    Expression<String>? funcionarioId,
    Expression<String>? funcaoNoDia,
    Expression<String>? observacao,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vistoriaServicoId != null) 'vistoria_servico_id': vistoriaServicoId,
      if (funcionarioId != null) 'funcionario_id': funcionarioId,
      if (funcaoNoDia != null) 'funcao_no_dia': funcaoNoDia,
      if (observacao != null) 'observacao': observacao,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VistoriasMaoDeObraCompanion copyWith(
      {Value<String>? id,
      Value<String>? vistoriaServicoId,
      Value<String>? funcionarioId,
      Value<String?>? funcaoNoDia,
      Value<String?>? observacao,
      Value<int>? rowid}) {
    return VistoriasMaoDeObraCompanion(
      id: id ?? this.id,
      vistoriaServicoId: vistoriaServicoId ?? this.vistoriaServicoId,
      funcionarioId: funcionarioId ?? this.funcionarioId,
      funcaoNoDia: funcaoNoDia ?? this.funcaoNoDia,
      observacao: observacao ?? this.observacao,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vistoriaServicoId.present) {
      map['vistoria_servico_id'] = Variable<String>(vistoriaServicoId.value);
    }
    if (funcionarioId.present) {
      map['funcionario_id'] = Variable<String>(funcionarioId.value);
    }
    if (funcaoNoDia.present) {
      map['funcao_no_dia'] = Variable<String>(funcaoNoDia.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VistoriasMaoDeObraCompanion(')
          ..write('id: $id, ')
          ..write('vistoriaServicoId: $vistoriaServicoId, ')
          ..write('funcionarioId: $funcionarioId, ')
          ..write('funcaoNoDia: $funcaoNoDia, ')
          ..write('observacao: $observacao, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicoesTable extends Medicoes with TableInfo<$MedicoesTable, Medicoe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _servicoIdMeta =
      const VerificationMeta('servicoId');
  @override
  late final GeneratedColumn<String> servicoId = GeneratedColumn<String>(
      'servico_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES servicos (id)'));
  static const VerificationMeta _vistoriaServicoIdMeta =
      const VerificationMeta('vistoriaServicoId');
  @override
  late final GeneratedColumn<String> vistoriaServicoId =
      GeneratedColumn<String>('vistoria_servico_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES vistorias_servico (id)'));
  static const VerificationMeta _percentualExecutadoMeta =
      const VerificationMeta('percentualExecutado');
  @override
  late final GeneratedColumn<double> percentualExecutado =
      GeneratedColumn<double>('percentual_executado', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _observacaoMeta =
      const VerificationMeta('observacao');
  @override
  late final GeneratedColumn<String> observacao = GeneratedColumn<String>(
      'observacao', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
      'data', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, servicoId, vistoriaServicoId, percentualExecutado, observacao, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicoes';
  @override
  VerificationContext validateIntegrity(Insertable<Medicoe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('servico_id')) {
      context.handle(_servicoIdMeta,
          servicoId.isAcceptableOrUnknown(data['servico_id']!, _servicoIdMeta));
    } else if (isInserting) {
      context.missing(_servicoIdMeta);
    }
    if (data.containsKey('vistoria_servico_id')) {
      context.handle(
          _vistoriaServicoIdMeta,
          vistoriaServicoId.isAcceptableOrUnknown(
              data['vistoria_servico_id']!, _vistoriaServicoIdMeta));
    }
    if (data.containsKey('percentual_executado')) {
      context.handle(
          _percentualExecutadoMeta,
          percentualExecutado.isAcceptableOrUnknown(
              data['percentual_executado']!, _percentualExecutadoMeta));
    } else if (isInserting) {
      context.missing(_percentualExecutadoMeta);
    }
    if (data.containsKey('observacao')) {
      context.handle(
          _observacaoMeta,
          observacao.isAcceptableOrUnknown(
              data['observacao']!, _observacaoMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medicoe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medicoe(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      servicoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}servico_id'])!,
      vistoriaServicoId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}vistoria_servico_id']),
      percentualExecutado: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}percentual_executado'])!,
      observacao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacao']),
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data'])!,
    );
  }

  @override
  $MedicoesTable createAlias(String alias) {
    return $MedicoesTable(attachedDatabase, alias);
  }
}

class Medicoe extends DataClass implements Insertable<Medicoe> {
  final String id;
  final String servicoId;
  final String? vistoriaServicoId;
  final double percentualExecutado;
  final String? observacao;
  final DateTime data;
  const Medicoe(
      {required this.id,
      required this.servicoId,
      this.vistoriaServicoId,
      required this.percentualExecutado,
      this.observacao,
      required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['servico_id'] = Variable<String>(servicoId);
    if (!nullToAbsent || vistoriaServicoId != null) {
      map['vistoria_servico_id'] = Variable<String>(vistoriaServicoId);
    }
    map['percentual_executado'] = Variable<double>(percentualExecutado);
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    map['data'] = Variable<DateTime>(data);
    return map;
  }

  MedicoesCompanion toCompanion(bool nullToAbsent) {
    return MedicoesCompanion(
      id: Value(id),
      servicoId: Value(servicoId),
      vistoriaServicoId: vistoriaServicoId == null && nullToAbsent
          ? const Value.absent()
          : Value(vistoriaServicoId),
      percentualExecutado: Value(percentualExecutado),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
      data: Value(data),
    );
  }

  factory Medicoe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medicoe(
      id: serializer.fromJson<String>(json['id']),
      servicoId: serializer.fromJson<String>(json['servicoId']),
      vistoriaServicoId:
          serializer.fromJson<String?>(json['vistoriaServicoId']),
      percentualExecutado:
          serializer.fromJson<double>(json['percentualExecutado']),
      observacao: serializer.fromJson<String?>(json['observacao']),
      data: serializer.fromJson<DateTime>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'servicoId': serializer.toJson<String>(servicoId),
      'vistoriaServicoId': serializer.toJson<String?>(vistoriaServicoId),
      'percentualExecutado': serializer.toJson<double>(percentualExecutado),
      'observacao': serializer.toJson<String?>(observacao),
      'data': serializer.toJson<DateTime>(data),
    };
  }

  Medicoe copyWith(
          {String? id,
          String? servicoId,
          Value<String?> vistoriaServicoId = const Value.absent(),
          double? percentualExecutado,
          Value<String?> observacao = const Value.absent(),
          DateTime? data}) =>
      Medicoe(
        id: id ?? this.id,
        servicoId: servicoId ?? this.servicoId,
        vistoriaServicoId: vistoriaServicoId.present
            ? vistoriaServicoId.value
            : this.vistoriaServicoId,
        percentualExecutado: percentualExecutado ?? this.percentualExecutado,
        observacao: observacao.present ? observacao.value : this.observacao,
        data: data ?? this.data,
      );
  Medicoe copyWithCompanion(MedicoesCompanion data) {
    return Medicoe(
      id: data.id.present ? data.id.value : this.id,
      servicoId: data.servicoId.present ? data.servicoId.value : this.servicoId,
      vistoriaServicoId: data.vistoriaServicoId.present
          ? data.vistoriaServicoId.value
          : this.vistoriaServicoId,
      percentualExecutado: data.percentualExecutado.present
          ? data.percentualExecutado.value
          : this.percentualExecutado,
      observacao:
          data.observacao.present ? data.observacao.value : this.observacao,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medicoe(')
          ..write('id: $id, ')
          ..write('servicoId: $servicoId, ')
          ..write('vistoriaServicoId: $vistoriaServicoId, ')
          ..write('percentualExecutado: $percentualExecutado, ')
          ..write('observacao: $observacao, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, servicoId, vistoriaServicoId, percentualExecutado, observacao, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medicoe &&
          other.id == this.id &&
          other.servicoId == this.servicoId &&
          other.vistoriaServicoId == this.vistoriaServicoId &&
          other.percentualExecutado == this.percentualExecutado &&
          other.observacao == this.observacao &&
          other.data == this.data);
}

class MedicoesCompanion extends UpdateCompanion<Medicoe> {
  final Value<String> id;
  final Value<String> servicoId;
  final Value<String?> vistoriaServicoId;
  final Value<double> percentualExecutado;
  final Value<String?> observacao;
  final Value<DateTime> data;
  final Value<int> rowid;
  const MedicoesCompanion({
    this.id = const Value.absent(),
    this.servicoId = const Value.absent(),
    this.vistoriaServicoId = const Value.absent(),
    this.percentualExecutado = const Value.absent(),
    this.observacao = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicoesCompanion.insert({
    required String id,
    required String servicoId,
    this.vistoriaServicoId = const Value.absent(),
    required double percentualExecutado,
    this.observacao = const Value.absent(),
    required DateTime data,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        servicoId = Value(servicoId),
        percentualExecutado = Value(percentualExecutado),
        data = Value(data);
  static Insertable<Medicoe> custom({
    Expression<String>? id,
    Expression<String>? servicoId,
    Expression<String>? vistoriaServicoId,
    Expression<double>? percentualExecutado,
    Expression<String>? observacao,
    Expression<DateTime>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (servicoId != null) 'servico_id': servicoId,
      if (vistoriaServicoId != null) 'vistoria_servico_id': vistoriaServicoId,
      if (percentualExecutado != null)
        'percentual_executado': percentualExecutado,
      if (observacao != null) 'observacao': observacao,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicoesCompanion copyWith(
      {Value<String>? id,
      Value<String>? servicoId,
      Value<String?>? vistoriaServicoId,
      Value<double>? percentualExecutado,
      Value<String?>? observacao,
      Value<DateTime>? data,
      Value<int>? rowid}) {
    return MedicoesCompanion(
      id: id ?? this.id,
      servicoId: servicoId ?? this.servicoId,
      vistoriaServicoId: vistoriaServicoId ?? this.vistoriaServicoId,
      percentualExecutado: percentualExecutado ?? this.percentualExecutado,
      observacao: observacao ?? this.observacao,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (servicoId.present) {
      map['servico_id'] = Variable<String>(servicoId.value);
    }
    if (vistoriaServicoId.present) {
      map['vistoria_servico_id'] = Variable<String>(vistoriaServicoId.value);
    }
    if (percentualExecutado.present) {
      map['percentual_executado'] = Variable<double>(percentualExecutado.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicoesCompanion(')
          ..write('id: $id, ')
          ..write('servicoId: $servicoId, ')
          ..write('vistoriaServicoId: $vistoriaServicoId, ')
          ..write('percentualExecutado: $percentualExecutado, ')
          ..write('observacao: $observacao, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FotosTable extends Fotos with TableInfo<$FotosTable, Foto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicaoIdMeta =
      const VerificationMeta('medicaoId');
  @override
  late final GeneratedColumn<String> medicaoId = GeneratedColumn<String>(
      'medicao_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES medicoes (id)'));
  static const VerificationMeta _caminhoArquivoMeta =
      const VerificationMeta('caminhoArquivo');
  @override
  late final GeneratedColumn<String> caminhoArquivo = GeneratedColumn<String>(
      'caminho_arquivo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, medicaoId, caminhoArquivo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fotos';
  @override
  VerificationContext validateIntegrity(Insertable<Foto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medicao_id')) {
      context.handle(_medicaoIdMeta,
          medicaoId.isAcceptableOrUnknown(data['medicao_id']!, _medicaoIdMeta));
    } else if (isInserting) {
      context.missing(_medicaoIdMeta);
    }
    if (data.containsKey('caminho_arquivo')) {
      context.handle(
          _caminhoArquivoMeta,
          caminhoArquivo.isAcceptableOrUnknown(
              data['caminho_arquivo']!, _caminhoArquivoMeta));
    } else if (isInserting) {
      context.missing(_caminhoArquivoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Foto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Foto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      medicaoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medicao_id'])!,
      caminhoArquivo: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}caminho_arquivo'])!,
    );
  }

  @override
  $FotosTable createAlias(String alias) {
    return $FotosTable(attachedDatabase, alias);
  }
}

class Foto extends DataClass implements Insertable<Foto> {
  final String id;
  final String medicaoId;
  final String caminhoArquivo;
  const Foto(
      {required this.id,
      required this.medicaoId,
      required this.caminhoArquivo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medicao_id'] = Variable<String>(medicaoId);
    map['caminho_arquivo'] = Variable<String>(caminhoArquivo);
    return map;
  }

  FotosCompanion toCompanion(bool nullToAbsent) {
    return FotosCompanion(
      id: Value(id),
      medicaoId: Value(medicaoId),
      caminhoArquivo: Value(caminhoArquivo),
    );
  }

  factory Foto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Foto(
      id: serializer.fromJson<String>(json['id']),
      medicaoId: serializer.fromJson<String>(json['medicaoId']),
      caminhoArquivo: serializer.fromJson<String>(json['caminhoArquivo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicaoId': serializer.toJson<String>(medicaoId),
      'caminhoArquivo': serializer.toJson<String>(caminhoArquivo),
    };
  }

  Foto copyWith({String? id, String? medicaoId, String? caminhoArquivo}) =>
      Foto(
        id: id ?? this.id,
        medicaoId: medicaoId ?? this.medicaoId,
        caminhoArquivo: caminhoArquivo ?? this.caminhoArquivo,
      );
  Foto copyWithCompanion(FotosCompanion data) {
    return Foto(
      id: data.id.present ? data.id.value : this.id,
      medicaoId: data.medicaoId.present ? data.medicaoId.value : this.medicaoId,
      caminhoArquivo: data.caminhoArquivo.present
          ? data.caminhoArquivo.value
          : this.caminhoArquivo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Foto(')
          ..write('id: $id, ')
          ..write('medicaoId: $medicaoId, ')
          ..write('caminhoArquivo: $caminhoArquivo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, medicaoId, caminhoArquivo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Foto &&
          other.id == this.id &&
          other.medicaoId == this.medicaoId &&
          other.caminhoArquivo == this.caminhoArquivo);
}

class FotosCompanion extends UpdateCompanion<Foto> {
  final Value<String> id;
  final Value<String> medicaoId;
  final Value<String> caminhoArquivo;
  final Value<int> rowid;
  const FotosCompanion({
    this.id = const Value.absent(),
    this.medicaoId = const Value.absent(),
    this.caminhoArquivo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FotosCompanion.insert({
    required String id,
    required String medicaoId,
    required String caminhoArquivo,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        medicaoId = Value(medicaoId),
        caminhoArquivo = Value(caminhoArquivo);
  static Insertable<Foto> custom({
    Expression<String>? id,
    Expression<String>? medicaoId,
    Expression<String>? caminhoArquivo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicaoId != null) 'medicao_id': medicaoId,
      if (caminhoArquivo != null) 'caminho_arquivo': caminhoArquivo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FotosCompanion copyWith(
      {Value<String>? id,
      Value<String>? medicaoId,
      Value<String>? caminhoArquivo,
      Value<int>? rowid}) {
    return FotosCompanion(
      id: id ?? this.id,
      medicaoId: medicaoId ?? this.medicaoId,
      caminhoArquivo: caminhoArquivo ?? this.caminhoArquivo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicaoId.present) {
      map['medicao_id'] = Variable<String>(medicaoId.value);
    }
    if (caminhoArquivo.present) {
      map['caminho_arquivo'] = Variable<String>(caminhoArquivo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FotosCompanion(')
          ..write('id: $id, ')
          ..write('medicaoId: $medicaoId, ')
          ..write('caminhoArquivo: $caminhoArquivo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HistoricosAlteracaoTable extends HistoricosAlteracao
    with TableInfo<$HistoricosAlteracaoTable, HistoricosAlteracaoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoricosAlteracaoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entidadeMeta =
      const VerificationMeta('entidade');
  @override
  late final GeneratedColumn<String> entidade = GeneratedColumn<String>(
      'entidade', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entidadeIdMeta =
      const VerificationMeta('entidadeId');
  @override
  late final GeneratedColumn<String> entidadeId = GeneratedColumn<String>(
      'entidade_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _campoMeta = const VerificationMeta('campo');
  @override
  late final GeneratedColumn<String> campo = GeneratedColumn<String>(
      'campo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valorAnteriorMeta =
      const VerificationMeta('valorAnterior');
  @override
  late final GeneratedColumn<String> valorAnterior = GeneratedColumn<String>(
      'valor_anterior', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _valorNovoMeta =
      const VerificationMeta('valorNovo');
  @override
  late final GeneratedColumn<String> valorNovo = GeneratedColumn<String>(
      'valor_novo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
      'data', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _usuarioMeta =
      const VerificationMeta('usuario');
  @override
  late final GeneratedColumn<String> usuario = GeneratedColumn<String>(
      'usuario', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entidade,
        entidadeId,
        campo,
        valorAnterior,
        valorNovo,
        data,
        usuario
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historicos_alteracao';
  @override
  VerificationContext validateIntegrity(
      Insertable<HistoricosAlteracaoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entidade')) {
      context.handle(_entidadeMeta,
          entidade.isAcceptableOrUnknown(data['entidade']!, _entidadeMeta));
    } else if (isInserting) {
      context.missing(_entidadeMeta);
    }
    if (data.containsKey('entidade_id')) {
      context.handle(
          _entidadeIdMeta,
          entidadeId.isAcceptableOrUnknown(
              data['entidade_id']!, _entidadeIdMeta));
    } else if (isInserting) {
      context.missing(_entidadeIdMeta);
    }
    if (data.containsKey('campo')) {
      context.handle(
          _campoMeta, campo.isAcceptableOrUnknown(data['campo']!, _campoMeta));
    } else if (isInserting) {
      context.missing(_campoMeta);
    }
    if (data.containsKey('valor_anterior')) {
      context.handle(
          _valorAnteriorMeta,
          valorAnterior.isAcceptableOrUnknown(
              data['valor_anterior']!, _valorAnteriorMeta));
    }
    if (data.containsKey('valor_novo')) {
      context.handle(_valorNovoMeta,
          valorNovo.isAcceptableOrUnknown(data['valor_novo']!, _valorNovoMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('usuario')) {
      context.handle(_usuarioMeta,
          usuario.isAcceptableOrUnknown(data['usuario']!, _usuarioMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoricosAlteracaoData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoricosAlteracaoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entidade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entidade'])!,
      entidadeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entidade_id'])!,
      campo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}campo'])!,
      valorAnterior: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valor_anterior']),
      valorNovo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valor_novo']),
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data'])!,
      usuario: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario']),
    );
  }

  @override
  $HistoricosAlteracaoTable createAlias(String alias) {
    return $HistoricosAlteracaoTable(attachedDatabase, alias);
  }
}

class HistoricosAlteracaoData extends DataClass
    implements Insertable<HistoricosAlteracaoData> {
  final String id;
  final String entidade;
  final String entidadeId;
  final String campo;
  final String? valorAnterior;
  final String? valorNovo;
  final DateTime data;
  final String? usuario;
  const HistoricosAlteracaoData(
      {required this.id,
      required this.entidade,
      required this.entidadeId,
      required this.campo,
      this.valorAnterior,
      this.valorNovo,
      required this.data,
      this.usuario});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entidade'] = Variable<String>(entidade);
    map['entidade_id'] = Variable<String>(entidadeId);
    map['campo'] = Variable<String>(campo);
    if (!nullToAbsent || valorAnterior != null) {
      map['valor_anterior'] = Variable<String>(valorAnterior);
    }
    if (!nullToAbsent || valorNovo != null) {
      map['valor_novo'] = Variable<String>(valorNovo);
    }
    map['data'] = Variable<DateTime>(data);
    if (!nullToAbsent || usuario != null) {
      map['usuario'] = Variable<String>(usuario);
    }
    return map;
  }

  HistoricosAlteracaoCompanion toCompanion(bool nullToAbsent) {
    return HistoricosAlteracaoCompanion(
      id: Value(id),
      entidade: Value(entidade),
      entidadeId: Value(entidadeId),
      campo: Value(campo),
      valorAnterior: valorAnterior == null && nullToAbsent
          ? const Value.absent()
          : Value(valorAnterior),
      valorNovo: valorNovo == null && nullToAbsent
          ? const Value.absent()
          : Value(valorNovo),
      data: Value(data),
      usuario: usuario == null && nullToAbsent
          ? const Value.absent()
          : Value(usuario),
    );
  }

  factory HistoricosAlteracaoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoricosAlteracaoData(
      id: serializer.fromJson<String>(json['id']),
      entidade: serializer.fromJson<String>(json['entidade']),
      entidadeId: serializer.fromJson<String>(json['entidadeId']),
      campo: serializer.fromJson<String>(json['campo']),
      valorAnterior: serializer.fromJson<String?>(json['valorAnterior']),
      valorNovo: serializer.fromJson<String?>(json['valorNovo']),
      data: serializer.fromJson<DateTime>(json['data']),
      usuario: serializer.fromJson<String?>(json['usuario']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entidade': serializer.toJson<String>(entidade),
      'entidadeId': serializer.toJson<String>(entidadeId),
      'campo': serializer.toJson<String>(campo),
      'valorAnterior': serializer.toJson<String?>(valorAnterior),
      'valorNovo': serializer.toJson<String?>(valorNovo),
      'data': serializer.toJson<DateTime>(data),
      'usuario': serializer.toJson<String?>(usuario),
    };
  }

  HistoricosAlteracaoData copyWith(
          {String? id,
          String? entidade,
          String? entidadeId,
          String? campo,
          Value<String?> valorAnterior = const Value.absent(),
          Value<String?> valorNovo = const Value.absent(),
          DateTime? data,
          Value<String?> usuario = const Value.absent()}) =>
      HistoricosAlteracaoData(
        id: id ?? this.id,
        entidade: entidade ?? this.entidade,
        entidadeId: entidadeId ?? this.entidadeId,
        campo: campo ?? this.campo,
        valorAnterior:
            valorAnterior.present ? valorAnterior.value : this.valorAnterior,
        valorNovo: valorNovo.present ? valorNovo.value : this.valorNovo,
        data: data ?? this.data,
        usuario: usuario.present ? usuario.value : this.usuario,
      );
  HistoricosAlteracaoData copyWithCompanion(HistoricosAlteracaoCompanion data) {
    return HistoricosAlteracaoData(
      id: data.id.present ? data.id.value : this.id,
      entidade: data.entidade.present ? data.entidade.value : this.entidade,
      entidadeId:
          data.entidadeId.present ? data.entidadeId.value : this.entidadeId,
      campo: data.campo.present ? data.campo.value : this.campo,
      valorAnterior: data.valorAnterior.present
          ? data.valorAnterior.value
          : this.valorAnterior,
      valorNovo: data.valorNovo.present ? data.valorNovo.value : this.valorNovo,
      data: data.data.present ? data.data.value : this.data,
      usuario: data.usuario.present ? data.usuario.value : this.usuario,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoricosAlteracaoData(')
          ..write('id: $id, ')
          ..write('entidade: $entidade, ')
          ..write('entidadeId: $entidadeId, ')
          ..write('campo: $campo, ')
          ..write('valorAnterior: $valorAnterior, ')
          ..write('valorNovo: $valorNovo, ')
          ..write('data: $data, ')
          ..write('usuario: $usuario')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, entidade, entidadeId, campo, valorAnterior, valorNovo, data, usuario);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoricosAlteracaoData &&
          other.id == this.id &&
          other.entidade == this.entidade &&
          other.entidadeId == this.entidadeId &&
          other.campo == this.campo &&
          other.valorAnterior == this.valorAnterior &&
          other.valorNovo == this.valorNovo &&
          other.data == this.data &&
          other.usuario == this.usuario);
}

class HistoricosAlteracaoCompanion
    extends UpdateCompanion<HistoricosAlteracaoData> {
  final Value<String> id;
  final Value<String> entidade;
  final Value<String> entidadeId;
  final Value<String> campo;
  final Value<String?> valorAnterior;
  final Value<String?> valorNovo;
  final Value<DateTime> data;
  final Value<String?> usuario;
  final Value<int> rowid;
  const HistoricosAlteracaoCompanion({
    this.id = const Value.absent(),
    this.entidade = const Value.absent(),
    this.entidadeId = const Value.absent(),
    this.campo = const Value.absent(),
    this.valorAnterior = const Value.absent(),
    this.valorNovo = const Value.absent(),
    this.data = const Value.absent(),
    this.usuario = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HistoricosAlteracaoCompanion.insert({
    required String id,
    required String entidade,
    required String entidadeId,
    required String campo,
    this.valorAnterior = const Value.absent(),
    this.valorNovo = const Value.absent(),
    required DateTime data,
    this.usuario = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entidade = Value(entidade),
        entidadeId = Value(entidadeId),
        campo = Value(campo),
        data = Value(data);
  static Insertable<HistoricosAlteracaoData> custom({
    Expression<String>? id,
    Expression<String>? entidade,
    Expression<String>? entidadeId,
    Expression<String>? campo,
    Expression<String>? valorAnterior,
    Expression<String>? valorNovo,
    Expression<DateTime>? data,
    Expression<String>? usuario,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entidade != null) 'entidade': entidade,
      if (entidadeId != null) 'entidade_id': entidadeId,
      if (campo != null) 'campo': campo,
      if (valorAnterior != null) 'valor_anterior': valorAnterior,
      if (valorNovo != null) 'valor_novo': valorNovo,
      if (data != null) 'data': data,
      if (usuario != null) 'usuario': usuario,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoricosAlteracaoCompanion copyWith(
      {Value<String>? id,
      Value<String>? entidade,
      Value<String>? entidadeId,
      Value<String>? campo,
      Value<String?>? valorAnterior,
      Value<String?>? valorNovo,
      Value<DateTime>? data,
      Value<String?>? usuario,
      Value<int>? rowid}) {
    return HistoricosAlteracaoCompanion(
      id: id ?? this.id,
      entidade: entidade ?? this.entidade,
      entidadeId: entidadeId ?? this.entidadeId,
      campo: campo ?? this.campo,
      valorAnterior: valorAnterior ?? this.valorAnterior,
      valorNovo: valorNovo ?? this.valorNovo,
      data: data ?? this.data,
      usuario: usuario ?? this.usuario,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entidade.present) {
      map['entidade'] = Variable<String>(entidade.value);
    }
    if (entidadeId.present) {
      map['entidade_id'] = Variable<String>(entidadeId.value);
    }
    if (campo.present) {
      map['campo'] = Variable<String>(campo.value);
    }
    if (valorAnterior.present) {
      map['valor_anterior'] = Variable<String>(valorAnterior.value);
    }
    if (valorNovo.present) {
      map['valor_novo'] = Variable<String>(valorNovo.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (usuario.present) {
      map['usuario'] = Variable<String>(usuario.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoricosAlteracaoCompanion(')
          ..write('id: $id, ')
          ..write('entidade: $entidade, ')
          ..write('entidadeId: $entidadeId, ')
          ..write('campo: $campo, ')
          ..write('valorAnterior: $valorAnterior, ')
          ..write('valorNovo: $valorNovo, ')
          ..write('data: $data, ')
          ..write('usuario: $usuario, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EmpresasTable empresas = $EmpresasTable(this);
  late final $ContratantesTable contratantes = $ContratantesTable(this);
  late final $FuncionariosTable funcionarios = $FuncionariosTable(this);
  late final $EnderecosTable enderecos = $EnderecosTable(this);
  late final $ContatosTable contatos = $ContatosTable(this);
  late final $ObrasTable obras = $ObrasTable(this);
  late final $EtapasTable etapas = $EtapasTable(this);
  late final $ServicosTable servicos = $ServicosTable(this);
  late final $VistoriasServicoTable vistoriasServico =
      $VistoriasServicoTable(this);
  late final $VistoriasPeriodoTable vistoriasPeriodo =
      $VistoriasPeriodoTable(this);
  late final $VistoriasMaoDeObraTable vistoriasMaoDeObra =
      $VistoriasMaoDeObraTable(this);
  late final $MedicoesTable medicoes = $MedicoesTable(this);
  late final $FotosTable fotos = $FotosTable(this);
  late final $HistoricosAlteracaoTable historicosAlteracao =
      $HistoricosAlteracaoTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        empresas,
        contratantes,
        funcionarios,
        enderecos,
        contatos,
        obras,
        etapas,
        servicos,
        vistoriasServico,
        vistoriasPeriodo,
        vistoriasMaoDeObra,
        medicoes,
        fotos,
        historicosAlteracao
      ];
}

typedef $$EmpresasTableCreateCompanionBuilder = EmpresasCompanion Function({
  required String id,
  required String nome,
  Value<String?> cnpj,
  Value<String?> ie,
  Value<int> rowid,
});
typedef $$EmpresasTableUpdateCompanionBuilder = EmpresasCompanion Function({
  Value<String> id,
  Value<String> nome,
  Value<String?> cnpj,
  Value<String?> ie,
  Value<int> rowid,
});

class $$EmpresasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmpresasTable,
    Empresa,
    $$EmpresasTableFilterComposer,
    $$EmpresasTableOrderingComposer,
    $$EmpresasTableCreateCompanionBuilder,
    $$EmpresasTableUpdateCompanionBuilder> {
  $$EmpresasTableTableManager(_$AppDatabase db, $EmpresasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$EmpresasTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$EmpresasTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String?> cnpj = const Value.absent(),
            Value<String?> ie = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmpresasCompanion(
            id: id,
            nome: nome,
            cnpj: cnpj,
            ie: ie,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nome,
            Value<String?> cnpj = const Value.absent(),
            Value<String?> ie = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmpresasCompanion.insert(
            id: id,
            nome: nome,
            cnpj: cnpj,
            ie: ie,
            rowid: rowid,
          ),
        ));
}

class $$EmpresasTableFilterComposer
    extends FilterComposer<_$AppDatabase, $EmpresasTable> {
  $$EmpresasTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nome => $state.composableBuilder(
      column: $state.table.nome,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get cnpj => $state.composableBuilder(
      column: $state.table.cnpj,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get ie => $state.composableBuilder(
      column: $state.table.ie,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter funcionariosRefs(
      ComposableFilter Function($$FuncionariosTableFilterComposer f) f) {
    final $$FuncionariosTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.funcionarios,
        getReferencedColumn: (t) => t.empresaId,
        builder: (joinBuilder, parentComposers) =>
            $$FuncionariosTableFilterComposer(ComposerState($state.db,
                $state.db.funcionarios, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter obrasRefs(
      ComposableFilter Function($$ObrasTableFilterComposer f) f) {
    final $$ObrasTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.obras,
        getReferencedColumn: (t) => t.empresaId,
        builder: (joinBuilder, parentComposers) => $$ObrasTableFilterComposer(
            ComposerState(
                $state.db, $state.db.obras, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$EmpresasTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $EmpresasTable> {
  $$EmpresasTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nome => $state.composableBuilder(
      column: $state.table.nome,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cnpj => $state.composableBuilder(
      column: $state.table.cnpj,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get ie => $state.composableBuilder(
      column: $state.table.ie,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ContratantesTableCreateCompanionBuilder = ContratantesCompanion
    Function({
  required String id,
  required String nome,
  Value<String?> cnpj,
  Value<String?> ie,
  Value<int> rowid,
});
typedef $$ContratantesTableUpdateCompanionBuilder = ContratantesCompanion
    Function({
  Value<String> id,
  Value<String> nome,
  Value<String?> cnpj,
  Value<String?> ie,
  Value<int> rowid,
});

class $$ContratantesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContratantesTable,
    Contratante,
    $$ContratantesTableFilterComposer,
    $$ContratantesTableOrderingComposer,
    $$ContratantesTableCreateCompanionBuilder,
    $$ContratantesTableUpdateCompanionBuilder> {
  $$ContratantesTableTableManager(_$AppDatabase db, $ContratantesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ContratantesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ContratantesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String?> cnpj = const Value.absent(),
            Value<String?> ie = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContratantesCompanion(
            id: id,
            nome: nome,
            cnpj: cnpj,
            ie: ie,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nome,
            Value<String?> cnpj = const Value.absent(),
            Value<String?> ie = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContratantesCompanion.insert(
            id: id,
            nome: nome,
            cnpj: cnpj,
            ie: ie,
            rowid: rowid,
          ),
        ));
}

class $$ContratantesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ContratantesTable> {
  $$ContratantesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nome => $state.composableBuilder(
      column: $state.table.nome,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get cnpj => $state.composableBuilder(
      column: $state.table.cnpj,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get ie => $state.composableBuilder(
      column: $state.table.ie,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter funcionariosRefs(
      ComposableFilter Function($$FuncionariosTableFilterComposer f) f) {
    final $$FuncionariosTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.funcionarios,
        getReferencedColumn: (t) => t.contratanteId,
        builder: (joinBuilder, parentComposers) =>
            $$FuncionariosTableFilterComposer(ComposerState($state.db,
                $state.db.funcionarios, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter vistoriasServicoRefs(
      ComposableFilter Function($$VistoriasServicoTableFilterComposer f) f) {
    final $$VistoriasServicoTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.vistoriasServico,
            getReferencedColumn: (t) => t.contratanteId,
            builder: (joinBuilder, parentComposers) =>
                $$VistoriasServicoTableFilterComposer(ComposerState($state.db,
                    $state.db.vistoriasServico, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ContratantesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ContratantesTable> {
  $$ContratantesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nome => $state.composableBuilder(
      column: $state.table.nome,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cnpj => $state.composableBuilder(
      column: $state.table.cnpj,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get ie => $state.composableBuilder(
      column: $state.table.ie,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$FuncionariosTableCreateCompanionBuilder = FuncionariosCompanion
    Function({
  required String id,
  Value<String?> empresaId,
  Value<String?> contratanteId,
  required String nome,
  Value<String?> cpf,
  required String cargo,
  Value<int> rowid,
});
typedef $$FuncionariosTableUpdateCompanionBuilder = FuncionariosCompanion
    Function({
  Value<String> id,
  Value<String?> empresaId,
  Value<String?> contratanteId,
  Value<String> nome,
  Value<String?> cpf,
  Value<String> cargo,
  Value<int> rowid,
});

class $$FuncionariosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FuncionariosTable,
    Funcionario,
    $$FuncionariosTableFilterComposer,
    $$FuncionariosTableOrderingComposer,
    $$FuncionariosTableCreateCompanionBuilder,
    $$FuncionariosTableUpdateCompanionBuilder> {
  $$FuncionariosTableTableManager(_$AppDatabase db, $FuncionariosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$FuncionariosTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$FuncionariosTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> empresaId = const Value.absent(),
            Value<String?> contratanteId = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String?> cpf = const Value.absent(),
            Value<String> cargo = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FuncionariosCompanion(
            id: id,
            empresaId: empresaId,
            contratanteId: contratanteId,
            nome: nome,
            cpf: cpf,
            cargo: cargo,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> empresaId = const Value.absent(),
            Value<String?> contratanteId = const Value.absent(),
            required String nome,
            Value<String?> cpf = const Value.absent(),
            required String cargo,
            Value<int> rowid = const Value.absent(),
          }) =>
              FuncionariosCompanion.insert(
            id: id,
            empresaId: empresaId,
            contratanteId: contratanteId,
            nome: nome,
            cpf: cpf,
            cargo: cargo,
            rowid: rowid,
          ),
        ));
}

class $$FuncionariosTableFilterComposer
    extends FilterComposer<_$AppDatabase, $FuncionariosTable> {
  $$FuncionariosTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nome => $state.composableBuilder(
      column: $state.table.nome,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get cpf => $state.composableBuilder(
      column: $state.table.cpf,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get cargo => $state.composableBuilder(
      column: $state.table.cargo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$EmpresasTableFilterComposer get empresaId {
    final $$EmpresasTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.empresaId,
        referencedTable: $state.db.empresas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$EmpresasTableFilterComposer(ComposerState(
                $state.db, $state.db.empresas, joinBuilder, parentComposers)));
    return composer;
  }

  $$ContratantesTableFilterComposer get contratanteId {
    final $$ContratantesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contratanteId,
        referencedTable: $state.db.contratantes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ContratantesTableFilterComposer(ComposerState($state.db,
                $state.db.contratantes, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter vistoriasServicoRefs(
      ComposableFilter Function($$VistoriasServicoTableFilterComposer f) f) {
    final $$VistoriasServicoTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.vistoriasServico,
            getReferencedColumn: (t) => t.responsavelId,
            builder: (joinBuilder, parentComposers) =>
                $$VistoriasServicoTableFilterComposer(ComposerState($state.db,
                    $state.db.vistoriasServico, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter vistoriasMaoDeObraRefs(
      ComposableFilter Function($$VistoriasMaoDeObraTableFilterComposer f) f) {
    final $$VistoriasMaoDeObraTableFilterComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.vistoriasMaoDeObra,
            getReferencedColumn: (t) => t.funcionarioId,
            builder: (joinBuilder, parentComposers) =>
                $$VistoriasMaoDeObraTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.vistoriasMaoDeObra,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }
}

class $$FuncionariosTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $FuncionariosTable> {
  $$FuncionariosTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nome => $state.composableBuilder(
      column: $state.table.nome,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cpf => $state.composableBuilder(
      column: $state.table.cpf,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cargo => $state.composableBuilder(
      column: $state.table.cargo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$EmpresasTableOrderingComposer get empresaId {
    final $$EmpresasTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.empresaId,
        referencedTable: $state.db.empresas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$EmpresasTableOrderingComposer(ComposerState(
                $state.db, $state.db.empresas, joinBuilder, parentComposers)));
    return composer;
  }

  $$ContratantesTableOrderingComposer get contratanteId {
    final $$ContratantesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contratanteId,
        referencedTable: $state.db.contratantes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ContratantesTableOrderingComposer(ComposerState($state.db,
                $state.db.contratantes, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$EnderecosTableCreateCompanionBuilder = EnderecosCompanion Function({
  required String id,
  required String entidade,
  required String entidadeId,
  required String tipo,
  Value<String?> cep,
  Value<String?> logradouro,
  Value<String?> numero,
  Value<String?> complemento,
  Value<String?> bairro,
  required String cidade,
  required String estado,
  Value<String> pais,
  Value<int> rowid,
});
typedef $$EnderecosTableUpdateCompanionBuilder = EnderecosCompanion Function({
  Value<String> id,
  Value<String> entidade,
  Value<String> entidadeId,
  Value<String> tipo,
  Value<String?> cep,
  Value<String?> logradouro,
  Value<String?> numero,
  Value<String?> complemento,
  Value<String?> bairro,
  Value<String> cidade,
  Value<String> estado,
  Value<String> pais,
  Value<int> rowid,
});

class $$EnderecosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EnderecosTable,
    Endereco,
    $$EnderecosTableFilterComposer,
    $$EnderecosTableOrderingComposer,
    $$EnderecosTableCreateCompanionBuilder,
    $$EnderecosTableUpdateCompanionBuilder> {
  $$EnderecosTableTableManager(_$AppDatabase db, $EnderecosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$EnderecosTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$EnderecosTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entidade = const Value.absent(),
            Value<String> entidadeId = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<String?> cep = const Value.absent(),
            Value<String?> logradouro = const Value.absent(),
            Value<String?> numero = const Value.absent(),
            Value<String?> complemento = const Value.absent(),
            Value<String?> bairro = const Value.absent(),
            Value<String> cidade = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<String> pais = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EnderecosCompanion(
            id: id,
            entidade: entidade,
            entidadeId: entidadeId,
            tipo: tipo,
            cep: cep,
            logradouro: logradouro,
            numero: numero,
            complemento: complemento,
            bairro: bairro,
            cidade: cidade,
            estado: estado,
            pais: pais,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entidade,
            required String entidadeId,
            required String tipo,
            Value<String?> cep = const Value.absent(),
            Value<String?> logradouro = const Value.absent(),
            Value<String?> numero = const Value.absent(),
            Value<String?> complemento = const Value.absent(),
            Value<String?> bairro = const Value.absent(),
            required String cidade,
            required String estado,
            Value<String> pais = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EnderecosCompanion.insert(
            id: id,
            entidade: entidade,
            entidadeId: entidadeId,
            tipo: tipo,
            cep: cep,
            logradouro: logradouro,
            numero: numero,
            complemento: complemento,
            bairro: bairro,
            cidade: cidade,
            estado: estado,
            pais: pais,
            rowid: rowid,
          ),
        ));
}

class $$EnderecosTableFilterComposer
    extends FilterComposer<_$AppDatabase, $EnderecosTable> {
  $$EnderecosTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get entidade => $state.composableBuilder(
      column: $state.table.entidade,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get entidadeId => $state.composableBuilder(
      column: $state.table.entidadeId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get tipo => $state.composableBuilder(
      column: $state.table.tipo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get cep => $state.composableBuilder(
      column: $state.table.cep,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get logradouro => $state.composableBuilder(
      column: $state.table.logradouro,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get numero => $state.composableBuilder(
      column: $state.table.numero,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get complemento => $state.composableBuilder(
      column: $state.table.complemento,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get bairro => $state.composableBuilder(
      column: $state.table.bairro,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get cidade => $state.composableBuilder(
      column: $state.table.cidade,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get estado => $state.composableBuilder(
      column: $state.table.estado,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get pais => $state.composableBuilder(
      column: $state.table.pais,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter obrasRefs(
      ComposableFilter Function($$ObrasTableFilterComposer f) f) {
    final $$ObrasTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.obras,
        getReferencedColumn: (t) => t.enderecoId,
        builder: (joinBuilder, parentComposers) => $$ObrasTableFilterComposer(
            ComposerState(
                $state.db, $state.db.obras, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$EnderecosTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $EnderecosTable> {
  $$EnderecosTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get entidade => $state.composableBuilder(
      column: $state.table.entidade,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get entidadeId => $state.composableBuilder(
      column: $state.table.entidadeId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get tipo => $state.composableBuilder(
      column: $state.table.tipo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cep => $state.composableBuilder(
      column: $state.table.cep,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get logradouro => $state.composableBuilder(
      column: $state.table.logradouro,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get numero => $state.composableBuilder(
      column: $state.table.numero,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get complemento => $state.composableBuilder(
      column: $state.table.complemento,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get bairro => $state.composableBuilder(
      column: $state.table.bairro,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cidade => $state.composableBuilder(
      column: $state.table.cidade,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get estado => $state.composableBuilder(
      column: $state.table.estado,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get pais => $state.composableBuilder(
      column: $state.table.pais,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ContatosTableCreateCompanionBuilder = ContatosCompanion Function({
  required String id,
  required String entidade,
  required String entidadeId,
  required String tipo,
  required String valor,
  Value<String?> observacao,
  Value<int> rowid,
});
typedef $$ContatosTableUpdateCompanionBuilder = ContatosCompanion Function({
  Value<String> id,
  Value<String> entidade,
  Value<String> entidadeId,
  Value<String> tipo,
  Value<String> valor,
  Value<String?> observacao,
  Value<int> rowid,
});

class $$ContatosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContatosTable,
    Contato,
    $$ContatosTableFilterComposer,
    $$ContatosTableOrderingComposer,
    $$ContatosTableCreateCompanionBuilder,
    $$ContatosTableUpdateCompanionBuilder> {
  $$ContatosTableTableManager(_$AppDatabase db, $ContatosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ContatosTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ContatosTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entidade = const Value.absent(),
            Value<String> entidadeId = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<String> valor = const Value.absent(),
            Value<String?> observacao = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContatosCompanion(
            id: id,
            entidade: entidade,
            entidadeId: entidadeId,
            tipo: tipo,
            valor: valor,
            observacao: observacao,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entidade,
            required String entidadeId,
            required String tipo,
            required String valor,
            Value<String?> observacao = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContatosCompanion.insert(
            id: id,
            entidade: entidade,
            entidadeId: entidadeId,
            tipo: tipo,
            valor: valor,
            observacao: observacao,
            rowid: rowid,
          ),
        ));
}

class $$ContatosTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ContatosTable> {
  $$ContatosTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get entidade => $state.composableBuilder(
      column: $state.table.entidade,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get entidadeId => $state.composableBuilder(
      column: $state.table.entidadeId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get tipo => $state.composableBuilder(
      column: $state.table.tipo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get valor => $state.composableBuilder(
      column: $state.table.valor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get observacao => $state.composableBuilder(
      column: $state.table.observacao,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ContatosTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ContatosTable> {
  $$ContatosTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get entidade => $state.composableBuilder(
      column: $state.table.entidade,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get entidadeId => $state.composableBuilder(
      column: $state.table.entidadeId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get tipo => $state.composableBuilder(
      column: $state.table.tipo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get valor => $state.composableBuilder(
      column: $state.table.valor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get observacao => $state.composableBuilder(
      column: $state.table.observacao,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ObrasTableCreateCompanionBuilder = ObrasCompanion Function({
  required String id,
  required String empresaId,
  required String enderecoId,
  required String nome,
  required DateTime dataInicio,
  required DateTime dataFim,
  required String status,
  Value<double> progressoFisico,
  Value<int> progressoPrazoDias,
  Value<int> rowid,
});
typedef $$ObrasTableUpdateCompanionBuilder = ObrasCompanion Function({
  Value<String> id,
  Value<String> empresaId,
  Value<String> enderecoId,
  Value<String> nome,
  Value<DateTime> dataInicio,
  Value<DateTime> dataFim,
  Value<String> status,
  Value<double> progressoFisico,
  Value<int> progressoPrazoDias,
  Value<int> rowid,
});

class $$ObrasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ObrasTable,
    Obra,
    $$ObrasTableFilterComposer,
    $$ObrasTableOrderingComposer,
    $$ObrasTableCreateCompanionBuilder,
    $$ObrasTableUpdateCompanionBuilder> {
  $$ObrasTableTableManager(_$AppDatabase db, $ObrasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ObrasTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ObrasTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> empresaId = const Value.absent(),
            Value<String> enderecoId = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<DateTime> dataInicio = const Value.absent(),
            Value<DateTime> dataFim = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> progressoFisico = const Value.absent(),
            Value<int> progressoPrazoDias = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ObrasCompanion(
            id: id,
            empresaId: empresaId,
            enderecoId: enderecoId,
            nome: nome,
            dataInicio: dataInicio,
            dataFim: dataFim,
            status: status,
            progressoFisico: progressoFisico,
            progressoPrazoDias: progressoPrazoDias,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String empresaId,
            required String enderecoId,
            required String nome,
            required DateTime dataInicio,
            required DateTime dataFim,
            required String status,
            Value<double> progressoFisico = const Value.absent(),
            Value<int> progressoPrazoDias = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ObrasCompanion.insert(
            id: id,
            empresaId: empresaId,
            enderecoId: enderecoId,
            nome: nome,
            dataInicio: dataInicio,
            dataFim: dataFim,
            status: status,
            progressoFisico: progressoFisico,
            progressoPrazoDias: progressoPrazoDias,
            rowid: rowid,
          ),
        ));
}

class $$ObrasTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ObrasTable> {
  $$ObrasTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nome => $state.composableBuilder(
      column: $state.table.nome,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dataInicio => $state.composableBuilder(
      column: $state.table.dataInicio,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dataFim => $state.composableBuilder(
      column: $state.table.dataFim,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get progressoFisico => $state.composableBuilder(
      column: $state.table.progressoFisico,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get progressoPrazoDias => $state.composableBuilder(
      column: $state.table.progressoPrazoDias,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$EmpresasTableFilterComposer get empresaId {
    final $$EmpresasTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.empresaId,
        referencedTable: $state.db.empresas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$EmpresasTableFilterComposer(ComposerState(
                $state.db, $state.db.empresas, joinBuilder, parentComposers)));
    return composer;
  }

  $$EnderecosTableFilterComposer get enderecoId {
    final $$EnderecosTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.enderecoId,
        referencedTable: $state.db.enderecos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$EnderecosTableFilterComposer(ComposerState(
                $state.db, $state.db.enderecos, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter etapasRefs(
      ComposableFilter Function($$EtapasTableFilterComposer f) f) {
    final $$EtapasTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.etapas,
        getReferencedColumn: (t) => t.obraId,
        builder: (joinBuilder, parentComposers) => $$EtapasTableFilterComposer(
            ComposerState(
                $state.db, $state.db.etapas, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter vistoriasServicoRefs(
      ComposableFilter Function($$VistoriasServicoTableFilterComposer f) f) {
    final $$VistoriasServicoTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.vistoriasServico,
            getReferencedColumn: (t) => t.obraId,
            builder: (joinBuilder, parentComposers) =>
                $$VistoriasServicoTableFilterComposer(ComposerState($state.db,
                    $state.db.vistoriasServico, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ObrasTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ObrasTable> {
  $$ObrasTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nome => $state.composableBuilder(
      column: $state.table.nome,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dataInicio => $state.composableBuilder(
      column: $state.table.dataInicio,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dataFim => $state.composableBuilder(
      column: $state.table.dataFim,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get progressoFisico => $state.composableBuilder(
      column: $state.table.progressoFisico,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get progressoPrazoDias => $state.composableBuilder(
      column: $state.table.progressoPrazoDias,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$EmpresasTableOrderingComposer get empresaId {
    final $$EmpresasTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.empresaId,
        referencedTable: $state.db.empresas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$EmpresasTableOrderingComposer(ComposerState(
                $state.db, $state.db.empresas, joinBuilder, parentComposers)));
    return composer;
  }

  $$EnderecosTableOrderingComposer get enderecoId {
    final $$EnderecosTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.enderecoId,
        referencedTable: $state.db.enderecos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$EnderecosTableOrderingComposer(ComposerState(
                $state.db, $state.db.enderecos, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$EtapasTableCreateCompanionBuilder = EtapasCompanion Function({
  required String id,
  required String obraId,
  required String nome,
  required DateTime dataInicio,
  required DateTime dataFim,
  required String status,
  Value<double> progressoFisico,
  Value<int> progressoPrazoDias,
  Value<int> rowid,
});
typedef $$EtapasTableUpdateCompanionBuilder = EtapasCompanion Function({
  Value<String> id,
  Value<String> obraId,
  Value<String> nome,
  Value<DateTime> dataInicio,
  Value<DateTime> dataFim,
  Value<String> status,
  Value<double> progressoFisico,
  Value<int> progressoPrazoDias,
  Value<int> rowid,
});

class $$EtapasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EtapasTable,
    Etapa,
    $$EtapasTableFilterComposer,
    $$EtapasTableOrderingComposer,
    $$EtapasTableCreateCompanionBuilder,
    $$EtapasTableUpdateCompanionBuilder> {
  $$EtapasTableTableManager(_$AppDatabase db, $EtapasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$EtapasTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$EtapasTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> obraId = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<DateTime> dataInicio = const Value.absent(),
            Value<DateTime> dataFim = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> progressoFisico = const Value.absent(),
            Value<int> progressoPrazoDias = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EtapasCompanion(
            id: id,
            obraId: obraId,
            nome: nome,
            dataInicio: dataInicio,
            dataFim: dataFim,
            status: status,
            progressoFisico: progressoFisico,
            progressoPrazoDias: progressoPrazoDias,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String obraId,
            required String nome,
            required DateTime dataInicio,
            required DateTime dataFim,
            required String status,
            Value<double> progressoFisico = const Value.absent(),
            Value<int> progressoPrazoDias = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EtapasCompanion.insert(
            id: id,
            obraId: obraId,
            nome: nome,
            dataInicio: dataInicio,
            dataFim: dataFim,
            status: status,
            progressoFisico: progressoFisico,
            progressoPrazoDias: progressoPrazoDias,
            rowid: rowid,
          ),
        ));
}

class $$EtapasTableFilterComposer
    extends FilterComposer<_$AppDatabase, $EtapasTable> {
  $$EtapasTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nome => $state.composableBuilder(
      column: $state.table.nome,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dataInicio => $state.composableBuilder(
      column: $state.table.dataInicio,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dataFim => $state.composableBuilder(
      column: $state.table.dataFim,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get progressoFisico => $state.composableBuilder(
      column: $state.table.progressoFisico,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get progressoPrazoDias => $state.composableBuilder(
      column: $state.table.progressoPrazoDias,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ObrasTableFilterComposer get obraId {
    final $$ObrasTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.obraId,
        referencedTable: $state.db.obras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$ObrasTableFilterComposer(
            ComposerState(
                $state.db, $state.db.obras, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter servicosRefs(
      ComposableFilter Function($$ServicosTableFilterComposer f) f) {
    final $$ServicosTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.servicos,
        getReferencedColumn: (t) => t.etapaId,
        builder: (joinBuilder, parentComposers) =>
            $$ServicosTableFilterComposer(ComposerState(
                $state.db, $state.db.servicos, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$EtapasTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $EtapasTable> {
  $$EtapasTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nome => $state.composableBuilder(
      column: $state.table.nome,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dataInicio => $state.composableBuilder(
      column: $state.table.dataInicio,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dataFim => $state.composableBuilder(
      column: $state.table.dataFim,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get progressoFisico => $state.composableBuilder(
      column: $state.table.progressoFisico,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get progressoPrazoDias => $state.composableBuilder(
      column: $state.table.progressoPrazoDias,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ObrasTableOrderingComposer get obraId {
    final $$ObrasTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.obraId,
        referencedTable: $state.db.obras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$ObrasTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.obras, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$ServicosTableCreateCompanionBuilder = ServicosCompanion Function({
  required String id,
  required String etapaId,
  required String nome,
  required double precoTotal,
  required String unidade,
  required double quantidade,
  required DateTime dataInicio,
  required DateTime dataFim,
  required String status,
  Value<double> progressoFisico,
  Value<int> progressoPrazoDias,
  Value<int> rowid,
});
typedef $$ServicosTableUpdateCompanionBuilder = ServicosCompanion Function({
  Value<String> id,
  Value<String> etapaId,
  Value<String> nome,
  Value<double> precoTotal,
  Value<String> unidade,
  Value<double> quantidade,
  Value<DateTime> dataInicio,
  Value<DateTime> dataFim,
  Value<String> status,
  Value<double> progressoFisico,
  Value<int> progressoPrazoDias,
  Value<int> rowid,
});

class $$ServicosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServicosTable,
    Servico,
    $$ServicosTableFilterComposer,
    $$ServicosTableOrderingComposer,
    $$ServicosTableCreateCompanionBuilder,
    $$ServicosTableUpdateCompanionBuilder> {
  $$ServicosTableTableManager(_$AppDatabase db, $ServicosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ServicosTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ServicosTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> etapaId = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<double> precoTotal = const Value.absent(),
            Value<String> unidade = const Value.absent(),
            Value<double> quantidade = const Value.absent(),
            Value<DateTime> dataInicio = const Value.absent(),
            Value<DateTime> dataFim = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> progressoFisico = const Value.absent(),
            Value<int> progressoPrazoDias = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServicosCompanion(
            id: id,
            etapaId: etapaId,
            nome: nome,
            precoTotal: precoTotal,
            unidade: unidade,
            quantidade: quantidade,
            dataInicio: dataInicio,
            dataFim: dataFim,
            status: status,
            progressoFisico: progressoFisico,
            progressoPrazoDias: progressoPrazoDias,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String etapaId,
            required String nome,
            required double precoTotal,
            required String unidade,
            required double quantidade,
            required DateTime dataInicio,
            required DateTime dataFim,
            required String status,
            Value<double> progressoFisico = const Value.absent(),
            Value<int> progressoPrazoDias = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServicosCompanion.insert(
            id: id,
            etapaId: etapaId,
            nome: nome,
            precoTotal: precoTotal,
            unidade: unidade,
            quantidade: quantidade,
            dataInicio: dataInicio,
            dataFim: dataFim,
            status: status,
            progressoFisico: progressoFisico,
            progressoPrazoDias: progressoPrazoDias,
            rowid: rowid,
          ),
        ));
}

class $$ServicosTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ServicosTable> {
  $$ServicosTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nome => $state.composableBuilder(
      column: $state.table.nome,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get precoTotal => $state.composableBuilder(
      column: $state.table.precoTotal,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unidade => $state.composableBuilder(
      column: $state.table.unidade,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get quantidade => $state.composableBuilder(
      column: $state.table.quantidade,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dataInicio => $state.composableBuilder(
      column: $state.table.dataInicio,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dataFim => $state.composableBuilder(
      column: $state.table.dataFim,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get progressoFisico => $state.composableBuilder(
      column: $state.table.progressoFisico,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get progressoPrazoDias => $state.composableBuilder(
      column: $state.table.progressoPrazoDias,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$EtapasTableFilterComposer get etapaId {
    final $$EtapasTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.etapaId,
        referencedTable: $state.db.etapas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$EtapasTableFilterComposer(
            ComposerState(
                $state.db, $state.db.etapas, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter vistoriasServicoRefs(
      ComposableFilter Function($$VistoriasServicoTableFilterComposer f) f) {
    final $$VistoriasServicoTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.vistoriasServico,
            getReferencedColumn: (t) => t.servicoId,
            builder: (joinBuilder, parentComposers) =>
                $$VistoriasServicoTableFilterComposer(ComposerState($state.db,
                    $state.db.vistoriasServico, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter medicoesRefs(
      ComposableFilter Function($$MedicoesTableFilterComposer f) f) {
    final $$MedicoesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.medicoes,
        getReferencedColumn: (t) => t.servicoId,
        builder: (joinBuilder, parentComposers) =>
            $$MedicoesTableFilterComposer(ComposerState(
                $state.db, $state.db.medicoes, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ServicosTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ServicosTable> {
  $$ServicosTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nome => $state.composableBuilder(
      column: $state.table.nome,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get precoTotal => $state.composableBuilder(
      column: $state.table.precoTotal,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unidade => $state.composableBuilder(
      column: $state.table.unidade,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get quantidade => $state.composableBuilder(
      column: $state.table.quantidade,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dataInicio => $state.composableBuilder(
      column: $state.table.dataInicio,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dataFim => $state.composableBuilder(
      column: $state.table.dataFim,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get progressoFisico => $state.composableBuilder(
      column: $state.table.progressoFisico,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get progressoPrazoDias => $state.composableBuilder(
      column: $state.table.progressoPrazoDias,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$EtapasTableOrderingComposer get etapaId {
    final $$EtapasTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.etapaId,
        referencedTable: $state.db.etapas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$EtapasTableOrderingComposer(ComposerState(
                $state.db, $state.db.etapas, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$VistoriasServicoTableCreateCompanionBuilder
    = VistoriasServicoCompanion Function({
  required String id,
  required String servicoId,
  required String obraId,
  required String contratanteId,
  required String responsavelId,
  required String numero,
  required DateTime data,
  required int diaSemana,
  required String status,
  Value<String?> ocorrencia,
  Value<String?> comentario,
  Value<int> rowid,
});
typedef $$VistoriasServicoTableUpdateCompanionBuilder
    = VistoriasServicoCompanion Function({
  Value<String> id,
  Value<String> servicoId,
  Value<String> obraId,
  Value<String> contratanteId,
  Value<String> responsavelId,
  Value<String> numero,
  Value<DateTime> data,
  Value<int> diaSemana,
  Value<String> status,
  Value<String?> ocorrencia,
  Value<String?> comentario,
  Value<int> rowid,
});

class $$VistoriasServicoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VistoriasServicoTable,
    VistoriasServicoData,
    $$VistoriasServicoTableFilterComposer,
    $$VistoriasServicoTableOrderingComposer,
    $$VistoriasServicoTableCreateCompanionBuilder,
    $$VistoriasServicoTableUpdateCompanionBuilder> {
  $$VistoriasServicoTableTableManager(
      _$AppDatabase db, $VistoriasServicoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$VistoriasServicoTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$VistoriasServicoTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> servicoId = const Value.absent(),
            Value<String> obraId = const Value.absent(),
            Value<String> contratanteId = const Value.absent(),
            Value<String> responsavelId = const Value.absent(),
            Value<String> numero = const Value.absent(),
            Value<DateTime> data = const Value.absent(),
            Value<int> diaSemana = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> ocorrencia = const Value.absent(),
            Value<String?> comentario = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VistoriasServicoCompanion(
            id: id,
            servicoId: servicoId,
            obraId: obraId,
            contratanteId: contratanteId,
            responsavelId: responsavelId,
            numero: numero,
            data: data,
            diaSemana: diaSemana,
            status: status,
            ocorrencia: ocorrencia,
            comentario: comentario,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String servicoId,
            required String obraId,
            required String contratanteId,
            required String responsavelId,
            required String numero,
            required DateTime data,
            required int diaSemana,
            required String status,
            Value<String?> ocorrencia = const Value.absent(),
            Value<String?> comentario = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VistoriasServicoCompanion.insert(
            id: id,
            servicoId: servicoId,
            obraId: obraId,
            contratanteId: contratanteId,
            responsavelId: responsavelId,
            numero: numero,
            data: data,
            diaSemana: diaSemana,
            status: status,
            ocorrencia: ocorrencia,
            comentario: comentario,
            rowid: rowid,
          ),
        ));
}

class $$VistoriasServicoTableFilterComposer
    extends FilterComposer<_$AppDatabase, $VistoriasServicoTable> {
  $$VistoriasServicoTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get numero => $state.composableBuilder(
      column: $state.table.numero,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get diaSemana => $state.composableBuilder(
      column: $state.table.diaSemana,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get ocorrencia => $state.composableBuilder(
      column: $state.table.ocorrencia,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get comentario => $state.composableBuilder(
      column: $state.table.comentario,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ServicosTableFilterComposer get servicoId {
    final $$ServicosTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.servicoId,
        referencedTable: $state.db.servicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ServicosTableFilterComposer(ComposerState(
                $state.db, $state.db.servicos, joinBuilder, parentComposers)));
    return composer;
  }

  $$ObrasTableFilterComposer get obraId {
    final $$ObrasTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.obraId,
        referencedTable: $state.db.obras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$ObrasTableFilterComposer(
            ComposerState(
                $state.db, $state.db.obras, joinBuilder, parentComposers)));
    return composer;
  }

  $$ContratantesTableFilterComposer get contratanteId {
    final $$ContratantesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contratanteId,
        referencedTable: $state.db.contratantes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ContratantesTableFilterComposer(ComposerState($state.db,
                $state.db.contratantes, joinBuilder, parentComposers)));
    return composer;
  }

  $$FuncionariosTableFilterComposer get responsavelId {
    final $$FuncionariosTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.responsavelId,
        referencedTable: $state.db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$FuncionariosTableFilterComposer(ComposerState($state.db,
                $state.db.funcionarios, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter vistoriasPeriodoRefs(
      ComposableFilter Function($$VistoriasPeriodoTableFilterComposer f) f) {
    final $$VistoriasPeriodoTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.vistoriasPeriodo,
            getReferencedColumn: (t) => t.vistoriaServicoId,
            builder: (joinBuilder, parentComposers) =>
                $$VistoriasPeriodoTableFilterComposer(ComposerState($state.db,
                    $state.db.vistoriasPeriodo, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter vistoriasMaoDeObraRefs(
      ComposableFilter Function($$VistoriasMaoDeObraTableFilterComposer f) f) {
    final $$VistoriasMaoDeObraTableFilterComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.vistoriasMaoDeObra,
            getReferencedColumn: (t) => t.vistoriaServicoId,
            builder: (joinBuilder, parentComposers) =>
                $$VistoriasMaoDeObraTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.vistoriasMaoDeObra,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }

  ComposableFilter medicoesRefs(
      ComposableFilter Function($$MedicoesTableFilterComposer f) f) {
    final $$MedicoesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.medicoes,
        getReferencedColumn: (t) => t.vistoriaServicoId,
        builder: (joinBuilder, parentComposers) =>
            $$MedicoesTableFilterComposer(ComposerState(
                $state.db, $state.db.medicoes, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$VistoriasServicoTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $VistoriasServicoTable> {
  $$VistoriasServicoTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get numero => $state.composableBuilder(
      column: $state.table.numero,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get diaSemana => $state.composableBuilder(
      column: $state.table.diaSemana,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get ocorrencia => $state.composableBuilder(
      column: $state.table.ocorrencia,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get comentario => $state.composableBuilder(
      column: $state.table.comentario,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ServicosTableOrderingComposer get servicoId {
    final $$ServicosTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.servicoId,
        referencedTable: $state.db.servicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ServicosTableOrderingComposer(ComposerState(
                $state.db, $state.db.servicos, joinBuilder, parentComposers)));
    return composer;
  }

  $$ObrasTableOrderingComposer get obraId {
    final $$ObrasTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.obraId,
        referencedTable: $state.db.obras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$ObrasTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.obras, joinBuilder, parentComposers)));
    return composer;
  }

  $$ContratantesTableOrderingComposer get contratanteId {
    final $$ContratantesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contratanteId,
        referencedTable: $state.db.contratantes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ContratantesTableOrderingComposer(ComposerState($state.db,
                $state.db.contratantes, joinBuilder, parentComposers)));
    return composer;
  }

  $$FuncionariosTableOrderingComposer get responsavelId {
    final $$FuncionariosTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.responsavelId,
        referencedTable: $state.db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$FuncionariosTableOrderingComposer(ComposerState($state.db,
                $state.db.funcionarios, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$VistoriasPeriodoTableCreateCompanionBuilder
    = VistoriasPeriodoCompanion Function({
  required String id,
  required String vistoriaServicoId,
  required String periodo,
  required String tempo,
  required String condicao,
  Value<int> rowid,
});
typedef $$VistoriasPeriodoTableUpdateCompanionBuilder
    = VistoriasPeriodoCompanion Function({
  Value<String> id,
  Value<String> vistoriaServicoId,
  Value<String> periodo,
  Value<String> tempo,
  Value<String> condicao,
  Value<int> rowid,
});

class $$VistoriasPeriodoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VistoriasPeriodoTable,
    VistoriasPeriodoData,
    $$VistoriasPeriodoTableFilterComposer,
    $$VistoriasPeriodoTableOrderingComposer,
    $$VistoriasPeriodoTableCreateCompanionBuilder,
    $$VistoriasPeriodoTableUpdateCompanionBuilder> {
  $$VistoriasPeriodoTableTableManager(
      _$AppDatabase db, $VistoriasPeriodoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$VistoriasPeriodoTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$VistoriasPeriodoTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> vistoriaServicoId = const Value.absent(),
            Value<String> periodo = const Value.absent(),
            Value<String> tempo = const Value.absent(),
            Value<String> condicao = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VistoriasPeriodoCompanion(
            id: id,
            vistoriaServicoId: vistoriaServicoId,
            periodo: periodo,
            tempo: tempo,
            condicao: condicao,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String vistoriaServicoId,
            required String periodo,
            required String tempo,
            required String condicao,
            Value<int> rowid = const Value.absent(),
          }) =>
              VistoriasPeriodoCompanion.insert(
            id: id,
            vistoriaServicoId: vistoriaServicoId,
            periodo: periodo,
            tempo: tempo,
            condicao: condicao,
            rowid: rowid,
          ),
        ));
}

class $$VistoriasPeriodoTableFilterComposer
    extends FilterComposer<_$AppDatabase, $VistoriasPeriodoTable> {
  $$VistoriasPeriodoTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get periodo => $state.composableBuilder(
      column: $state.table.periodo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get tempo => $state.composableBuilder(
      column: $state.table.tempo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get condicao => $state.composableBuilder(
      column: $state.table.condicao,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$VistoriasServicoTableFilterComposer get vistoriaServicoId {
    final $$VistoriasServicoTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.vistoriaServicoId,
            referencedTable: $state.db.vistoriasServico,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$VistoriasServicoTableFilterComposer(ComposerState($state.db,
                    $state.db.vistoriasServico, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$VistoriasPeriodoTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $VistoriasPeriodoTable> {
  $$VistoriasPeriodoTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get periodo => $state.composableBuilder(
      column: $state.table.periodo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get tempo => $state.composableBuilder(
      column: $state.table.tempo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get condicao => $state.composableBuilder(
      column: $state.table.condicao,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$VistoriasServicoTableOrderingComposer get vistoriaServicoId {
    final $$VistoriasServicoTableOrderingComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.vistoriaServicoId,
            referencedTable: $state.db.vistoriasServico,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$VistoriasServicoTableOrderingComposer(ComposerState($state.db,
                    $state.db.vistoriasServico, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$VistoriasMaoDeObraTableCreateCompanionBuilder
    = VistoriasMaoDeObraCompanion Function({
  required String id,
  required String vistoriaServicoId,
  required String funcionarioId,
  Value<String?> funcaoNoDia,
  Value<String?> observacao,
  Value<int> rowid,
});
typedef $$VistoriasMaoDeObraTableUpdateCompanionBuilder
    = VistoriasMaoDeObraCompanion Function({
  Value<String> id,
  Value<String> vistoriaServicoId,
  Value<String> funcionarioId,
  Value<String?> funcaoNoDia,
  Value<String?> observacao,
  Value<int> rowid,
});

class $$VistoriasMaoDeObraTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VistoriasMaoDeObraTable,
    VistoriasMaoDeObraData,
    $$VistoriasMaoDeObraTableFilterComposer,
    $$VistoriasMaoDeObraTableOrderingComposer,
    $$VistoriasMaoDeObraTableCreateCompanionBuilder,
    $$VistoriasMaoDeObraTableUpdateCompanionBuilder> {
  $$VistoriasMaoDeObraTableTableManager(
      _$AppDatabase db, $VistoriasMaoDeObraTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$VistoriasMaoDeObraTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$VistoriasMaoDeObraTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> vistoriaServicoId = const Value.absent(),
            Value<String> funcionarioId = const Value.absent(),
            Value<String?> funcaoNoDia = const Value.absent(),
            Value<String?> observacao = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VistoriasMaoDeObraCompanion(
            id: id,
            vistoriaServicoId: vistoriaServicoId,
            funcionarioId: funcionarioId,
            funcaoNoDia: funcaoNoDia,
            observacao: observacao,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String vistoriaServicoId,
            required String funcionarioId,
            Value<String?> funcaoNoDia = const Value.absent(),
            Value<String?> observacao = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VistoriasMaoDeObraCompanion.insert(
            id: id,
            vistoriaServicoId: vistoriaServicoId,
            funcionarioId: funcionarioId,
            funcaoNoDia: funcaoNoDia,
            observacao: observacao,
            rowid: rowid,
          ),
        ));
}

class $$VistoriasMaoDeObraTableFilterComposer
    extends FilterComposer<_$AppDatabase, $VistoriasMaoDeObraTable> {
  $$VistoriasMaoDeObraTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get funcaoNoDia => $state.composableBuilder(
      column: $state.table.funcaoNoDia,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get observacao => $state.composableBuilder(
      column: $state.table.observacao,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$VistoriasServicoTableFilterComposer get vistoriaServicoId {
    final $$VistoriasServicoTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.vistoriaServicoId,
            referencedTable: $state.db.vistoriasServico,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$VistoriasServicoTableFilterComposer(ComposerState($state.db,
                    $state.db.vistoriasServico, joinBuilder, parentComposers)));
    return composer;
  }

  $$FuncionariosTableFilterComposer get funcionarioId {
    final $$FuncionariosTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $state.db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$FuncionariosTableFilterComposer(ComposerState($state.db,
                $state.db.funcionarios, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$VistoriasMaoDeObraTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $VistoriasMaoDeObraTable> {
  $$VistoriasMaoDeObraTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get funcaoNoDia => $state.composableBuilder(
      column: $state.table.funcaoNoDia,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get observacao => $state.composableBuilder(
      column: $state.table.observacao,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$VistoriasServicoTableOrderingComposer get vistoriaServicoId {
    final $$VistoriasServicoTableOrderingComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.vistoriaServicoId,
            referencedTable: $state.db.vistoriasServico,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$VistoriasServicoTableOrderingComposer(ComposerState($state.db,
                    $state.db.vistoriasServico, joinBuilder, parentComposers)));
    return composer;
  }

  $$FuncionariosTableOrderingComposer get funcionarioId {
    final $$FuncionariosTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.funcionarioId,
        referencedTable: $state.db.funcionarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$FuncionariosTableOrderingComposer(ComposerState($state.db,
                $state.db.funcionarios, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$MedicoesTableCreateCompanionBuilder = MedicoesCompanion Function({
  required String id,
  required String servicoId,
  Value<String?> vistoriaServicoId,
  required double percentualExecutado,
  Value<String?> observacao,
  required DateTime data,
  Value<int> rowid,
});
typedef $$MedicoesTableUpdateCompanionBuilder = MedicoesCompanion Function({
  Value<String> id,
  Value<String> servicoId,
  Value<String?> vistoriaServicoId,
  Value<double> percentualExecutado,
  Value<String?> observacao,
  Value<DateTime> data,
  Value<int> rowid,
});

class $$MedicoesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicoesTable,
    Medicoe,
    $$MedicoesTableFilterComposer,
    $$MedicoesTableOrderingComposer,
    $$MedicoesTableCreateCompanionBuilder,
    $$MedicoesTableUpdateCompanionBuilder> {
  $$MedicoesTableTableManager(_$AppDatabase db, $MedicoesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$MedicoesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$MedicoesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> servicoId = const Value.absent(),
            Value<String?> vistoriaServicoId = const Value.absent(),
            Value<double> percentualExecutado = const Value.absent(),
            Value<String?> observacao = const Value.absent(),
            Value<DateTime> data = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicoesCompanion(
            id: id,
            servicoId: servicoId,
            vistoriaServicoId: vistoriaServicoId,
            percentualExecutado: percentualExecutado,
            observacao: observacao,
            data: data,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String servicoId,
            Value<String?> vistoriaServicoId = const Value.absent(),
            required double percentualExecutado,
            Value<String?> observacao = const Value.absent(),
            required DateTime data,
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicoesCompanion.insert(
            id: id,
            servicoId: servicoId,
            vistoriaServicoId: vistoriaServicoId,
            percentualExecutado: percentualExecutado,
            observacao: observacao,
            data: data,
            rowid: rowid,
          ),
        ));
}

class $$MedicoesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $MedicoesTable> {
  $$MedicoesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get percentualExecutado => $state.composableBuilder(
      column: $state.table.percentualExecutado,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get observacao => $state.composableBuilder(
      column: $state.table.observacao,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ServicosTableFilterComposer get servicoId {
    final $$ServicosTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.servicoId,
        referencedTable: $state.db.servicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ServicosTableFilterComposer(ComposerState(
                $state.db, $state.db.servicos, joinBuilder, parentComposers)));
    return composer;
  }

  $$VistoriasServicoTableFilterComposer get vistoriaServicoId {
    final $$VistoriasServicoTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.vistoriaServicoId,
            referencedTable: $state.db.vistoriasServico,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$VistoriasServicoTableFilterComposer(ComposerState($state.db,
                    $state.db.vistoriasServico, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter fotosRefs(
      ComposableFilter Function($$FotosTableFilterComposer f) f) {
    final $$FotosTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.fotos,
        getReferencedColumn: (t) => t.medicaoId,
        builder: (joinBuilder, parentComposers) => $$FotosTableFilterComposer(
            ComposerState(
                $state.db, $state.db.fotos, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$MedicoesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $MedicoesTable> {
  $$MedicoesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get percentualExecutado => $state.composableBuilder(
      column: $state.table.percentualExecutado,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get observacao => $state.composableBuilder(
      column: $state.table.observacao,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ServicosTableOrderingComposer get servicoId {
    final $$ServicosTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.servicoId,
        referencedTable: $state.db.servicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ServicosTableOrderingComposer(ComposerState(
                $state.db, $state.db.servicos, joinBuilder, parentComposers)));
    return composer;
  }

  $$VistoriasServicoTableOrderingComposer get vistoriaServicoId {
    final $$VistoriasServicoTableOrderingComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.vistoriaServicoId,
            referencedTable: $state.db.vistoriasServico,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$VistoriasServicoTableOrderingComposer(ComposerState($state.db,
                    $state.db.vistoriasServico, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$FotosTableCreateCompanionBuilder = FotosCompanion Function({
  required String id,
  required String medicaoId,
  required String caminhoArquivo,
  Value<int> rowid,
});
typedef $$FotosTableUpdateCompanionBuilder = FotosCompanion Function({
  Value<String> id,
  Value<String> medicaoId,
  Value<String> caminhoArquivo,
  Value<int> rowid,
});

class $$FotosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FotosTable,
    Foto,
    $$FotosTableFilterComposer,
    $$FotosTableOrderingComposer,
    $$FotosTableCreateCompanionBuilder,
    $$FotosTableUpdateCompanionBuilder> {
  $$FotosTableTableManager(_$AppDatabase db, $FotosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$FotosTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$FotosTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> medicaoId = const Value.absent(),
            Value<String> caminhoArquivo = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FotosCompanion(
            id: id,
            medicaoId: medicaoId,
            caminhoArquivo: caminhoArquivo,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String medicaoId,
            required String caminhoArquivo,
            Value<int> rowid = const Value.absent(),
          }) =>
              FotosCompanion.insert(
            id: id,
            medicaoId: medicaoId,
            caminhoArquivo: caminhoArquivo,
            rowid: rowid,
          ),
        ));
}

class $$FotosTableFilterComposer
    extends FilterComposer<_$AppDatabase, $FotosTable> {
  $$FotosTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get caminhoArquivo => $state.composableBuilder(
      column: $state.table.caminhoArquivo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$MedicoesTableFilterComposer get medicaoId {
    final $$MedicoesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicaoId,
        referencedTable: $state.db.medicoes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$MedicoesTableFilterComposer(ComposerState(
                $state.db, $state.db.medicoes, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$FotosTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $FotosTable> {
  $$FotosTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get caminhoArquivo => $state.composableBuilder(
      column: $state.table.caminhoArquivo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$MedicoesTableOrderingComposer get medicaoId {
    final $$MedicoesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicaoId,
        referencedTable: $state.db.medicoes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$MedicoesTableOrderingComposer(ComposerState(
                $state.db, $state.db.medicoes, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$HistoricosAlteracaoTableCreateCompanionBuilder
    = HistoricosAlteracaoCompanion Function({
  required String id,
  required String entidade,
  required String entidadeId,
  required String campo,
  Value<String?> valorAnterior,
  Value<String?> valorNovo,
  required DateTime data,
  Value<String?> usuario,
  Value<int> rowid,
});
typedef $$HistoricosAlteracaoTableUpdateCompanionBuilder
    = HistoricosAlteracaoCompanion Function({
  Value<String> id,
  Value<String> entidade,
  Value<String> entidadeId,
  Value<String> campo,
  Value<String?> valorAnterior,
  Value<String?> valorNovo,
  Value<DateTime> data,
  Value<String?> usuario,
  Value<int> rowid,
});

class $$HistoricosAlteracaoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HistoricosAlteracaoTable,
    HistoricosAlteracaoData,
    $$HistoricosAlteracaoTableFilterComposer,
    $$HistoricosAlteracaoTableOrderingComposer,
    $$HistoricosAlteracaoTableCreateCompanionBuilder,
    $$HistoricosAlteracaoTableUpdateCompanionBuilder> {
  $$HistoricosAlteracaoTableTableManager(
      _$AppDatabase db, $HistoricosAlteracaoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$HistoricosAlteracaoTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$HistoricosAlteracaoTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entidade = const Value.absent(),
            Value<String> entidadeId = const Value.absent(),
            Value<String> campo = const Value.absent(),
            Value<String?> valorAnterior = const Value.absent(),
            Value<String?> valorNovo = const Value.absent(),
            Value<DateTime> data = const Value.absent(),
            Value<String?> usuario = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HistoricosAlteracaoCompanion(
            id: id,
            entidade: entidade,
            entidadeId: entidadeId,
            campo: campo,
            valorAnterior: valorAnterior,
            valorNovo: valorNovo,
            data: data,
            usuario: usuario,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entidade,
            required String entidadeId,
            required String campo,
            Value<String?> valorAnterior = const Value.absent(),
            Value<String?> valorNovo = const Value.absent(),
            required DateTime data,
            Value<String?> usuario = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HistoricosAlteracaoCompanion.insert(
            id: id,
            entidade: entidade,
            entidadeId: entidadeId,
            campo: campo,
            valorAnterior: valorAnterior,
            valorNovo: valorNovo,
            data: data,
            usuario: usuario,
            rowid: rowid,
          ),
        ));
}

class $$HistoricosAlteracaoTableFilterComposer
    extends FilterComposer<_$AppDatabase, $HistoricosAlteracaoTable> {
  $$HistoricosAlteracaoTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get entidade => $state.composableBuilder(
      column: $state.table.entidade,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get entidadeId => $state.composableBuilder(
      column: $state.table.entidadeId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get campo => $state.composableBuilder(
      column: $state.table.campo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get valorAnterior => $state.composableBuilder(
      column: $state.table.valorAnterior,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get valorNovo => $state.composableBuilder(
      column: $state.table.valorNovo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get usuario => $state.composableBuilder(
      column: $state.table.usuario,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$HistoricosAlteracaoTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $HistoricosAlteracaoTable> {
  $$HistoricosAlteracaoTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get entidade => $state.composableBuilder(
      column: $state.table.entidade,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get entidadeId => $state.composableBuilder(
      column: $state.table.entidadeId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get campo => $state.composableBuilder(
      column: $state.table.campo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get valorAnterior => $state.composableBuilder(
      column: $state.table.valorAnterior,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get valorNovo => $state.composableBuilder(
      column: $state.table.valorNovo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get usuario => $state.composableBuilder(
      column: $state.table.usuario,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EmpresasTableTableManager get empresas =>
      $$EmpresasTableTableManager(_db, _db.empresas);
  $$ContratantesTableTableManager get contratantes =>
      $$ContratantesTableTableManager(_db, _db.contratantes);
  $$FuncionariosTableTableManager get funcionarios =>
      $$FuncionariosTableTableManager(_db, _db.funcionarios);
  $$EnderecosTableTableManager get enderecos =>
      $$EnderecosTableTableManager(_db, _db.enderecos);
  $$ContatosTableTableManager get contatos =>
      $$ContatosTableTableManager(_db, _db.contatos);
  $$ObrasTableTableManager get obras =>
      $$ObrasTableTableManager(_db, _db.obras);
  $$EtapasTableTableManager get etapas =>
      $$EtapasTableTableManager(_db, _db.etapas);
  $$ServicosTableTableManager get servicos =>
      $$ServicosTableTableManager(_db, _db.servicos);
  $$VistoriasServicoTableTableManager get vistoriasServico =>
      $$VistoriasServicoTableTableManager(_db, _db.vistoriasServico);
  $$VistoriasPeriodoTableTableManager get vistoriasPeriodo =>
      $$VistoriasPeriodoTableTableManager(_db, _db.vistoriasPeriodo);
  $$VistoriasMaoDeObraTableTableManager get vistoriasMaoDeObra =>
      $$VistoriasMaoDeObraTableTableManager(_db, _db.vistoriasMaoDeObra);
  $$MedicoesTableTableManager get medicoes =>
      $$MedicoesTableTableManager(_db, _db.medicoes);
  $$FotosTableTableManager get fotos =>
      $$FotosTableTableManager(_db, _db.fotos);
  $$HistoricosAlteracaoTableTableManager get historicosAlteracao =>
      $$HistoricosAlteracaoTableTableManager(_db, _db.historicosAlteracao);
}
