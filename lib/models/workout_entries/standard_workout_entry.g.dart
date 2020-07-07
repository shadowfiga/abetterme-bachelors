part of 'standard_workout_entry.dart';

StandardWorkoutEntry _$StandardWorkoutEntryFromJson(Map<String, dynamic> json) {
  return StandardWorkoutEntry(
    (json['name'] as String),
    (json['exercises'] as List)
        .map((e) => StandardWorkoutEntryExercise.fromJson(Map.from(e)))
        .toList(),
    (json['caloriesBurned'] as num).toDouble(),
    timestamp: (json['timestamp'] != null)
        ? DateTime.parse(json['timestamp'])
        : DateTime.now(),
  );
}

Map<String, dynamic> _$StandardWorkoutEntryToJson(
        StandardWorkoutEntry instance) =>
    <String, dynamic>{
      'name': instance.name,
      'exercises': instance.exercises.map((e) => e.toJson()).toList(),
      'caloriesBurned': instance.caloriesBurned,
      'timestamp': instance.timestamp.toIso8601String(),
    };
