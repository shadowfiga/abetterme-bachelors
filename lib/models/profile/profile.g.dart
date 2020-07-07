// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    uid: json['uid'] as String,
    email: json['email'] as String,
    weight: (json['weight'] as num)?.toDouble(),
    units: _$enumDecodeNullable(_$UnitsEnumMap, json['units']),
    favoriteExercises:
        (json['favoriteExercises'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'weight': instance.weight,
      'units': _$UnitsEnumMap[instance.units],
      'favoriteExercises': instance.favoriteExercises,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$UnitsEnumMap = {
  Units.Metric: 'Metric',
  Units.Imperic: 'Imperic',
};
