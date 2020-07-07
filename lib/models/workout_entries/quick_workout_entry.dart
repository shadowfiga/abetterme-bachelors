import 'package:abetterme/models/workout_entries/quick_workout_entry_exercise.dart';

import 'base_workout_entry.dart';

part 'quick_workout_entry.g.dart';

class QuickWorkoutEntry extends WorkoutEntryBase {
  final int rounds;
  final List<QuickWorkoutEntryExercise> exercises;

  QuickWorkoutEntry(this.rounds, this.exercises, double caloriesBurned,
      {DateTime timestamp})
      : super(caloriesBurned, timestamp: timestamp);

  @override
  Map<String, dynamic> toJson() => _$QuickWorkoutEntryToJson(this);

  factory QuickWorkoutEntry.fromJson(Map<String, dynamic> json) =>
      _$QuickWorkoutEntryFromJson(json);
}
