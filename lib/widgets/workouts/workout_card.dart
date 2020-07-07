import 'package:abetterme/widgets/common/custom_icon_button.dart';
import 'package:abetterme/widgets/exercises/exercise_info_list.dart';
import 'package:flutter/material.dart';

import '../../models/exercises/exercise.dart';
import '../../models/workouts/workout.dart';
import '../../screens/workout_entries/standard_workout.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;

  WorkoutCard(this.workout);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  workout.name,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                ABMIconButton(
                  iconPadding: const EdgeInsets.all(4),
                  iconMargin: const EdgeInsets.only(top: 4),
                  icon: Icon(
                    Icons.arrow_right,
                    size: 36,
                    color: Colors.green,
                  ),
                  onTap: () => Navigator.of(context).pushReplacementNamed(
                      StandardWorkoutScreen.routeName,
                      arguments: workout.uid),
                )
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            ExerciseInfoList(
              workout.exercises
                  .map((e) => Exercise.fromExerciseDescription(e))
                  .toList(),
              "Exercises",
            ),
            SizedBox(
              height: 6,
            )
          ],
        ),
      ),
    );
  }
}
