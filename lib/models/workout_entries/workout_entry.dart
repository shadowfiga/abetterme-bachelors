import '../../models/workout_entries/quick_workout_entry.dart';
import '../../models/workout_entries/standard_workout_entry.dart';

part 'workout_entry.g.dart';

class WorkoutEntry {
  final StandardWorkoutEntry standardWorkoutEntry;
  final QuickWorkoutEntry quickWorkoutEntry;

  double get caloriesBurned =>
      (quickWorkoutEntry ?? standardWorkoutEntry)?.caloriesBurned;
  bool get isQuickWorkout => quickWorkoutEntry != null;
  DateTime get timestamp =>
      (quickWorkoutEntry ?? standardWorkoutEntry)?.timestamp;

  WorkoutEntry({this.quickWorkoutEntry, this.standardWorkoutEntry});

  factory WorkoutEntry.fromJson(Map<String, dynamic> json) =>
      _$WorkoutEntryFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutEntryToJson(this);
}
