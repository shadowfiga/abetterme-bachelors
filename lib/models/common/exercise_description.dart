import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../exercises/exercise.dart' show Exercise;

part 'exercise_description.g.dart';

@JsonSerializable()
class ExerciseDescription {
  String exerciseId;
  String exerciseName;
  double mets;

  ExerciseDescription({
    @required this.exerciseId,
    @required this.exerciseName,
    @required this.mets,
  });

  factory ExerciseDescription.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseDescriptionToJson(this);

  factory ExerciseDescription.fromExercise(Exercise exercise) =>
      ExerciseDescription(
          exerciseId: exercise.uid,
          exerciseName: exercise.name,
          mets: exercise.mets);
}
