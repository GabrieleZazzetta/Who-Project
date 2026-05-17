// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_user_credential.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalUserCredentialCollection on Isar {
  IsarCollection<LocalUserCredential> get localUserCredentials =>
      this.collection();
}

const LocalUserCredentialSchema = CollectionSchema(
  name: r'LocalUserCredential',
  id: -6614532530314082158,
  properties: {
    r'dateOfBirth': PropertySchema(
      id: 0,
      name: r'dateOfBirth',
      type: IsarType.dateTime,
    ),
    r'displayName': PropertySchema(
      id: 1,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'email': PropertySchema(
      id: 2,
      name: r'email',
      type: IsarType.string,
    ),
    r'isWhoStaff': PropertySchema(
      id: 3,
      name: r'isWhoStaff',
      type: IsarType.bool,
    ),
    r'oldPassword': PropertySchema(
      id: 4,
      name: r'oldPassword',
      type: IsarType.string,
    ),
    r'passwordHash': PropertySchema(
      id: 5,
      name: r'passwordHash',
      type: IsarType.string,
    ),
    r'passwordNeedsSync': PropertySchema(
      id: 6,
      name: r'passwordNeedsSync',
      type: IsarType.bool,
    ),
    r'pendingPassword': PropertySchema(
      id: 7,
      name: r'pendingPassword',
      type: IsarType.string,
    )
  },
  estimateSize: _localUserCredentialEstimateSize,
  serialize: _localUserCredentialSerialize,
  deserialize: _localUserCredentialDeserialize,
  deserializeProp: _localUserCredentialDeserializeProp,
  idName: r'id',
  indexes: {
    r'email': IndexSchema(
      id: -26095440403582047,
      name: r'email',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'email',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localUserCredentialGetId,
  getLinks: _localUserCredentialGetLinks,
  attach: _localUserCredentialAttach,
  version: '3.1.0+1',
);

int _localUserCredentialEstimateSize(
  LocalUserCredential object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.displayName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.email;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.oldPassword;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.passwordHash;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pendingPassword;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _localUserCredentialSerialize(
  LocalUserCredential object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateOfBirth);
  writer.writeString(offsets[1], object.displayName);
  writer.writeString(offsets[2], object.email);
  writer.writeBool(offsets[3], object.isWhoStaff);
  writer.writeString(offsets[4], object.oldPassword);
  writer.writeString(offsets[5], object.passwordHash);
  writer.writeBool(offsets[6], object.passwordNeedsSync);
  writer.writeString(offsets[7], object.pendingPassword);
}

LocalUserCredential _localUserCredentialDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalUserCredential();
  object.dateOfBirth = reader.readDateTimeOrNull(offsets[0]);
  object.displayName = reader.readStringOrNull(offsets[1]);
  object.email = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.isWhoStaff = reader.readBool(offsets[3]);
  object.oldPassword = reader.readStringOrNull(offsets[4]);
  object.passwordHash = reader.readStringOrNull(offsets[5]);
  object.passwordNeedsSync = reader.readBool(offsets[6]);
  object.pendingPassword = reader.readStringOrNull(offsets[7]);
  return object;
}

P _localUserCredentialDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localUserCredentialGetId(LocalUserCredential object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localUserCredentialGetLinks(
    LocalUserCredential object) {
  return [];
}

void _localUserCredentialAttach(
    IsarCollection<dynamic> col, Id id, LocalUserCredential object) {
  object.id = id;
}

extension LocalUserCredentialByIndex on IsarCollection<LocalUserCredential> {
  Future<LocalUserCredential?> getByEmail(String? email) {
    return getByIndex(r'email', [email]);
  }

  LocalUserCredential? getByEmailSync(String? email) {
    return getByIndexSync(r'email', [email]);
  }

  Future<bool> deleteByEmail(String? email) {
    return deleteByIndex(r'email', [email]);
  }

  bool deleteByEmailSync(String? email) {
    return deleteByIndexSync(r'email', [email]);
  }

  Future<List<LocalUserCredential?>> getAllByEmail(List<String?> emailValues) {
    final values = emailValues.map((e) => [e]).toList();
    return getAllByIndex(r'email', values);
  }

  List<LocalUserCredential?> getAllByEmailSync(List<String?> emailValues) {
    final values = emailValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'email', values);
  }

  Future<int> deleteAllByEmail(List<String?> emailValues) {
    final values = emailValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'email', values);
  }

  int deleteAllByEmailSync(List<String?> emailValues) {
    final values = emailValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'email', values);
  }

  Future<Id> putByEmail(LocalUserCredential object) {
    return putByIndex(r'email', object);
  }

  Id putByEmailSync(LocalUserCredential object, {bool saveLinks = true}) {
    return putByIndexSync(r'email', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEmail(List<LocalUserCredential> objects) {
    return putAllByIndex(r'email', objects);
  }

  List<Id> putAllByEmailSync(List<LocalUserCredential> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'email', objects, saveLinks: saveLinks);
  }
}

extension LocalUserCredentialQueryWhereSort
    on QueryBuilder<LocalUserCredential, LocalUserCredential, QWhere> {
  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalUserCredentialQueryWhere
    on QueryBuilder<LocalUserCredential, LocalUserCredential, QWhereClause> {
  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterWhereClause>
      emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'email',
        value: [null],
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterWhereClause>
      emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'email',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterWhereClause>
      emailEqualTo(String? email) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'email',
        value: [email],
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterWhereClause>
      emailNotEqualTo(String? email) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'email',
              lower: [],
              upper: [email],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'email',
              lower: [email],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'email',
              lower: [email],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'email',
              lower: [],
              upper: [email],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LocalUserCredentialQueryFilter on QueryBuilder<LocalUserCredential,
    LocalUserCredential, QFilterCondition> {
  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      dateOfBirthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateOfBirth',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      dateOfBirthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateOfBirth',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      dateOfBirthEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOfBirth',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      dateOfBirthGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateOfBirth',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      dateOfBirthLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateOfBirth',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      dateOfBirthBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateOfBirth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      displayNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'displayName',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      displayNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'displayName',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      displayNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      displayNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      displayNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      displayNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      emailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      emailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      emailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      emailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      isWhoStaffEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isWhoStaff',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      oldPasswordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'oldPassword',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      oldPasswordIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'oldPassword',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      oldPasswordEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'oldPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      oldPasswordGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'oldPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      oldPasswordLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'oldPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      oldPasswordBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'oldPassword',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      oldPasswordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'oldPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      oldPasswordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'oldPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      oldPasswordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'oldPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      oldPasswordMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'oldPassword',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      oldPasswordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'oldPassword',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      oldPasswordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'oldPassword',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      passwordHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'passwordHash',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      passwordHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'passwordHash',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      passwordHashEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'passwordHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      passwordHashGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'passwordHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      passwordHashLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'passwordHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      passwordHashBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'passwordHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      passwordHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'passwordHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      passwordHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'passwordHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      passwordHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'passwordHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      passwordHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'passwordHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      passwordHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'passwordHash',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      passwordHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'passwordHash',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      passwordNeedsSyncEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'passwordNeedsSync',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      pendingPasswordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pendingPassword',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      pendingPasswordIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pendingPassword',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      pendingPasswordEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pendingPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      pendingPasswordGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pendingPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      pendingPasswordLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pendingPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      pendingPasswordBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pendingPassword',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      pendingPasswordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pendingPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      pendingPasswordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pendingPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      pendingPasswordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pendingPassword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      pendingPasswordMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pendingPassword',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      pendingPasswordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pendingPassword',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterFilterCondition>
      pendingPasswordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pendingPassword',
        value: '',
      ));
    });
  }
}

