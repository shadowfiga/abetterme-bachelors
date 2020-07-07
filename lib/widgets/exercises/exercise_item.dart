import 'package:abetterme/providers/profiles.dart';
import 'package:after_init/after_init.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/exercises/exercise.dart';
import '../../screens/exercises/exercise_detail.dart';
import '../common/custom_icon_button.dart';

class ExerciseItem extends StatefulWidget {
  final Exercise exercise;
  final bool isFavorite;
  final Function onTap;
  ExerciseItem({@required this.exercise, this.isFavorite = false, this.onTap});

  @override
  _ExerciseItemState createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> with AfterInitMixin {
  bool _isFavorite;

  @override
  void didInitState() {
    this._isFavorite = widget.isFavorite;
  }

  Future<void> _updateFavorite(BuildContext ctx) async {
    await Provider.of<Profiles>(ctx, listen: false)
        .updateFavorites(widget.exercise);
    setState(() {
      _isFavorite = !_isFavorite;
    });
    if (widget.onTap != null) {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
          ExerciseDetailScreen.routeName,
          arguments: widget.exercise.uid),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  if (widget.exercise.imageUrl != null)
                    Image.network(
                      widget.exercise.imageUrl,
                      color: Colors.black45,
                      colorBlendMode: BlendMode.multiply,
                      width: double.infinity,
                    ),
                  Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: Colors.black87),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.exercise.name,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ABMIconButton(
                        icon: _isFavorite
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border),
                        onTap: () => _updateFavorite(context),
                        splashColor: Colors.black38,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
