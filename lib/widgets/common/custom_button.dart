import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final EdgeInsets margin;

  CustomButton({
    @required this.onTap,
    @required this.child,
    this.margin = const EdgeInsets.only(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.orange,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Color.fromRGBO(120, 120, 120, .2),
          splashColor: Colors.yellow,
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
            child: child,
          ),
        ),
      ),
    );
  }
}
