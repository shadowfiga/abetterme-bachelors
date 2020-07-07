import 'package:abetterme/providers/workout_entries.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import 'screens/auth/auth.dart';
import 'providers/profiles.dart';
import 'screens/overview.dart';
import 'screens/exercises/exercises.dart';
import 'screens/auth/password_recovery.dart';
import 'screens/workouts/workouts.dart';
import './providers/exercises.dart';
import './providers/workouts.dart';
import './screens/edit_profile.dart';
import 'screens/exercises/exercise_detail.dart';
import 'screens/workout_entries/quick_workout.dart';
import './screens/splash.dart';
import 'screens/workouts/edit_workout.dart';
import 'screens/workout_entries/standard_workout.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth.instance()),
        ChangeNotifierProxyProvider<Auth, Profiles>(
          create: (ctx) {
            return Profiles(null);
          },
          update: (ctx, auth, prev) {
            return Profiles(auth.profile);
          },
        ),
        ChangeNotifierProxyProvider<Auth, WorkoutEntries>(
          create: (ctx) {
            return WorkoutEntries(
              null,
            );
          },
          update: (ctx, auth, prev) {
            return WorkoutEntries(
              auth.profile,
              workoutEntries: prev.hasWorkoutEntries ? prev.workoutEntries : [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, Exercises>(
          create: (ctx) {
            return Exercises(
              null,
              [],
            );
          },
          update: (ctx, auth, prev) {
            return Exercises(
              auth.profile,
              prev.hasExercises ? prev.exercises : [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, Workouts>(
          create: (ctx) {
            return Workouts(
              null,
              [],
            );
          },
          update: (ctx, auth, prev) {
            return Workouts(
              auth.profile,
              prev.hasWorkouts ? prev.workouts : [],
            );
          },
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            title: 'ABetterMe',
            theme: ThemeData(
              primarySwatch: Colors.orange,
              fontFamily: "Lato",
            ),
            home: FutureBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreen();
                } else if (auth.user != null && auth.profile != null) {
                  return OverviewScreen();
                } else {
                  return AuthScreen();
                }
              },
              future: auth.autoLogin(),
            ),
            routes: {
              EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
              QuickWorkoutScreen.routeName: (ctx) => QuickWorkoutScreen(),
              OverviewScreen.routeName: (ctx) => OverviewScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
              ExercisesScreen.routeName: (ctx) => ExercisesScreen(),
              PasswordRecoveryScreen.routeName: (ctx) =>
                  PasswordRecoveryScreen(),
              ExerciseDetailScreen.routeName: (ctx) => ExerciseDetailScreen(),
              WorkoutsScreen.routeName: (ctx) => WorkoutsScreen(),
              EditWorkoutScreen.routeName: (ctx) => EditWorkoutScreen(),
              StandardWorkoutScreen.routeName: (ctx) => StandardWorkoutScreen(),
            },
          );
        },
      ),
    );
  }
}
