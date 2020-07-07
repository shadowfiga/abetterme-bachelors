import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/auth/auth.dart';
import '../../providers/auth.dart';
import '../../screens/overview.dart';
import '../../screens/exercises/exercises.dart';
import 'drawer_menu_item.dart';
import '../../common/classes/clippy.dart';
import '../../screens/workouts/workouts.dart';
import '../../screens/edit_profile.dart';
import '../../screens/workout_entries/quick_workout.dart';

class AppDrawer extends StatelessWidget {
  static const _iconTitleSpacing = 8.0;
  static const fontSize = 16.0;

  Text _buildText(String text) => Text(
        text,
        style: TextStyle(fontSize: AppDrawer.fontSize),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(1, 247, 247, 247),
        ),
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: HalfOvalClipper(),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.orange),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10.0,
                  left: 10,
                  right: 10,
                  bottom: 40,
                ),
                child: Image(
                  image: AssetImage("assets/images/logo.png"),
                  height: 125,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            DrawerMenuItem(
              title: _buildText("Overview"),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(OverviewScreen.routeName),
              iconTitleSpacing: _iconTitleSpacing,
            ),
            DrawerMenuItem(
              title: _buildText("Exercises"),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(ExercisesScreen.routeName),
              iconTitleSpacing: _iconTitleSpacing,
            ),
            DrawerMenuItem(
              title: _buildText("Workouts"),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(WorkoutsScreen.routeName),
              iconTitleSpacing: _iconTitleSpacing,
            ),
            DrawerMenuItem(
              title: _buildText("Quick Workout"),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(QuickWorkoutScreen.routeName),
              iconTitleSpacing: _iconTitleSpacing,
            ),
            Divider(),
            DrawerMenuItem(
              title: _buildText("Profile"),
              icon: const Icon(Icons.account_circle),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(EditProfileScreen.routeName),
              iconTitleSpacing: _iconTitleSpacing,
            ),
            DrawerMenuItem(
              icon: Icon(
                Icons.lock,
                color: Colors.redAccent,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: fontSize,
                ),
              ),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.of(context)
                    .pushReplacementNamed(AuthScreen.routeName);
              },
            )
          ],
        ),
      ),
    );
  }
}
