import 'package:abetterme/models/workout_entries/workout_entry_exercise_base.dart';

part 'standard_workout_entry_exercise.g.dart';

class StandardWorkoutEntryExercise extends WorkoutEntryExerciseBase {
  int sets;

  StandardWorkoutEntryExercise(this.sets, String uid, String name, double mets)
      : super(uid, name, mets);

  factory StandardWorkoutEntryExercise.fromJson(Map<String, dynamic> json) =>
      _$StandardWorkoutEntryExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$StandardWorkoutEntryExerciseToJson(this);
}
