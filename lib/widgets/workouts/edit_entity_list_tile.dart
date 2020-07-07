import 'package:abetterme/models/workouts/workout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/workouts.dart';
import '../common/custom_icon_button.dart';

class EditEntityListTile extends StatelessWidget {
  final Workout entity;
  final String routeName;

  EditEntityListTile(this.entity, this.routeName);

  Future<void> _delete(BuildContext ctx) async {
    await Provider.of<Workouts>(ctx, listen: false).deleteWorkout(
      entity.uid,
    );
    Scaffold.of(ctx)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text("Removed: ${entity.name}"),
        duration: Duration(seconds: 2),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          dense: true,
          title: Text(
            entity.name,
            style: TextStyle(fontSize: 18),
          ),
          trailing: Container(
            width: 70,
            child: Row(
              children: <Widget>[
                ABMIconButton(
                  iconPadding: const EdgeInsets.all(4),
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onTap: () => Navigator.of(context).pushNamed(
                    routeName,
                    arguments: entity.uid,
                  ),
                  splashColor: Colors.grey,
                ),
                SizedBox(width: 6),
                ABMIconButton(
                  iconPadding: const EdgeInsets.all(4),
                  splashColor: Colors.grey,
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () => _delete(context),
                )
              ],
            ),
          )),
    );
  }
}
