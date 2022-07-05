import 'package:flutter/material.dart';
import 'package:shopping_app/shared/components/constant.dart';

class DefaultTextButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color background;
  final double radius;
  final VoidCallback onClick;

  const DefaultTextButton({
    Key? key,
    required this.text,
    required this.onClick,
    this.textColor = defaultColor,
    this.background = Colors.white,
    this.radius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: TextButton(
        onPressed: onClick,
        child: Text(
          text,
          style: TextStyle(color: textColor,
          fontSize: 15,
          fontFamily: 'Cardo',
          fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}