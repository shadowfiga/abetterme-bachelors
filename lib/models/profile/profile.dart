import 'package:abetterme/models/workout_entries/workout_entry.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/enums/units.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  String uid;
  String email;
  double weight;
  Units units;
  List<String> favoriteExercises = [];

  Profile({
    @required this.uid,
    @required this.email,
    this.weight = 0,
    this.units = Units.Metric,
    this.favoriteExercises,
  });

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  List<String> get favExercises => favoriteExercises ?? [];
}
