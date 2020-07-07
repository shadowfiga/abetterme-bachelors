import 'package:after_init/after_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../common/enums/units.dart';
import '../../models/exercises/aspect.dart';
import '../../providers/exercises.dart';
import '../../common/helpers.dart';
import '../../providers/auth.dart';
import '../../widgets/exercises/aspect_item.dart';
import '../../models/exercises/exercise.dart';

class ExerciseDetailScreen extends StatefulWidget {
  static const routeName = '/exercises-detail';

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen>
    with AfterInitMixin {
  bool _isLoading = false;
  Exercise _exercise;
  double _weight = 0;
  Units _units;

  List<Widget> _buildTitle(String title) {
    return [
      Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ];
  }

  Divider _buildOrangeDivider() {
    return Divider(
      color: Colors.orange,
    );
  }

  List<Widget> _buildAspects(List<Aspect> aspects) {
    return aspects.map((e) => AspectItem(e)).toList();
  }

  @override
  void didInitState() {
    setState(() => _isLoading = true);
    final uid = ModalRoute.of(context).settings.arguments as String;
    Provider.of<Exercises>(context, listen: false)
        .getExerciseById(uid)
        .then(_loadData);
  }

  void _loadData(Exercise e) {
    final profile = Provider.of<Auth>(context, listen: false).profile;
    setState(() {
      _exercise = e;
      _weight = profile.weight ?? 0;
      _isLoading = false;
      _units = profile.units;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise Overview"),
        centerTitle: true,
      ),
      body: _isLoading
          ? SpinKitWave(
              color: Colors.grey,
            )
          : Stack(
              children: <Widget>[
                Text(
                  _exercise.name,
                  style: TextStyle(fontSize: 18),
                ),
                if (_exercise.imageUrl.isNotEmpty)
                  Image.network(
                    _exercise.imageUrl,
                    color: Colors.black45,
                    colorBlendMode: BlendMode.multiply,
                  ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 150,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  child: Card(
                    elevation: 12,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _exercise.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _buildOrangeDivider(),
                            ..._buildTitle("Calories burned(cals/min):"),
                            Text(
                              "The provided value is only an approximation.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            _weight == 0
                                ? Text(
                                    "Please update your profile with your accurate weight.")
                                : Text(
                                    "You will burn ${Helpers.calculateCaloriesPerMinute(mets: _exercise.mets, weight: _weight, units: _units).toStringAsFixed(2)} calories per minute of exercise."),
                            _buildOrangeDivider(),
                            ..._buildTitle("Description:"),
                            Text(_exercise.description),
                            if (_exercise.exerciseAspects != null &&
                                _exercise.exerciseAspects.isNotEmpty) ...[
                              _buildOrangeDivider(),
                              ..._buildTitle("Health Aspects:"),
                              ..._buildAspects(_exercise.exerciseAspects),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
