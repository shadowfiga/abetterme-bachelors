part of 'quick_workout_entry.dart';

QuickWorkoutEntry _$QuickWorkoutEntryFromJson(Map<String, dynamic> json) {
  return QuickWorkoutEntry(
    (json['rounds'] as num).toInt(),
    (json['exercises'] as List)
        ?.map((e) => QuickWorkoutEntryExercise.fromJson(Map.from(e)))
        ?.toList(),
    (json['caloriesBurned'] as num ?? 0).toDouble(),
    timestamp: (json['timestamp'] != null)
        ? DateTime.parse(json['timestamp'])
        : DateTime.now(),
  );
}

Map<String, dynamic> _$QuickWorkoutEntryToJson(QuickWorkoutEntry instance) =>
    <String, dynamic>{
      'rounds': instance.rounds,
      'exercises': instance.exercises.map((e) => e.toJson()).toList(),
      'caloriesBurned': instance.caloriesBurned,
      'timestamp': instance.timestamp.toIso8601String(),
    };
