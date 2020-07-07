import 'package:abetterme/screens/exercises/exercise_detail.dart';
import 'package:flutter/material.dart';

class ExerciseInfoItem extends StatelessWidget {
  static const int maxTextLength = 20;
  final String name;
  final String uid;
  final int sets;

  ExerciseInfoItem(this.name, this.uid, {this.sets});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(children: <Widget>[
          Text(
            name.length > maxTextLength
                ? name.substring(0, maxTextLength - 3) + "..."
                : name,
          ),
          if (sets != null) ...[
            SizedBox(
              width: 5,
            ),
            Chip(
              label: Text(sets.toString()),
              backgroundColor: Colors.orange,
            )
          ]
        ]),
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => Navigator.of(context)
              .pushNamed(ExerciseDetailScreen.routeName, arguments: uid),
        ),
      ],
    );
  }
}
