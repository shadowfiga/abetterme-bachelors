import 'package:abetterme/models/profile/profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/workouts/workout.dart';

class Workouts extends ChangeNotifier {
  final Profile profile;
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.reference().child("workout");
  List<Workout> _workouts;

  bool get hasWorkouts => _workouts != null && _workouts.isNotEmpty;
  List<Workout> get workouts => [..._workouts];
  List<Workout> get userWorkouts =>
      [..._workouts].where((w) => w.userId == profile.uid).toList();
  List<Workout> get favoriteWorkouts =>
      workouts.where((e) => profile.favoriteExercises.contains(e.uid)).toList();

  Workouts(this.profile, this._workouts);
  Future<void> deleteWorkout(String uid) async {
    await _dbRef.child(uid).remove();
    _workouts.removeWhere((e) => e.uid == uid);
    notifyListeners();
  }

  Future<List<Workout>> searchByName(String search) async {
    if (_workouts.isEmpty) await fetchWorkouts();
    final regex = RegExp(search.toLowerCase() + r".*");
    return workouts.where((e) => regex.hasMatch(e.name.toLowerCase())).toList();
  }

  Future<void> fetchWorkouts() async {
    DataSnapshot snapshot = await _dbRef.once();
    Map<dynamic, dynamic> data = snapshot.value;
    if (data == null) {
      _workouts = [];
      notifyListeners();
      return;
    }
    _workouts = data.entries.map<Workout>((entry) {
      final _workout = Workout.fromJson(Map<String, dynamic>.from(entry.value));
      _workout.uid = entry.key as String;
      return _workout;
    }).toList();
    notifyListeners();
  }

  Future<Workout> getById(String uid) async {
    if (_workouts.isEmpty) await fetchWorkouts();
    return [...workouts].singleWhere((w) => w.uid == uid);
  }

  Future<void> createWorkout(Workout w) async {
    w.userEmail = profile.email;
    w.userId = profile.uid;
    await _dbRef.push().set(w.toJson());
    notifyListeners();
  }

  Future<void> updateWorkout(Workout w) async {
    await _dbRef.child(w.uid).set(w.toJson());
  }
}
