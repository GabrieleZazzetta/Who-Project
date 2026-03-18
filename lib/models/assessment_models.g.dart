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
    r'generalInfo': PropertySchema(
      id: 3,
      name: r'generalInfo',
      type: IsarType.object,
      target: r'GeneralFacilityInfo',
    ),
    r'mapImagePath': PropertySchema(
      id: 4,
      name: r'mapImagePath',
      type: IsarType.string,
    ),
    r'zones': PropertySchema(
      id: 5,
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
    r'GeneralFacilityInfo': GeneralFacilityInfoSchema,
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
  {
    final value = object.generalInfo;
    if (value != null) {
      bytesCount += 3 +
          GeneralFacilityInfoSchema.estimateSize(
              value, allOffsets[GeneralFacilityInfo]!, allOffsets);
    }
  }
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
  writer.writeObject<GeneralFacilityInfo>(
    offsets[3],
    allOffsets,
    GeneralFacilityInfoSchema.serialize,
    object.generalInfo,
  );
  writer.writeString(offsets[4], object.mapImagePath);
  writer.writeObjectList<SpatialZone>(
    offsets[5],
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
    mapImagePath: reader.readStringOrNull(offsets[4]) ?? '',
    zones: reader.readObjectList<SpatialZone>(
          offsets[5],
          SpatialZoneSchema.deserialize,
          allOffsets,
          SpatialZone(),
        ) ??
        const [],
  );
  object.generalInfo = reader.readObjectOrNull<GeneralFacilityInfo>(
    offsets[3],
    GeneralFacilityInfoSchema.deserialize,
    allOffsets,
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
      return (reader.readObjectOrNull<GeneralFacilityInfo>(
        offset,
        GeneralFacilityInfoSchema.deserialize,
        allOffsets,
      )) as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
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

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      generalInfoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'generalInfo',
      ));
    });
  }

  QueryBuilder<FacilityLayout, FacilityLayout, QAfterFilterCondition>
      generalInfoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'generalInfo',
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
      generalInfo(FilterQuery<GeneralFacilityInfo> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'generalInfo');
    });
  }

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

  QueryBuilder<FacilityLayout, GeneralFacilityInfo?, QQueryOperations>
      generalInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generalInfo');
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

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const GeneralFacilityInfoSchema = Schema(
  name: r'GeneralFacilityInfo',
  id: 6794265674606508288,
  properties: {
    r'assessedDisease': PropertySchema(
      id: 0,
      name: r'assessedDisease',
      type: IsarType.string,
    ),
    r'assessedFacilityType': PropertySchema(
      id: 1,
      name: r'assessedFacilityType',
      type: IsarType.string,
    ),
    r'assessmentDate': PropertySchema(
      id: 2,
      name: r'assessmentDate',
      type: IsarType.dateTime,
    ),
    r'assessorEmail': PropertySchema(
      id: 3,
      name: r'assessorEmail',
      type: IsarType.string,
    ),
    r'assessorName': PropertySchema(
      id: 4,
      name: r'assessorName',
      type: IsarType.string,
    ),
    r'assessorPhone': PropertySchema(
      id: 5,
      name: r'assessorPhone',
      type: IsarType.string,
    ),
    r'city': PropertySchema(
      id: 6,
      name: r'city',
      type: IsarType.string,
    ),
    r'country': PropertySchema(
      id: 7,
      name: r'country',
      type: IsarType.string,
    ),
    r'district': PropertySchema(
      id: 8,
      name: r'district',
      type: IsarType.string,
    ),
    r'existingHealthcareFacilityType': PropertySchema(
      id: 9,
      name: r'existingHealthcareFacilityType',
      type: IsarType.string,
    ),
    r'facilityAddressOrGps': PropertySchema(
      id: 10,
      name: r'facilityAddressOrGps',
      type: IsarType.string,
    ),
    r'facilityCode': PropertySchema(
      id: 11,
      name: r'facilityCode',
      type: IsarType.string,
    ),
    r'facilityDirectorEmail': PropertySchema(
      id: 12,
      name: r'facilityDirectorEmail',
      type: IsarType.string,
    ),
    r'facilityDirectorName': PropertySchema(
      id: 13,
      name: r'facilityDirectorName',
      type: IsarType.string,
    ),
    r'facilityDirectorPhone': PropertySchema(
      id: 14,
      name: r'facilityDirectorPhone',
      type: IsarType.string,
    ),
    r'facilityLocationRecord': PropertySchema(
      id: 15,
      name: r'facilityLocationRecord',
      type: IsarType.string,
    ),
    r'facilityName': PropertySchema(
      id: 16,
      name: r'facilityName',
      type: IsarType.string,
    ),
    r'has24hEmergency': PropertySchema(
      id: 17,
      name: r'has24hEmergency',
      type: IsarType.string,
    ),
    r'hasIcuOrHdu': PropertySchema(
      id: 18,
      name: r'hasIcuOrHdu',
      type: IsarType.string,
    ),
    r'icuBeds': PropertySchema(
      id: 19,
      name: r'icuBeds',
      type: IsarType.long,
    ),
    r'inpatientBeds': PropertySchema(
      id: 20,
      name: r'inpatientBeds',
      type: IsarType.long,
    ),
    r'managingAuthority': PropertySchema(
      id: 21,
      name: r'managingAuthority',
      type: IsarType.string,
    ),
    r'offersInpatient': PropertySchema(
      id: 22,
      name: r'offersInpatient',
      type: IsarType.string,
    ),
    r'offersOutpatient': PropertySchema(
      id: 23,
      name: r'offersOutpatient',
      type: IsarType.string,
    ),
    r'region': PropertySchema(
      id: 24,
      name: r'region',
      type: IsarType.string,
    ),
    r'respondentName': PropertySchema(
      id: 25,
      name: r'respondentName',
      type: IsarType.string,
    ),
    r'respondentPosition': PropertySchema(
      id: 26,
      name: r'respondentPosition',
      type: IsarType.string,
    ),
    r'structureType': PropertySchema(
      id: 27,
      name: r'structureType',
      type: IsarType.string,
    )
  },
  estimateSize: _generalFacilityInfoEstimateSize,
  serialize: _generalFacilityInfoSerialize,
  deserialize: _generalFacilityInfoDeserialize,
  deserializeProp: _generalFacilityInfoDeserializeProp,
);

