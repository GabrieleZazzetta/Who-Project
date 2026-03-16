// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFacilityLayoutCollection on Isar {
  IsarCollection<FacilityLayout> get facilityLayouts => this.collection();
}

const FacilityLayoutSchema = CollectionSchema(
  name: r'FacilityLayout',
  id: -3370888010523651538,
  properties: {
    r'dateCreated': PropertySchema(
      id: 0,
      name: r'dateCreated',
      type: IsarType.dateTime,
    ),
    r'emergencyType': PropertySchema(
      id: 1,
      name: r'emergencyType',
      type: IsarType.byte,
      enumMap: _FacilityLayoutemergencyTypeEnumValueMap,
    ),
    r'facilityName': PropertySchema(
      id: 2,
      name: r'facilityName',
      type: IsarType.string,
    ),
    r'mapImagePath': PropertySchema(
      id: 3,
      name: r'mapImagePath',
      type: IsarType.string,
    ),
    r'zones': PropertySchema(
      id: 4,
      name: r'zones',
      type: IsarType.objectList,
      target: r'SpatialZone',
    )
  },
  estimateSize: _facilityLayoutEstimateSize,
  serialize: _facilityLayoutSerialize,
  deserialize: _facilityLayoutDeserialize,
  deserializeProp: _facilityLayoutDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'SpatialZone': SpatialZoneSchema,
    r'MapCoordinates': MapCoordinatesSchema,
    r'AssessmentQuestion': AssessmentQuestionSchema
  },
  getId: _facilityLayoutGetId,
  getLinks: _facilityLayoutGetLinks,
  attach: _facilityLayoutAttach,
  version: '3.1.0+1',
);