extension LocalUserCredentialQueryObject on QueryBuilder<LocalUserCredential,
    LocalUserCredential, QFilterCondition> {}

extension LocalUserCredentialQueryLinks on QueryBuilder<LocalUserCredential,
    LocalUserCredential, QFilterCondition> {}

extension LocalUserCredentialQuerySortBy
    on QueryBuilder<LocalUserCredential, LocalUserCredential, QSortBy> {
  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByDateOfBirth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByDateOfBirthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByIsWhoStaff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWhoStaff', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByIsWhoStaffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWhoStaff', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByOldPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'oldPassword', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByOldPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'oldPassword', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByPasswordHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByPasswordHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByPasswordNeedsSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordNeedsSync', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByPasswordNeedsSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordNeedsSync', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByPendingPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingPassword', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      sortByPendingPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingPassword', Sort.desc);
    });
  }
}

extension LocalUserCredentialQuerySortThenBy
    on QueryBuilder<LocalUserCredential, LocalUserCredential, QSortThenBy> {
  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByDateOfBirth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByDateOfBirthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByIsWhoStaff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWhoStaff', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByIsWhoStaffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWhoStaff', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByOldPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'oldPassword', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByOldPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'oldPassword', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByPasswordHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByPasswordHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByPasswordNeedsSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordNeedsSync', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByPasswordNeedsSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordNeedsSync', Sort.desc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByPendingPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingPassword', Sort.asc);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QAfterSortBy>
      thenByPendingPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingPassword', Sort.desc);
    });
  }
}

extension LocalUserCredentialQueryWhereDistinct
    on QueryBuilder<LocalUserCredential, LocalUserCredential, QDistinct> {
  QueryBuilder<LocalUserCredential, LocalUserCredential, QDistinct>
      distinctByDateOfBirth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateOfBirth');
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QDistinct>
      distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QDistinct>
      distinctByEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QDistinct>
      distinctByIsWhoStaff() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isWhoStaff');
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QDistinct>
      distinctByOldPassword({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'oldPassword', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QDistinct>
      distinctByPasswordHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passwordHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QDistinct>
      distinctByPasswordNeedsSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passwordNeedsSync');
    });
  }

  QueryBuilder<LocalUserCredential, LocalUserCredential, QDistinct>
      distinctByPendingPassword({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pendingPassword',
          caseSensitive: caseSensitive);
    });
  }
}

extension LocalUserCredentialQueryProperty
    on QueryBuilder<LocalUserCredential, LocalUserCredential, QQueryProperty> {
  QueryBuilder<LocalUserCredential, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalUserCredential, DateTime?, QQueryOperations>
      dateOfBirthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateOfBirth');
    });
  }

  QueryBuilder<LocalUserCredential, String?, QQueryOperations>
      displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<LocalUserCredential, String?, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<LocalUserCredential, bool, QQueryOperations>
      isWhoStaffProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isWhoStaff');
    });
  }

  QueryBuilder<LocalUserCredential, String?, QQueryOperations>
      oldPasswordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'oldPassword');
    });
  }

  QueryBuilder<LocalUserCredential, String?, QQueryOperations>
      passwordHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passwordHash');
    });
  }

  QueryBuilder<LocalUserCredential, bool, QQueryOperations>
      passwordNeedsSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passwordNeedsSync');
    });
  }

  QueryBuilder<LocalUserCredential, String?, QQueryOperations>
      pendingPasswordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pendingPassword');
    });
  }
}