int _generalFacilityInfoEstimateSize(
  GeneralFacilityInfo object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.assessedDisease;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.assessedFacilityType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.assessorEmail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.assessorName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.assessorPhone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.city;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.country;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.district;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.existingHealthcareFacilityType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.facilityAddressOrGps;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.facilityCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.facilityDirectorEmail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.facilityDirectorName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.facilityDirectorPhone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.facilityLocationRecord;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.facilityName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.has24hEmergency;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.hasIcuOrHdu;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.managingAuthority;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.offersInpatient;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.offersOutpatient;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.region;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.respondentName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.respondentPosition;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.structureType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _generalFacilityInfoSerialize(
  GeneralFacilityInfo object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assessedDisease);
  writer.writeString(offsets[1], object.assessedFacilityType);
  writer.writeDateTime(offsets[2], object.assessmentDate);
  writer.writeString(offsets[3], object.assessorEmail);
  writer.writeString(offsets[4], object.assessorName);
  writer.writeString(offsets[5], object.assessorPhone);
  writer.writeString(offsets[6], object.city);
  writer.writeString(offsets[7], object.country);
  writer.writeString(offsets[8], object.district);
  writer.writeString(offsets[9], object.existingHealthcareFacilityType);
  writer.writeString(offsets[10], object.facilityAddressOrGps);
  writer.writeString(offsets[11], object.facilityCode);
  writer.writeString(offsets[12], object.facilityDirectorEmail);
  writer.writeString(offsets[13], object.facilityDirectorName);
  writer.writeString(offsets[14], object.facilityDirectorPhone);
  writer.writeString(offsets[15], object.facilityLocationRecord);
  writer.writeString(offsets[16], object.facilityName);
  writer.writeString(offsets[17], object.has24hEmergency);
  writer.writeString(offsets[18], object.hasIcuOrHdu);
  writer.writeLong(offsets[19], object.icuBeds);
  writer.writeLong(offsets[20], object.inpatientBeds);
  writer.writeString(offsets[21], object.managingAuthority);
  writer.writeString(offsets[22], object.offersInpatient);
  writer.writeString(offsets[23], object.offersOutpatient);
  writer.writeString(offsets[24], object.region);
  writer.writeString(offsets[25], object.respondentName);
  writer.writeString(offsets[26], object.respondentPosition);
  writer.writeString(offsets[27], object.structureType);
}

