import 'package:abetterme/models/profile/profile.dart';
import 'package:abetterme/models/workout_entries/workout_entry.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../models/exercises/exercise.dart';

class Profiles with ChangeNotifier {
  Profiles(Profile profile) : this.profile = profile;

  Profile profile;
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.reference().child("profile");

  Future<void> updateFavorites(Exercise exercise) async {
    final favoriteExercises = profile.favoriteExercises ?? [];
    favoriteExercises.contains(exercise.uid)
        ? favoriteExercises.remove(exercise.uid)
        : favoriteExercises.add(exercise.uid);
    profile.favoriteExercises = favoriteExercises;
    await _dbRef.child(profile.uid).set(profile.toJson());
    notifyListeners();
  }

  // Future<void> addWorkoutEntry(WorkoutEntry workoutEntry) async {
  //   final workoutEntries = profile.workoutEntries ?? [];
  //   workoutEntries.add(workoutEntry);
  //   profile.workoutEntries = workoutEntries;
  //   final profileJson = profile.toJson();
  //   await _dbRef.child(profile.uid).set(profileJson);
  //   notifyListeners();
  // }

  Future<void> updateProfile(Profile updatedProfile) async {
    await _dbRef.child(profile.uid).set(updatedProfile.toJson());
    profile = updatedProfile;
    notifyListeners();
  }
}
