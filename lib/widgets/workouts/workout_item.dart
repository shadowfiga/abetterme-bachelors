import 'package:abetterme/models/workouts/workout.dart';
import 'package:flutter/material.dart';

class WorkoutItem extends StatelessWidget {
  final Workout workout;

  WorkoutItem(this.workout);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Text(workout.name),
      ),
    );
  }
}
