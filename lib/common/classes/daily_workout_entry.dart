import 'package:abetterme/models/workout_entries/workout_entry.dart';

class DailyWorkoutEntry {
  DateTime date;
  List<WorkoutEntry> entries;

  DailyWorkoutEntry(this.date, this.entries);

  double get calculateDailyCalories => entries.isNotEmpty
      ? entries
          .map((e) => e.caloriesBurned)
          .reduce((total, caloriesBurned) => total + caloriesBurned)
      : 0;
}