int _facilityLayoutEstimateSize(
  FacilityLayout object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.facilityName.length * 3;
  bytesCount += 3 + object.mapImagePath.length * 3;
  bytesCount += 3 + object.zones.length * 3;
  {
    final offsets = allOffsets[SpatialZone]!;
    for (var i = 0; i < object.zones.length; i++) {
      final value = object.zones[i];
      bytesCount += SpatialZoneSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _facilityLayoutSerialize(
  FacilityLayout object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateCreated);
  writer.writeByte(offsets[1], object.emergencyType.index);
  writer.writeString(offsets[2], object.facilityName);
  writer.writeString(offsets[3], object.mapImagePath);
  writer.writeObjectList<SpatialZone>(
    offsets[4],
    allOffsets,
    SpatialZoneSchema.serialize,
    object.zones,
  );
}

FacilityLayout _facilityLayoutDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FacilityLayout(
    dateCreated: reader.readDateTimeOrNull(offsets[0]),
    emergencyType: _FacilityLayoutemergencyTypeValueEnumMap[
            reader.readByteOrNull(offsets[1])] ??
        EmergencyType.mpox,
    facilityName: reader.readStringOrNull(offsets[2]) ?? '',
    mapImagePath: reader.readStringOrNull(offsets[3]) ?? '',
    zones: reader.readObjectList<SpatialZone>(
          offsets[4],
          SpatialZoneSchema.deserialize,
          allOffsets,
          SpatialZone(),
        ) ??
        const [],
  );
  object.id = id;
  return object;
}

P _facilityLayoutDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (_FacilityLayoutemergencyTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          EmergencyType.mpox) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readObjectList<SpatialZone>(
            offset,
            SpatialZoneSchema.deserialize,
            allOffsets,
            SpatialZone(),
          ) ??
          const []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _FacilityLayoutemergencyTypeEnumValueMap = {
  'mpox': 0,
  'ebola': 1,
  'sars': 2,
};
const _FacilityLayoutemergencyTypeValueEnumMap = {
  0: EmergencyType.mpox,
  1: EmergencyType.ebola,
  2: EmergencyType.sars,
};

Id _facilityLayoutGetId(FacilityLayout object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _facilityLayoutGetLinks(FacilityLayout object) {
  return [];
}

void _facilityLayoutAttach(
    IsarCollection<dynamic> col, Id id, FacilityLayout object) {
  object.id = id;
}

extension FacilityLayoutQueryWhereSort
    on QueryBuilder<FacilityLayout, FacilityLayout, QWhere> {
  QueryBuilder<FacilityLayout, FacilityLayout, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FacilityLayoutQueryWhere
    on QueryBuilder<FacilityLayout, FacilityLayout, QWhereClause> {
  QueryBuilder<FacilityLayout, FacilityLayout, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterWhereClause> idBetween(
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
}

extension FacilityLayoutQueryFilter
    on QueryBuilder<FacilityLayout, FacilityLayout, QFilterCondition> {
  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      dateCreatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateCreated',
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      dateCreatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateCreated',
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      dateCreatedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      dateCreatedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      dateCreatedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      dateCreatedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateCreated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      emergencyTypeEqualTo(EmergencyType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emergencyType',
        value: value,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      emergencyTypeGreaterThan(
    EmergencyType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emergencyType',
        value: value,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      emergencyTypeLessThan(
    EmergencyType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emergencyType',
        value: value,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      emergencyTypeBetween(
    EmergencyType lower,
    EmergencyType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emergencyType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      facilityNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      facilityNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'facilityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      facilityNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'facilityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      facilityNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'facilityName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      facilityNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'facilityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      facilityNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'facilityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      facilityNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'facilityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      facilityNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'facilityName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      facilityNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityName',
        value: '',
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      facilityNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'facilityName',
        value: '',
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
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

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
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

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      mapImagePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mapImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      mapImagePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mapImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      mapImagePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mapImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      mapImagePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mapImagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      mapImagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mapImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      mapImagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mapImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      mapImagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mapImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      mapImagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mapImagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      mapImagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mapImagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      mapImagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mapImagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      zonesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zones',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      zonesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zones',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      zonesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zones',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      zonesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zones',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      zonesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zones',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      zonesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zones',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension FacilityLayoutQueryObject
    on QueryBuilder<FacilityLayout, FacilityLayout, QFilterCondition> {
  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      zonesElement(FilterQuery<SpatialZone> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'zones');
    });
  }
}

extension FacilityLayoutQueryLinks
    on QueryBuilder<FacilityLayout, FacilityLayout, QFilterCondition> {}

extension FacilityLayoutQuerySortBy
    on QueryBuilder<FacilityLayout, FacilityLayout, QSortBy> {
  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      sortByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      sortByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      sortByEmergencyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emergencyType', Sort.asc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      sortByEmergencyTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emergencyType', Sort.desc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      sortByFacilityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'facilityName', Sort.asc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      sortByFacilityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'facilityName', Sort.desc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      sortByMapImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapImagePath', Sort.asc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      sortByMapImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapImagePath', Sort.desc);
    });
  }
}

extension FacilityLayoutQuerySortThenBy
    on QueryBuilder<FacilityLayout, FacilityLayout, QSortThenBy> {
  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      thenByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      thenByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      thenByEmergencyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emergencyType', Sort.asc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      thenByEmergencyTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emergencyType', Sort.desc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      thenByFacilityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'facilityName', Sort.asc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      thenByFacilityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'facilityName', Sort.desc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      thenByMapImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapImagePath', Sort.asc);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterSortBy>
      thenByMapImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapImagePath', Sort.desc);
    });
  }
}

extension FacilityLayoutQueryWhereDistinct
    on QueryBuilder<FacilityLayout, FacilityLayout, QDistinct> {
  QueryBuilder<FacilityLayout, FacilityLayout, QDistinct>
      distinctByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateCreated');
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QDistinct>
      distinctByEmergencyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emergencyType');
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QDistinct>
      distinctByFacilityName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'facilityName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QDistinct>
      distinctByMapImagePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mapImagePath', caseSensitive: caseSensitive);
    });
  }
}

