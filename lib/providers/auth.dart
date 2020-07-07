import 'dart:async';

import 'package:abetterme/models/profile/profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../common/enums/units.dart';

class Auth with ChangeNotifier {
  FirebaseAuth _auth;
  Profile _profile;
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.reference().child("profile");

  Profile get profile {
    return _profile;
  }

  FirebaseUser user;

  Auth.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Future<bool> login(String email, String password) async {
    FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    if (user != null && !user.isEmailVerified) {
      return false;
    }
    _profile = await _fetchProfile(user);
    return true;
  }

  Future<void> register(
      String email, String password, double weight, Units units) async {
    FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    await _dbRef.child(user.uid).set(Profile(
          email: user.email,
          uid: user.uid,
          weight: weight,
          units: units,
          favoriteExercises: [],
        ).toJson());
    await user.sendEmailVerification();
    await _auth.signOut();
  }

  Future<void> recoverPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> resendVerificationEmail() async {
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  Future<Profile> _fetchProfile(FirebaseUser firebaseUser) async {
    DataSnapshot snapshot = await _dbRef.child(user.uid).once();
    final pro = Profile.fromJson(Map<String, dynamic>.from(snapshot.value));
    pro.uid = snapshot.key;
    return pro;
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser != null && firebaseUser.isEmailVerified) {
      user = firebaseUser;
      _profile = await _fetchProfile(firebaseUser);
      notifyListeners();
    }
  }

  Future<void> autoLogin() async {
    user = await FirebaseAuth.instance.currentUser();
    if (user != null) _profile = await _fetchProfile(user);
  }
}