GeneralFacilityInfo _generalFacilityInfoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GeneralFacilityInfo();
  object.assessedDisease = reader.readStringOrNull(offsets[0]);
  object.assessedFacilityType = reader.readStringOrNull(offsets[1]);
  object.assessmentDate = reader.readDateTimeOrNull(offsets[2]);
  object.assessorEmail = reader.readStringOrNull(offsets[3]);
  object.assessorName = reader.readStringOrNull(offsets[4]);
  object.assessorPhone = reader.readStringOrNull(offsets[5]);
  object.city = reader.readStringOrNull(offsets[6]);
  object.country = reader.readStringOrNull(offsets[7]);
  object.district = reader.readStringOrNull(offsets[8]);
  object.existingHealthcareFacilityType = reader.readStringOrNull(offsets[9]);
  object.facilityAddressOrGps = reader.readStringOrNull(offsets[10]);
  object.facilityCode = reader.readStringOrNull(offsets[11]);
  object.facilityDirectorEmail = reader.readStringOrNull(offsets[12]);
  object.facilityDirectorName = reader.readStringOrNull(offsets[13]);
  object.facilityDirectorPhone = reader.readStringOrNull(offsets[14]);
  object.facilityLocationRecord = reader.readStringOrNull(offsets[15]);
  object.facilityName = reader.readStringOrNull(offsets[16]);
  object.has24hEmergency = reader.readStringOrNull(offsets[17]);
  object.hasIcuOrHdu = reader.readStringOrNull(offsets[18]);
  object.icuBeds = reader.readLongOrNull(offsets[19]);
  object.inpatientBeds = reader.readLongOrNull(offsets[20]);
  object.managingAuthority = reader.readStringOrNull(offsets[21]);
  object.offersInpatient = reader.readStringOrNull(offsets[22]);
  object.offersOutpatient = reader.readStringOrNull(offsets[23]);
  object.region = reader.readStringOrNull(offsets[24]);
  object.respondentName = reader.readStringOrNull(offsets[25]);
  object.respondentPosition = reader.readStringOrNull(offsets[26]);
  object.structureType = reader.readStringOrNull(offsets[27]);
  return object;
}

