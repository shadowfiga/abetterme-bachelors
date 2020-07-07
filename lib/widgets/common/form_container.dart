import 'package:flutter/material.dart';

class FormChildContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;

  FormChildContainer({
    @required this.child,
    this.margin = const EdgeInsets.only(),
    this.padding = const EdgeInsets.only(
      top: 4,
      bottom: 24,
      left: 16,
      right: 16,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.orange,
        ),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: child,
    );
  }
}