extension FacilityLayoutQueryProperty
    on QueryBuilder<FacilityLayout, FacilityLayout, QQueryProperty> {
  QueryBuilder<FacilityLayout, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FacilityLayout, DateTime?, QQueryOperations>
      dateCreatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateCreated');
    });
  }

  QueryBuilder<FacilityLayout, EmergencyType, QQueryOperations>
      emergencyTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emergencyType');
    });
  }

  QueryBuilder<FacilityLayout, String, QQueryOperations>
      facilityNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'facilityName');
    });
  }

  QueryBuilder<FacilityLayout, String, QQueryOperations>
      mapImagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mapImagePath');
    });
  }

  QueryBuilder<FacilityLayout, List<SpatialZone>, QQueryOperations>
      zonesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zones');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AssessmentQuestionSchema = Schema(
  name: r'AssessmentQuestion',
  id: -6235999064204113858,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.byte,
      enumMap: _AssessmentQuestioncategoryEnumValueMap,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.string,
    ),
    r'mediaPath': PropertySchema(
      id: 2,
      name: r'mediaPath',
      type: IsarType.string,
    ),
    r'note': PropertySchema(
      id: 3,
      name: r'note',
      type: IsarType.string,
    ),
    r'recommendationText': PropertySchema(
      id: 4,
      name: r'recommendationText',
      type: IsarType.string,
    ),
    r'selectedCompliance': PropertySchema(
      id: 5,
      name: r'selectedCompliance',
      type: IsarType.byte,
      enumMap: _AssessmentQuestionselectedComplianceEnumValueMap,
    ),
    r'text': PropertySchema(
      id: 6,
      name: r'text',
      type: IsarType.string,
    )
  },
  estimateSize: _assessmentQuestionEstimateSize,
  serialize: _assessmentQuestionSerialize,
  deserialize: _assessmentQuestionDeserialize,
  deserializeProp: _assessmentQuestionDeserializeProp,
);

int _assessmentQuestionEstimateSize(
  AssessmentQuestion object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.mediaPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.recommendationText.length * 3;
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _assessmentQuestionSerialize(
  AssessmentQuestion object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.category.index);
  writer.writeString(offsets[1], object.id);
  writer.writeString(offsets[2], object.mediaPath);
  writer.writeString(offsets[3], object.note);
  writer.writeString(offsets[4], object.recommendationText);
  writer.writeByte(offsets[5], object.selectedCompliance.index);
  writer.writeString(offsets[6], object.text);
}

AssessmentQuestion _assessmentQuestionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AssessmentQuestion(
    category: _AssessmentQuestioncategoryValueEnumMap[
            reader.readByteOrNull(offsets[0])] ??
        AssessmentCategory.infectionPreventionControl,
    id: reader.readStringOrNull(offsets[1]) ?? '',
    mediaPath: reader.readStringOrNull(offsets[2]),
    note: reader.readStringOrNull(offsets[3]),
    recommendationText: reader.readStringOrNull(offsets[4]) ?? '',
    selectedCompliance: _AssessmentQuestionselectedComplianceValueEnumMap[
            reader.readByteOrNull(offsets[5])] ??
        ComplianceLevel.pending,
    text: reader.readStringOrNull(offsets[6]) ?? '',
  );
  return object;
}

P _assessmentQuestionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_AssessmentQuestioncategoryValueEnumMap[
              reader.readByteOrNull(offset)] ??
          AssessmentCategory.infectionPreventionControl) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (_AssessmentQuestionselectedComplianceValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ComplianceLevel.pending) as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AssessmentQuestioncategoryEnumValueMap = {
  'infectionPreventionControl': 0,
  'wash': 1,
  'spatialLayout': 2,
  'logistics': 3,
};
const _AssessmentQuestioncategoryValueEnumMap = {
  0: AssessmentCategory.infectionPreventionControl,
  1: AssessmentCategory.wash,
  2: AssessmentCategory.spatialLayout,
  3: AssessmentCategory.logistics,
};
const _AssessmentQuestionselectedComplianceEnumValueMap = {
  'meetsTarget': 0,
  'partiallyMeets': 1,
  'doesNotMeet': 2,
  'notApplicable': 3,
  'pending': 4,
};
const _AssessmentQuestionselectedComplianceValueEnumMap = {
  0: ComplianceLevel.meetsTarget,
  1: ComplianceLevel.partiallyMeets,
  2: ComplianceLevel.doesNotMeet,
  3: ComplianceLevel.notApplicable,
  4: ComplianceLevel.pending,
};

