part of 'standard_workout_entry_exercise.dart';

StandardWorkoutEntryExercise _$StandardWorkoutEntryExerciseFromJson(
    Map<String, dynamic> json) {
  return StandardWorkoutEntryExercise(
      (json['sets'] as num).toInt(),
      (json['uid'] as String),
      (json['name'] as String),
      (json['mets'] as num).toDouble());
}

Map<String, dynamic> _$StandardWorkoutEntryExerciseToJson(
        StandardWorkoutEntryExercise instance) =>
    <String, dynamic>{
      'sets': instance.sets,
      'uid': instance.uid,
      'name': instance.name,
      'mets': instance.mets,
    };
