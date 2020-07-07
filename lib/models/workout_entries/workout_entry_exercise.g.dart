part of 'workout_entry_exercise.dart';

StandardWorkoutEntryExercise _$WorkoutEntryExerciseFromJson(
    Map<String, dynamic> json) {
  return StandardWorkoutEntryExercise(
    json['uid'] as String,
    json['name'] as String,
    (json['mets'] as num).toDouble(),
    (json['sets'] as num).toInt(),
  );
}

Map<String, dynamic> _$WorkoutEntryExerciseToJson(
        StandardWorkoutEntryExercise instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'mets': instance.mets,
      'sets': instance.sets,
    };
