import 'package:flutter/material.dart';

import 'custom_button.dart';

class CustomDialog extends StatelessWidget {
  final List<Widget> actions;
  final Widget title;
  final Widget description;

  CustomDialog({
    @required this.title,
    @required this.description,
    this.actions = const [],
  });

  void show(BuildContext context) {
    showDialog(context: context, builder: (ctx) => this.build(context));
  }

  CustomDialog.appDialog({
    @required String titleText,
    @required String descriptionText,
    @required Function onTap,
  })  : title = Text(
          titleText,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        description = Text(descriptionText),
        actions = [
          CustomButton(
            child: const Text("Ok"),
            onTap: onTap,
          )
        ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.orange, width: 2),
      ),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            title,
            description,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}
