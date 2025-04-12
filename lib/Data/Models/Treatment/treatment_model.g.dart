// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTreatmentCollection on Isar {
  IsarCollection<Treatment> get treatments => this.collection();
}

const TreatmentSchema = CollectionSchema(
  name: r'Treatment',
  id: -2494921379818073871,
  properties: {
    r'availableAppointments': PropertySchema(
      id: 0,
      name: r'availableAppointments',
      type: IsarType.long,
    ),
    r'availableDates': PropertySchema(
      id: 1,
      name: r'availableDates',
      type: IsarType.dateTimeList,
    ),
    r'dateRanges': PropertySchema(
      id: 2,
      name: r'dateRanges',
      type: IsarType.objectList,
      target: r'DateRange',
    ),
    r'firstDateToSchedule': PropertySchema(
      id: 3,
      name: r'firstDateToSchedule',
      type: IsarType.dateTime,
    ),
    r'lastDateToSchedule': PropertySchema(
      id: 4,
      name: r'lastDateToSchedule',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'orderId': PropertySchema(
      id: 6,
      name: r'orderId',
      type: IsarType.long,
    ),
    r'productId': PropertySchema(
      id: 7,
      name: r'productId',
      type: IsarType.long,
    ),
    r'scheduledAppointments': PropertySchema(
      id: 8,
      name: r'scheduledAppointments',
      type: IsarType.objectList,
      target: r'Appointment',
    )
  },
  estimateSize: _treatmentEstimateSize,
  serialize: _treatmentSerialize,
  deserialize: _treatmentDeserialize,
  deserializeProp: _treatmentDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'user': LinkSchema(
      id: 183272576202861209,
      name: r'user',
      target: r'User',
      single: true,
      linkName: r'treatments',
    )
  },
  embeddedSchemas: {
    r'Appointment': AppointmentSchema,
    r'DateRange': DateRangeSchema
  },
  getId: _treatmentGetId,
  getLinks: _treatmentGetLinks,
  attach: _treatmentAttach,
  version: '3.1.0+1',
);

int _treatmentEstimateSize(
  Treatment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.availableDates;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final list = object.dateRanges;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[DateRange]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              DateRangeSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.scheduledAppointments;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Appointment]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              AppointmentSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  return bytesCount;
}

void _treatmentSerialize(
  Treatment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.availableAppointments);
  writer.writeDateTimeList(offsets[1], object.availableDates);
  writer.writeObjectList<DateRange>(
    offsets[2],
    allOffsets,
    DateRangeSchema.serialize,
    object.dateRanges,
  );
  writer.writeDateTime(offsets[3], object.firstDateToSchedule);
  writer.writeDateTime(offsets[4], object.lastDateToSchedule);
  writer.writeString(offsets[5], object.name);
  writer.writeLong(offsets[6], object.orderId);
  writer.writeLong(offsets[7], object.productId);
  writer.writeObjectList<Appointment>(
    offsets[8],
    allOffsets,
    AppointmentSchema.serialize,
    object.scheduledAppointments,
  );
}

Treatment _treatmentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Treatment();
  object.availableAppointments = reader.readLongOrNull(offsets[0]);
  object.availableDates = reader.readDateTimeList(offsets[1]);
  object.dateRanges = reader.readObjectList<DateRange>(
    offsets[2],
    DateRangeSchema.deserialize,
    allOffsets,
    DateRange(),
  );
  object.firstDateToSchedule = reader.readDateTimeOrNull(offsets[3]);
  object.id = id;
  object.lastDateToSchedule = reader.readDateTimeOrNull(offsets[4]);
  object.name = reader.readStringOrNull(offsets[5]);
  object.orderId = reader.readLongOrNull(offsets[6]);
  object.productId = reader.readLongOrNull(offsets[7]);
  object.scheduledAppointments = reader.readObjectList<Appointment>(
    offsets[8],
    AppointmentSchema.deserialize,
    allOffsets,
    Appointment(),
  );
  return object;
}

