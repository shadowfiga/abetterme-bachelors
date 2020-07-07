part 'workout_entry_exercise_base.g.dart';

class WorkoutEntryExerciseBase {
  final String uid;
  final String name;
  final double mets;

  WorkoutEntryExerciseBase(
    this.uid,
    this.name,
    this.mets,
  );

  Map<String, dynamic> toJson() => _$WorkoutEntryExerciseBaseToJson(this);
  factory WorkoutEntryExerciseBase.fromJson(Map<String, dynamic> json) =>
      _$WorkoutEntryExerciseBaseFromJson(json);
}
