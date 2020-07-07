// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_description.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseDescription _$ExerciseDescriptionFromJson(Map<String, dynamic> json) {
  return ExerciseDescription(
    exerciseId: json['exerciseId'] as String,
    exerciseName: json['exerciseName'] as String,
    mets: (json['mets'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ExerciseDescriptionToJson(
        ExerciseDescription instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'exerciseName': instance.exerciseName,
      'mets': instance.mets
    };
