part of 'workout_entry.dart';
// final StandardWorkoutEntry standardWorkoutEntry;
// final QuickWorkoutEntry quickWorkoutEntry;

WorkoutEntry _$WorkoutEntryFromJson(Map<String, dynamic> json) {
  return WorkoutEntry(
    standardWorkoutEntry: (json['standardWorkoutEntry'] != null)
        ? StandardWorkoutEntry.fromJson(
            Map<String, dynamic>.from(json['standardWorkoutEntry']))
        : null,
    quickWorkoutEntry: (json['quickWorkoutEntry'] != null)
        ? QuickWorkoutEntry.fromJson(
            Map<String, dynamic>.from(json['quickWorkoutEntry']))
        : null,
  );
}

Map<String, dynamic> _$WorkoutEntryToJson(WorkoutEntry instance) =>
    <String, dynamic>{
      'standardWorkoutEntry': instance.standardWorkoutEntry?.toJson(),
      'quickWorkoutEntry': instance.quickWorkoutEntry?.toJson(),
    };
