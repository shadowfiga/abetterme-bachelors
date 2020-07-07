// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workout _$WorkoutFromJson(Map<String, dynamic> json) {
  return Workout(
    name: json['name'],
    uid: json['uid'],
    userId: json['userId'] as String,
    userEmail: json['userEmail'] as String,
    userDisplayName: json['userDisplayName'] as String,
    exercises: (json['exercises'] as List)
        ?.map((e) => e == null
            ? null
            : ExerciseDescription.fromJson(Map<String, dynamic>.from(e)))
        ?.toList(),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
  );
}

Map<String, dynamic> _$WorkoutToJson(Workout instance) => <String, dynamic>{
      'name': instance.name,
      'uid': instance.uid,
      'exercises': instance.exercises,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'userEmail': instance.userEmail,
      'userDisplayName': instance.userDisplayName,
      'userId': instance.userId,
    };