P _treatmentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeList(offset)) as P;
    case 2:
      return (reader.readObjectList<DateRange>(
        offset,
        DateRangeSchema.deserialize,
        allOffsets,
        DateRange(),
      )) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readObjectList<Appointment>(
        offset,
        AppointmentSchema.deserialize,
        allOffsets,
        Appointment(),
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _treatmentGetId(Treatment object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _treatmentGetLinks(Treatment object) {
  return [object.user];
}

void _treatmentAttach(IsarCollection<dynamic> col, Id id, Treatment object) {
  object.id = id;
  object.user.attach(col, col.isar.collection<User>(), r'user', id);
}

extension TreatmentQueryWhereSort
    on QueryBuilder<Treatment, Treatment, QWhere> {
  QueryBuilder<Treatment, Treatment, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TreatmentQueryWhere
    on QueryBuilder<Treatment, Treatment, QWhereClause> {
  QueryBuilder<Treatment, Treatment, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Treatment, Treatment, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterWhereClause> idBetween(
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

extension TreatmentQueryFilter
    on QueryBuilder<Treatment, Treatment, QFilterCondition> {
  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableAppointmentsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'availableAppointments',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableAppointmentsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'availableAppointments',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableAppointmentsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'availableAppointments',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableAppointmentsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'availableAppointments',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableAppointmentsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'availableAppointments',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableAppointmentsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'availableAppointments',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableDatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'availableDates',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableDatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'availableDates',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableDatesElementEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'availableDates',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableDatesElementGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'availableDates',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableDatesElementLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'availableDates',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableDatesElementBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'availableDates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableDatesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'availableDates',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableDatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'availableDates',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableDatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'availableDates',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableDatesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'availableDates',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableDatesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'availableDates',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      availableDatesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'availableDates',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> dateRangesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateRanges',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      dateRangesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateRanges',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      dateRangesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dateRanges',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      dateRangesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dateRanges',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      dateRangesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dateRanges',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      dateRangesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dateRanges',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      dateRangesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dateRanges',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      dateRangesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dateRanges',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      firstDateToScheduleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firstDateToSchedule',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      firstDateToScheduleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'firstDateToSchedule',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      firstDateToScheduleEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstDateToSchedule',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      firstDateToScheduleGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstDateToSchedule',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      firstDateToScheduleLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstDateToSchedule',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      firstDateToScheduleBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstDateToSchedule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      lastDateToScheduleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastDateToSchedule',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      lastDateToScheduleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastDateToSchedule',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      lastDateToScheduleEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDateToSchedule',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      lastDateToScheduleGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDateToSchedule',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      lastDateToScheduleLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDateToSchedule',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      lastDateToScheduleBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDateToSchedule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameEqualTo(
    String? value, {
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

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameGreaterThan(
    String? value, {
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

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameLessThan(
    String? value, {
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

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameContains(
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

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> orderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'orderId',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> orderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'orderId',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> orderIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderId',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> orderIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderId',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> orderIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderId',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> orderIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> productIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'productId',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      productIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'productId',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> productIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      productIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> productIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> productIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scheduledAppointments',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scheduledAppointments',
      ));
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledAppointments',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledAppointments',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledAppointments',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledAppointments',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledAppointments',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledAppointments',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension TreatmentQueryObject
    on QueryBuilder<Treatment, Treatment, QFilterCondition> {
  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> dateRangesElement(
      FilterQuery<DateRange> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'dateRanges');
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition>
      scheduledAppointmentsElement(FilterQuery<Appointment> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'scheduledAppointments');
    });
  }
}

extension TreatmentQueryLinks
    on QueryBuilder<Treatment, Treatment, QFilterCondition> {
  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> user(
      FilterQuery<User> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'user');
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterFilterCondition> userIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'user', 0, true, 0, true);
    });
  }
}

extension TreatmentQuerySortBy on QueryBuilder<Treatment, Treatment, QSortBy> {
  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      sortByAvailableAppointments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableAppointments', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      sortByAvailableAppointmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableAppointments', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByFirstDateToSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDateToSchedule', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      sortByFirstDateToScheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDateToSchedule', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByLastDateToSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDateToSchedule', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      sortByLastDateToScheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDateToSchedule', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }
}

extension TreatmentQuerySortThenBy
    on QueryBuilder<Treatment, Treatment, QSortThenBy> {
  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      thenByAvailableAppointments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableAppointments', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      thenByAvailableAppointmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'availableAppointments', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByFirstDateToSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDateToSchedule', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      thenByFirstDateToScheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDateToSchedule', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByLastDateToSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDateToSchedule', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy>
      thenByLastDateToScheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDateToSchedule', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<Treatment, Treatment, QAfterSortBy> thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }
}

extension TreatmentQueryWhereDistinct
    on QueryBuilder<Treatment, Treatment, QDistinct> {
  QueryBuilder<Treatment, Treatment, QDistinct>
      distinctByAvailableAppointments() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'availableAppointments');
    });
  }

  QueryBuilder<Treatment, Treatment, QDistinct> distinctByAvailableDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'availableDates');
    });
  }

  QueryBuilder<Treatment, Treatment, QDistinct>
      distinctByFirstDateToSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstDateToSchedule');
    });
  }

  QueryBuilder<Treatment, Treatment, QDistinct> distinctByLastDateToSchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDateToSchedule');
    });
  }

  QueryBuilder<Treatment, Treatment, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Treatment, Treatment, QDistinct> distinctByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderId');
    });
  }

  QueryBuilder<Treatment, Treatment, QDistinct> distinctByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId');
    });
  }
}

