abstract class WorkoutEntryBase {
  final double caloriesBurned;
  final DateTime timestamp;

  WorkoutEntryBase(this.caloriesBurned, {timestamp})
      : this.timestamp = timestamp ?? DateTime.now().toUtc();

  Map<String, dynamic> toJson();
}
