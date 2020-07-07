// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  return Exercise(
    uid: json['uid'],
    name: json['name'],
    description: json['description'],
    imageUrl: json['imageUrl'] as String,
    aspects: (json['aspects'] as List)
        ?.map((a) => Aspect.fromJson(Map<String, dynamic>.from(a)))
        ?.toList(),
    mets: (json['mets'] as num)?.toDouble(),
    canQuickWorkout: json['canQuickWorkout'] as bool,
  )..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String);
}

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'uid': instance.uid,
      'imageUrl': instance.imageUrl,
      'aspects': instance.aspects.map((a) => a.toJson()).toList(),
      'mets': instance.mets,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'canQuickWorkout': instance.canQuickWorkout,
    };