extension TreatmentQueryProperty
    on QueryBuilder<Treatment, Treatment, QQueryProperty> {
  QueryBuilder<Treatment, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Treatment, int?, QQueryOperations>
      availableAppointmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'availableAppointments');
    });
  }

  QueryBuilder<Treatment, List<DateTime>?, QQueryOperations>
      availableDatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'availableDates');
    });
  }

  QueryBuilder<Treatment, List<DateRange>?, QQueryOperations>
      dateRangesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateRanges');
    });
  }

  QueryBuilder<Treatment, DateTime?, QQueryOperations>
      firstDateToScheduleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstDateToSchedule');
    });
  }

  QueryBuilder<Treatment, DateTime?, QQueryOperations>
      lastDateToScheduleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDateToSchedule');
    });
  }

  QueryBuilder<Treatment, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Treatment, int?, QQueryOperations> orderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderId');
    });
  }

  QueryBuilder<Treatment, int?, QQueryOperations> productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<Treatment, List<Appointment>?, QQueryOperations>
      scheduledAppointmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledAppointments');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AppointmentSchema = Schema(
  name: r'Appointment',
  id: 2680450406379222733,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.string,
    ),
    r'dateTime': PropertySchema(
      id: 1,
      name: r'dateTime',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.long,
    ),
    r'jiffyDate': PropertySchema(
      id: 3,
      name: r'jiffyDate',
      type: IsarType.string,
    ),
    r'jiffyDateTime': PropertySchema(
      id: 4,
      name: r'jiffyDateTime',
      type: IsarType.string,
    ),
    r'jiffyTime': PropertySchema(
      id: 5,
      name: r'jiffyTime',
      type: IsarType.string,
    ),
    r'time': PropertySchema(
      id: 6,
      name: r'time',
      type: IsarType.string,
    )
  },
  estimateSize: _appointmentEstimateSize,
  serialize: _appointmentSerialize,
  deserialize: _appointmentDeserialize,
  deserializeProp: _appointmentDeserializeProp,
);

int _appointmentEstimateSize(
  Appointment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.date;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.jiffyDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.jiffyDateTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.jiffyTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.time;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appointmentSerialize(
  Appointment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.date);
  writer.writeDateTime(offsets[1], object.dateTime);
  writer.writeLong(offsets[2], object.id);
  writer.writeString(offsets[3], object.jiffyDate);
  writer.writeString(offsets[4], object.jiffyDateTime);
  writer.writeString(offsets[5], object.jiffyTime);
  writer.writeString(offsets[6], object.time);
}

