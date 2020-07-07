import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final Color backgroundColor;
  final Color splashColor;
  final Function onTap;
  final Widget child;

  final double borderRadius;

  final EdgeInsets margin;

  CustomRoundedButton({
    @required this.onTap,
    @required this.child,
    this.backgroundColor = Colors.white,
    this.splashColor = Colors.orange,
    this.borderRadius = 30,
    this.margin = const EdgeInsets.only(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          highlightColor: Colors.transparent,
          splashColor: splashColor,
          child: child,
          onTap: onTap,
        ),
      ),
    );
  }
}
