part of 'workout_entry_exercise_base.dart';

WorkoutEntryExerciseBase _$WorkoutEntryExerciseBaseFromJson(
    Map<String, dynamic> json) {
  return WorkoutEntryExerciseBase(
    (json['uid'] as String),
    (json['name'] as String),
    (json['mets'] as num).toDouble(),
  );
}

Map<String, dynamic> _$WorkoutEntryExerciseBaseToJson(
        WorkoutEntryExerciseBase instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'mets': instance.mets,
    };