Appointment _appointmentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Appointment(
    date: reader.readStringOrNull(offsets[0]),
    id: reader.readLongOrNull(offsets[2]),
    time: reader.readStringOrNull(offsets[6]),
  );
  return object;
}

P _appointmentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AppointmentQueryFilter
    on QueryBuilder<Appointment, Appointment, QFilterCondition> {
  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> dateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> dateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> dateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> dateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> dateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> dateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      dateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateTime',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      dateTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateTime',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> dateTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      dateTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      dateTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> dateTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> idEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> idGreaterThan(
    int? value, {
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

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> idLessThan(
    int? value, {
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

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jiffyDate',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jiffyDate',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jiffyDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jiffyDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jiffyDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jiffyDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'jiffyDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'jiffyDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jiffyDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jiffyDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jiffyDate',
        value: '',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jiffyDate',
        value: '',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jiffyDateTime',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jiffyDateTime',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jiffyDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jiffyDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jiffyDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jiffyDateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'jiffyDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'jiffyDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jiffyDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jiffyDateTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jiffyDateTime',
        value: '',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyDateTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jiffyDateTime',
        value: '',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jiffyTime',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jiffyTime',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jiffyTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jiffyTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jiffyTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jiffyTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'jiffyTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'jiffyTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jiffyTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jiffyTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jiffyTime',
        value: '',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      jiffyTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jiffyTime',
        value: '',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> timeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'time',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      timeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'time',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> timeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'time',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> timeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'time',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> timeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'time',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> timeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'time',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> timeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'time',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> timeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'time',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> timeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'time',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> timeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'time',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition> timeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'time',
        value: '',
      ));
    });
  }

  QueryBuilder<Appointment, Appointment, QAfterFilterCondition>
      timeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'time',
        value: '',
      ));
    });
  }
}

extension AppointmentQueryObject
    on QueryBuilder<Appointment, Appointment, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DateRangeSchema = Schema(
  name: r'DateRange',
  id: 5614220809524369567,
  properties: {
    r'availableSchedules': PropertySchema(
      id: 0,
      name: r'availableSchedules',
      type: IsarType.long,
    ),
    r'endDate': PropertySchema(
      id: 1,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'initialDate': PropertySchema(
      id: 2,
      name: r'initialDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _dateRangeEstimateSize,
  serialize: _dateRangeSerialize,
  deserialize: _dateRangeDeserialize,
  deserializeProp: _dateRangeDeserializeProp,
);

int _dateRangeEstimateSize(
  DateRange object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _dateRangeSerialize(
  DateRange object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.availableSchedules);
  writer.writeDateTime(offsets[1], object.endDate);
  writer.writeDateTime(offsets[2], object.initialDate);
}

DateRange _dateRangeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DateRange(
    availableSchedules: reader.readLongOrNull(offsets[0]),
    endDate: reader.readDateTimeOrNull(offsets[1]),
    initialDate: reader.readDateTimeOrNull(offsets[2]),
  );
  return object;
}

P _dateRangeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DateRangeQueryFilter
    on QueryBuilder<DateRange, DateRange, QFilterCondition> {
  QueryBuilder<DateRange, DateRange, QAfterFilterCondition>
      availableSchedulesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'availableSchedules',
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition>
      availableSchedulesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'availableSchedules',
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition>
      availableSchedulesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'availableSchedules',
        value: value,
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition>
      availableSchedulesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'availableSchedules',
        value: value,
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition>
      availableSchedulesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'availableSchedules',
        value: value,
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition>
      availableSchedulesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'availableSchedules',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition> endDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition> endDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition> endDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition> endDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition> endDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition> endDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition>
      initialDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'initialDate',
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition>
      initialDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'initialDate',
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition> initialDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initialDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition>
      initialDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'initialDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition> initialDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'initialDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DateRange, DateRange, QAfterFilterCondition> initialDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'initialDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DateRangeQueryObject
    on QueryBuilder<DateRange, DateRange, QFilterCondition> {}