P _generalFacilityInfoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readLongOrNull(offset)) as P;
    case 20:
      return (reader.readLongOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension GeneralFacilityInfoQueryFilter on QueryBuilder<GeneralFacilityInfo,
    GeneralFacilityInfo, QFilterCondition> {
  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedDiseaseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'assessedDisease',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedDiseaseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'assessedDisease',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedDiseaseEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assessedDisease',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedDiseaseGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assessedDisease',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedDiseaseLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assessedDisease',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedDiseaseBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assessedDisease',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedDiseaseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assessedDisease',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedDiseaseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assessedDisease',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedDiseaseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assessedDisease',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedDiseaseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assessedDisease',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedDiseaseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assessedDisease',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedDiseaseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assessedDisease',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedFacilityTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'assessedFacilityType',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedFacilityTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'assessedFacilityType',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedFacilityTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assessedFacilityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedFacilityTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assessedFacilityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedFacilityTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assessedFacilityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedFacilityTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assessedFacilityType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedFacilityTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assessedFacilityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedFacilityTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assessedFacilityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedFacilityTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assessedFacilityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedFacilityTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assessedFacilityType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedFacilityTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assessedFacilityType',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessedFacilityTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assessedFacilityType',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessmentDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'assessmentDate',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessmentDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'assessmentDate',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessmentDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assessmentDate',
        value: value,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessmentDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assessmentDate',
        value: value,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessmentDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assessmentDate',
        value: value,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessmentDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assessmentDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorEmailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'assessorEmail',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorEmailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'assessorEmail',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorEmailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assessorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorEmailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assessorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorEmailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assessorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorEmailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assessorEmail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorEmailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assessorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorEmailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assessorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorEmailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assessorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorEmailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assessorEmail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assessorEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assessorEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'assessorName',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'assessorName',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assessorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assessorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assessorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assessorName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assessorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assessorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assessorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assessorName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assessorName',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assessorName',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorPhoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'assessorPhone',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorPhoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'assessorPhone',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorPhoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assessorPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorPhoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assessorPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorPhoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assessorPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorPhoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assessorPhone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorPhoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assessorPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorPhoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assessorPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorPhoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assessorPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorPhoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assessorPhone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assessorPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      assessorPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assessorPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      cityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'city',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      cityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'city',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      cityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      cityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      cityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      cityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'city',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      cityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      cityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      cityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      cityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      countryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'country',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      countryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'country',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      countryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      countryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      countryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      countryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'country',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      countryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      countryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      countryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      countryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'country',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      countryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'country',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      countryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'country',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      districtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'district',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      districtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'district',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      districtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      districtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      districtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      districtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'district',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      districtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      districtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      districtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      districtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'district',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      districtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'district',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      districtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'district',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      existingHealthcareFacilityTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'existingHealthcareFacilityType',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      existingHealthcareFacilityTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'existingHealthcareFacilityType',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      existingHealthcareFacilityTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'existingHealthcareFacilityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      existingHealthcareFacilityTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'existingHealthcareFacilityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      existingHealthcareFacilityTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'existingHealthcareFacilityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      existingHealthcareFacilityTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'existingHealthcareFacilityType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      existingHealthcareFacilityTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'existingHealthcareFacilityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      existingHealthcareFacilityTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'existingHealthcareFacilityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      existingHealthcareFacilityTypeContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'existingHealthcareFacilityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      existingHealthcareFacilityTypeMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'existingHealthcareFacilityType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      existingHealthcareFacilityTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'existingHealthcareFacilityType',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      existingHealthcareFacilityTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'existingHealthcareFacilityType',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityAddressOrGpsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'facilityAddressOrGps',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityAddressOrGpsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'facilityAddressOrGps',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityAddressOrGpsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityAddressOrGps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityAddressOrGpsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'facilityAddressOrGps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityAddressOrGpsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'facilityAddressOrGps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityAddressOrGpsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'facilityAddressOrGps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityAddressOrGpsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'facilityAddressOrGps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityAddressOrGpsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'facilityAddressOrGps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityAddressOrGpsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'facilityAddressOrGps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityAddressOrGpsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'facilityAddressOrGps',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityAddressOrGpsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityAddressOrGps',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityAddressOrGpsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'facilityAddressOrGps',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'facilityCode',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'facilityCode',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'facilityCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'facilityCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'facilityCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'facilityCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'facilityCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'facilityCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'facilityCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityCode',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'facilityCode',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorEmailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'facilityDirectorEmail',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorEmailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'facilityDirectorEmail',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorEmailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityDirectorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorEmailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'facilityDirectorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorEmailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'facilityDirectorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorEmailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'facilityDirectorEmail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorEmailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'facilityDirectorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorEmailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'facilityDirectorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorEmailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'facilityDirectorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorEmailMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'facilityDirectorEmail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityDirectorEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'facilityDirectorEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'facilityDirectorName',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'facilityDirectorName',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityDirectorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'facilityDirectorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'facilityDirectorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'facilityDirectorName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'facilityDirectorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'facilityDirectorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'facilityDirectorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'facilityDirectorName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityDirectorName',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'facilityDirectorName',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorPhoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'facilityDirectorPhone',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorPhoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'facilityDirectorPhone',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorPhoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityDirectorPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorPhoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'facilityDirectorPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorPhoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'facilityDirectorPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorPhoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'facilityDirectorPhone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorPhoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'facilityDirectorPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorPhoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'facilityDirectorPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorPhoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'facilityDirectorPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorPhoneMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'facilityDirectorPhone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityDirectorPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityDirectorPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'facilityDirectorPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityLocationRecordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'facilityLocationRecord',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityLocationRecordIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'facilityLocationRecord',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityLocationRecordEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityLocationRecord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityLocationRecordGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'facilityLocationRecord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityLocationRecordLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'facilityLocationRecord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityLocationRecordBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'facilityLocationRecord',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityLocationRecordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'facilityLocationRecord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityLocationRecordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'facilityLocationRecord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityLocationRecordContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'facilityLocationRecord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityLocationRecordMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'facilityLocationRecord',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityLocationRecordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityLocationRecord',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityLocationRecordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'facilityLocationRecord',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'facilityName',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'facilityName',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityNameEqualTo(
    String? value, {
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

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityNameGreaterThan(
    String? value, {
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

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityNameLessThan(
    String? value, {
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

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityNameBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
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

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
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

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'facilityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'facilityName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityName',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      facilityNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'facilityName',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      has24hEmergencyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'has24hEmergency',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      has24hEmergencyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'has24hEmergency',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      has24hEmergencyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'has24hEmergency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      has24hEmergencyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'has24hEmergency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      has24hEmergencyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'has24hEmergency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      has24hEmergencyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'has24hEmergency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      has24hEmergencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'has24hEmergency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      has24hEmergencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'has24hEmergency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      has24hEmergencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'has24hEmergency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      has24hEmergencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'has24hEmergency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      has24hEmergencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'has24hEmergency',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      has24hEmergencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'has24hEmergency',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      hasIcuOrHduIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hasIcuOrHdu',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      hasIcuOrHduIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hasIcuOrHdu',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      hasIcuOrHduEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasIcuOrHdu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      hasIcuOrHduGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hasIcuOrHdu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      hasIcuOrHduLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hasIcuOrHdu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      hasIcuOrHduBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hasIcuOrHdu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      hasIcuOrHduStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hasIcuOrHdu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      hasIcuOrHduEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hasIcuOrHdu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      hasIcuOrHduContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hasIcuOrHdu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      hasIcuOrHduMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hasIcuOrHdu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      hasIcuOrHduIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasIcuOrHdu',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      hasIcuOrHduIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hasIcuOrHdu',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      icuBedsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'icuBeds',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      icuBedsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'icuBeds',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      icuBedsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icuBeds',
        value: value,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      icuBedsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'icuBeds',
        value: value,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      icuBedsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'icuBeds',
        value: value,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      icuBedsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'icuBeds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      inpatientBedsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'inpatientBeds',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      inpatientBedsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'inpatientBeds',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      inpatientBedsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inpatientBeds',
        value: value,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      inpatientBedsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'inpatientBeds',
        value: value,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      inpatientBedsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'inpatientBeds',
        value: value,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      inpatientBedsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'inpatientBeds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      managingAuthorityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'managingAuthority',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      managingAuthorityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'managingAuthority',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      managingAuthorityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'managingAuthority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      managingAuthorityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'managingAuthority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      managingAuthorityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'managingAuthority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      managingAuthorityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'managingAuthority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      managingAuthorityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'managingAuthority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      managingAuthorityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'managingAuthority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      managingAuthorityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'managingAuthority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      managingAuthorityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'managingAuthority',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      managingAuthorityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'managingAuthority',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      managingAuthorityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'managingAuthority',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersInpatientIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'offersInpatient',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersInpatientIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'offersInpatient',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersInpatientEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offersInpatient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersInpatientGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'offersInpatient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersInpatientLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'offersInpatient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersInpatientBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'offersInpatient',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersInpatientStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'offersInpatient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersInpatientEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'offersInpatient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersInpatientContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'offersInpatient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersInpatientMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'offersInpatient',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersInpatientIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offersInpatient',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersInpatientIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'offersInpatient',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersOutpatientIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'offersOutpatient',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersOutpatientIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'offersOutpatient',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersOutpatientEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offersOutpatient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersOutpatientGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'offersOutpatient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersOutpatientLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'offersOutpatient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersOutpatientBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'offersOutpatient',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersOutpatientStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'offersOutpatient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersOutpatientEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'offersOutpatient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersOutpatientContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'offersOutpatient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersOutpatientMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'offersOutpatient',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersOutpatientIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offersOutpatient',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      offersOutpatientIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'offersOutpatient',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      regionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'region',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      regionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'region',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      regionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      regionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      regionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      regionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'region',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      regionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      regionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      regionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      regionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'region',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      regionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'region',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      regionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'region',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'respondentName',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'respondentName',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'respondentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'respondentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'respondentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'respondentName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'respondentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'respondentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'respondentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'respondentName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'respondentName',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'respondentName',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentPositionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'respondentPosition',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentPositionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'respondentPosition',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentPositionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'respondentPosition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentPositionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'respondentPosition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentPositionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'respondentPosition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentPositionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'respondentPosition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentPositionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'respondentPosition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentPositionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'respondentPosition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentPositionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'respondentPosition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentPositionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'respondentPosition',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentPositionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'respondentPosition',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      respondentPositionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'respondentPosition',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      structureTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'structureType',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      structureTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'structureType',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      structureTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'structureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      structureTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'structureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      structureTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'structureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      structureTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'structureType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      structureTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'structureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      structureTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'structureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      structureTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'structureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      structureTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'structureType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      structureTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'structureType',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneralFacilityInfo, GeneralFacilityInfo, QAfterFilterCondition>
      structureTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'structureType',
        value: '',
      ));
    });
  }
}

extension GeneralFacilityInfoQueryObject on QueryBuilder<GeneralFacilityInfo,
    GeneralFacilityInfo, QFilterCondition> {}
