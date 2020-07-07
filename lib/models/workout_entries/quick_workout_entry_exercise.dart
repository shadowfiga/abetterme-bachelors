import 'package:abetterme/models/exercises/exercise.dart';
import 'package:abetterme/models/workout_entries/quick_workout_entry.dart';
import 'package:abetterme/models/workout_entries/workout_entry_exercise_base.dart';

// Can just use the base classes serialization since the classes are the same
class QuickWorkoutEntryExercise extends WorkoutEntryExerciseBase {
  QuickWorkoutEntryExercise(String uid, String name, double mets)
      : super(uid, name, mets);

  factory QuickWorkoutEntryExercise.fromJson(Map<String, dynamic> json) {
    final workout = WorkoutEntryExerciseBase.fromJson(json);
    return QuickWorkoutEntryExercise(workout.uid, workout.name, workout.mets);
  }

  factory QuickWorkoutEntryExercise.fromExercise(Exercise exercise) =>
      QuickWorkoutEntryExercise(exercise.uid, exercise.name, exercise.mets);
}
