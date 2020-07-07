import 'package:abetterme/models/workout_entries/workout_entry_exercise_base.dart';

part 'workout_entry_exercise.g.dart';

class StandardWorkoutEntryExercise extends WorkoutEntryExerciseBase {
  int sets = 0;

  StandardWorkoutEntryExercise(String uid, String name, double mets, this.sets)
      : super(uid, name, mets);

  factory StandardWorkoutEntryExercise.fromJson(Map<String, dynamic> json) =>
      _$WorkoutEntryExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutEntryExerciseToJson(this);
}