extension AssessmentQuestionQueryFilter
    on QueryBuilder<AssessmentQuestion, AssessmentQuestion, QFilterCondition> {
  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      categoryEqualTo(AssessmentCategory value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      categoryGreaterThan(
    AssessmentCategory value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      categoryLessThan(
    AssessmentCategory value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      categoryBetween(
    AssessmentCategory lower,
    AssessmentCategory upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      mediaPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mediaPath',
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      mediaPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mediaPath',
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      mediaPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      mediaPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      mediaPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      mediaPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      mediaPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      mediaPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      mediaPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      mediaPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mediaPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      mediaPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaPath',
        value: '',
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      mediaPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mediaPath',
        value: '',
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      noteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      recommendationTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendationText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      recommendationTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recommendationText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      recommendationTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recommendationText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      recommendationTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recommendationText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      recommendationTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recommendationText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      recommendationTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recommendationText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      recommendationTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recommendationText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      recommendationTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recommendationText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      recommendationTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendationText',
        value: '',
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      recommendationTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recommendationText',
        value: '',
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      selectedComplianceEqualTo(ComplianceLevel value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedCompliance',
        value: value,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      selectedComplianceGreaterThan(
    ComplianceLevel value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedCompliance',
        value: value,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      selectedComplianceLessThan(
    ComplianceLevel value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedCompliance',
        value: value,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      selectedComplianceBetween(
    ComplianceLevel lower,
    ComplianceLevel upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedCompliance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      textMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<AssessmentQuestion, AssessmentQuestion, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }
}

extension AssessmentQuestionQueryObject
    on QueryBuilder<AssessmentQuestion, AssessmentQuestion, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MapCoordinatesSchema = Schema(
  name: r'MapCoordinates',
  id: -7792568739794666066,
  properties: {
    r'height': PropertySchema(
      id: 0,
      name: r'height',
      type: IsarType.double,
    ),
    r'left': PropertySchema(
      id: 1,
      name: r'left',
      type: IsarType.double,
    ),
    r'top': PropertySchema(
      id: 2,
      name: r'top',
      type: IsarType.double,
    ),
    r'width': PropertySchema(
      id: 3,
      name: r'width',
      type: IsarType.double,
    )
  },
  estimateSize: _mapCoordinatesEstimateSize,
  serialize: _mapCoordinatesSerialize,
  deserialize: _mapCoordinatesDeserialize,
  deserializeProp: _mapCoordinatesDeserializeProp,
);

int _mapCoordinatesEstimateSize(
  MapCoordinates object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _mapCoordinatesSerialize(
  MapCoordinates object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.height);
  writer.writeDouble(offsets[1], object.left);
  writer.writeDouble(offsets[2], object.top);
  writer.writeDouble(offsets[3], object.width);
}

MapCoordinates _mapCoordinatesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MapCoordinates(
    height: reader.readDoubleOrNull(offsets[0]) ?? 0.0,
    left: reader.readDoubleOrNull(offsets[1]) ?? 0.0,
    top: reader.readDoubleOrNull(offsets[2]) ?? 0.0,
    width: reader.readDoubleOrNull(offsets[3]) ?? 0.0,
  );
  return object;
}

P _mapCoordinatesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 1:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 2:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 3:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MapCoordinatesQueryFilter
    on QueryBuilder<MapCoordinates, MapCoordinates, QFilterCondition> {
  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      heightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      heightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      heightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      heightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      leftEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'left',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      leftGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'left',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      leftLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'left',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      leftBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'left',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      topEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'top',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      topGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'top',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      topLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'top',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      topBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'top',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      widthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      widthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      widthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MapCoordinates, MapCoordinates, QAfterFilterCondition>
      widthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'width',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension MapCoordinatesQueryObject
    on QueryBuilder<MapCoordinates, MapCoordinates, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SpatialZoneSchema = Schema(
  name: r'SpatialZone',
  id: -4054596744179729299,
  properties: {
    r'checklist': PropertySchema(
      id: 0,
      name: r'checklist',
      type: IsarType.objectList,
      target: r'AssessmentQuestion',
    ),
    r'coordinates': PropertySchema(
      id: 1,
      name: r'coordinates',
      type: IsarType.object,
      target: r'MapCoordinates',
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'touchArea': PropertySchema(
      id: 4,
      name: r'touchArea',
      type: IsarType.object,
      target: r'MapCoordinates',
    )
  },
  estimateSize: _spatialZoneEstimateSize,
  serialize: _spatialZoneSerialize,
  deserialize: _spatialZoneDeserialize,
  deserializeProp: _spatialZoneDeserializeProp,
);

int _spatialZoneEstimateSize(
  SpatialZone object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.checklist.length * 3;
  {
    final offsets = allOffsets[AssessmentQuestion]!;
    for (var i = 0; i < object.checklist.length; i++) {
      final value = object.checklist[i];
      bytesCount +=
          AssessmentQuestionSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 +
      MapCoordinatesSchema.estimateSize(
          object.coordinates, allOffsets[MapCoordinates]!, allOffsets);
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 +
      MapCoordinatesSchema.estimateSize(
          object.touchArea, allOffsets[MapCoordinates]!, allOffsets);
  return bytesCount;
}

void _spatialZoneSerialize(
  SpatialZone object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<AssessmentQuestion>(
    offsets[0],
    allOffsets,
    AssessmentQuestionSchema.serialize,
    object.checklist,
  );
  writer.writeObject<MapCoordinates>(
    offsets[1],
    allOffsets,
    MapCoordinatesSchema.serialize,
    object.coordinates,
  );
  writer.writeString(offsets[2], object.id);
  writer.writeString(offsets[3], object.name);
  writer.writeObject<MapCoordinates>(
    offsets[4],
    allOffsets,
    MapCoordinatesSchema.serialize,
    object.touchArea,
  );
}

SpatialZone _spatialZoneDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SpatialZone(
    checklist: reader.readObjectList<AssessmentQuestion>(
          offsets[0],
          AssessmentQuestionSchema.deserialize,
          allOffsets,
          AssessmentQuestion(),
        ) ??
        const [],
    coordinates: reader.readObjectOrNull<MapCoordinates>(
          offsets[1],
          MapCoordinatesSchema.deserialize,
          allOffsets,
        ) ??
        const MapCoordinates(),
    id: reader.readStringOrNull(offsets[2]) ?? '',
    name: reader.readStringOrNull(offsets[3]) ?? '',
    touchArea: reader.readObjectOrNull<MapCoordinates>(
          offsets[4],
          MapCoordinatesSchema.deserialize,
          allOffsets,
        ) ??
        const MapCoordinates(),
  );
  return object;
}

P _spatialZoneDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<AssessmentQuestion>(
            offset,
            AssessmentQuestionSchema.deserialize,
            allOffsets,
            AssessmentQuestion(),
          ) ??
          const []) as P;
    case 1:
      return (reader.readObjectOrNull<MapCoordinates>(
            offset,
            MapCoordinatesSchema.deserialize,
            allOffsets,
          ) ??
          const MapCoordinates()) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readObjectOrNull<MapCoordinates>(
            offset,
            MapCoordinatesSchema.deserialize,
            allOffsets,
          ) ??
          const MapCoordinates()) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SpatialZoneQueryFilter
    on QueryBuilder<SpatialZone, SpatialZone, QFilterCondition> {
  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition>
      checklistLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'checklist',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition>
      checklistIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'checklist',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition>
      checklistIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'checklist',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition>
      checklistLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'checklist',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition>
      checklistLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'checklist',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition>
      checklistLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'checklist',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension SpatialZoneQueryObject
    on QueryBuilder<SpatialZone, SpatialZone, QFilterCondition> {
  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition>
      checklistElement(FilterQuery<AssessmentQuestion> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'checklist');
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> coordinates(
      FilterQuery<MapCoordinates> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'coordinates');
    });
  }

  QueryBuilder<SpatialZone, SpatialZone, QAfterFilterCondition> touchArea(
      FilterQuery<MapCoordinates> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'touchArea');
    });
  }
}
