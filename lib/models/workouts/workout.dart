import 'package:abetterme/models/common/exercise_description.dart';
import 'package:json_annotation/json_annotation.dart';

import '../base_model.dart';

part 'workout.g.dart';

@JsonSerializable()
class Workout extends BaseModel {
  List<ExerciseDescription> exercises;
  DateTime updatedAt = DateTime.now().toUtc();

  String userEmail;
  String userDisplayName;
  String userId;

  Workout({
    name,
    description,
    uid,
    this.userId,
    this.userEmail,
    this.userDisplayName,
    this.exercises,
    this.updatedAt,
  }) : super(
          uid: uid,
          name: name,
        );

  factory Workout.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFromJson(json);

  factory Workout.empty() => Workout(
        name: '',
        description: '',
        userId: null,
        userEmail: null,
        userDisplayName: null,
        exercises: [],
        updatedAt: null,
      );

  Map<String, dynamic> toJson() {
    final workoutJson = _$WorkoutToJson(this);
    workoutJson["exercises"] = this.exercises.map((e) => e.toJson()).toList();
    return workoutJson;
  }
}
