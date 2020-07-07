import 'package:abetterme/models/workout_entries/standard_workout_entry_exercise.dart';
import 'package:abetterme/models/workout_entries/base_workout_entry.dart';

part 'standard_workout_entry.g.dart';

class StandardWorkoutEntry extends WorkoutEntryBase {
  final String name;
  final List<StandardWorkoutEntryExercise> exercises;
  StandardWorkoutEntry(this.name, this.exercises, double caloriesBurned,
      {DateTime timestamp})
      : super(caloriesBurned, timestamp: timestamp);

  factory StandardWorkoutEntry.fromJson(Map<String, dynamic> json) =>
      _$StandardWorkoutEntryFromJson(json);

  Map<String, dynamic> toJson() => _$StandardWorkoutEntryToJson(this);
}
