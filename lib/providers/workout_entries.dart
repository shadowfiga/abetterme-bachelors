import 'package:abetterme/models/profile/profile.dart';
import 'package:abetterme/models/workout_entries/base_workout_entry.dart';
import 'package:abetterme/models/workout_entries/workout_entry.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WorkoutEntries extends ChangeNotifier {
  final Profile profile;
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.reference().child("workout_entries");
  List<WorkoutEntry> _workoutEntries;

  List<WorkoutEntry> get workoutEntries => [..._workoutEntries];
  bool get hasWorkoutEntries =>
      _workoutEntries != null && _workoutEntries.isNotEmpty;

  WorkoutEntries(this.profile, {List<WorkoutEntry> workoutEntries})
      : this._workoutEntries = workoutEntries ?? [];

  Future<void> addWorkoutEntry(WorkoutEntry workoutEntry) async {
    await fetchWorkoutEntries();
    final data = workoutEntries + [workoutEntry];
    await _dbRef.child(profile.uid).set(data.map((e) => e.toJson()).toList());
    _workoutEntries.add(workoutEntry);
    notifyListeners();
  }

  Future<List<WorkoutEntry>> fetchWorkoutEntries() async {
    final snapshot = await _dbRef.child(profile.uid).once();
    final data = snapshot.value;
    if (data == null) {
      _workoutEntries = [];
      notifyListeners();
      return [];
    }
    _workoutEntries = data.map<WorkoutEntry>((entry) {
      Map<String, dynamic> jsonEntry = Map();
      for (MapEntry<dynamic, dynamic> e in entry.entries) {
        jsonEntry[e.key as String] = e.value;
      }
      final workoutEntry =
          WorkoutEntry.fromJson(Map<String, dynamic>.from(jsonEntry));
      return workoutEntry;
    }).toList();
    notifyListeners();
    return _workoutEntries;
  }

  double get allTimeCalories => _workoutEntries
      .map((e) => (e as WorkoutEntryBase).caloriesBurned)
      .reduce((value, element) => value + element);

  double get caloriesLastWeek => _workoutEntries
      .where((e) => (e as WorkoutEntryBase)
          .timestamp
          .isAfter(DateTime.now().subtract(Duration(days: 7))))
      .map((e) => (e as WorkoutEntryBase).caloriesBurned)
      .reduce((value, element) => value + element);
}
