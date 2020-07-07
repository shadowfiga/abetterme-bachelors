import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../models/exercises/exercise.dart';
import '../models/profile/profile.dart';

class Exercises extends ChangeNotifier {
  final Profile profile;
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.reference().child("exercise");
  DateTime lastFetch;
  List<Exercise> _exercises;
  Exercises(this.profile, this._exercises);

  List<Exercise> get exercises => _exercises == null ? [] : [..._exercises];
  bool get hasExercises => _exercises != null && _exercises.isNotEmpty;

  List<Exercise> get quickWorkoutExercises =>
      [..._exercises].where((exercise) => exercise.canQuickWorkout).toList();

  List<Exercise> get favoriteExercises {
    return exercises
        .where((e) => profile.favoriteExercises.contains(e.uid))
        .toList();
  }

  Future<Exercise> getExerciseById(String uid) async {
    if (exercises.isEmpty) await fetchExercises();
    return exercises.singleWhere((e) => e.uid == uid);
  }

  Future<void> fetchExercises() async {
    DataSnapshot snapshot = await _dbRef.once();
    Map<dynamic, dynamic> data = snapshot.value;
    if (data == null) {
      _exercises = [];
      notifyListeners();
      return;
    }
    _exercises = data.entries.map<Exercise>((entry) {
      final exercise =
          Exercise.fromJson(Map<String, dynamic>.from(entry.value));
      exercise.uid = entry.key as String;
      return exercise;
    }).toList();
    lastFetch = DateTime.now();
    notifyListeners();
  }

  Future<List<Exercise>> fetchQuickWorkoutExercises() async {
    if (_exercises == null) await fetchExercises();
    return [..._exercises].where((e) => e.canQuickWorkout).toList();
  }

  Future<Exercise> fetchExerciseById(String uid) async {
    final snapshot = await _dbRef.child(uid).once();
    if (snapshot == null) return null;
    final exercise = Exercise.fromJson(snapshot.value);
    exercise.uid = snapshot.key;
    return exercise;
  }

  Future<List<Exercise>> searchByName(String search) async {
    if (_exercises.isEmpty) await fetchExercises();
    final regex = RegExp(search.toLowerCase() + r".*");
    return exercises
        .where((e) => regex.hasMatch(e.name.toLowerCase()))
        .where((element) => !element.canQuickWorkout)
        .toList();
  }

  Future<List<Exercise>> getMultyByIds(List<String> exerciseIds) async {
    if (_exercises.isEmpty) await fetchExercises();
    return exercises.where((e) => exerciseIds.contains(e.uid)).toList();
  }

  Future<List<Exercise>> getFavoriteExercises() async {
    if (_exercises.isEmpty) await fetchExercises();
    return exercises
        .where((e) => profile.favExercises.contains(e.uid))
        .toList();
  }
}
