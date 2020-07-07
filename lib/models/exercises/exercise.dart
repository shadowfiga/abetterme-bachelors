import 'package:abetterme/models/common/exercise_description.dart';
import 'package:json_annotation/json_annotation.dart';

import '../base_model.dart';
import 'aspect.dart';

part 'exercise.g.dart';

@JsonSerializable()
class Exercise extends BaseModel {
  String imageUrl;
  List<Aspect> aspects;
  double mets = 0;
  DateTime updatedAt = DateTime.now().toUtc();
  bool canQuickWorkout = false;
  String description;

  Exercise({
    uid,
    name,
    this.imageUrl,
    this.aspects,
    this.mets,
    this.canQuickWorkout,
    this.description,
  }) : super(
          uid: uid,
          name: name,
        );

  factory Exercise.fromExerciseDescription(ExerciseDescription desc) =>
      Exercise(uid: desc.exerciseId, name: desc.exerciseName);

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);

  List<Aspect> get exerciseAspects {
    return [...(aspects ?? [])];
  }
}
