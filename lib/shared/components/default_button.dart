import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color background;
  final double height;
  final double width;
  final double radius;
  final VoidCallback onClick;
  final IconData? icon;
  final BuildContext? context;

  const DefaultButton({Key? key,
    required this.text,
    required this.onClick,
    this.textColor = Colors.white,
    this.background = Colors.pinkAccent,
    this.height = 52,
    this.width = double.infinity,
    this.radius = 10,
    this.icon ,
    this.context,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 20.0,
                color: textColor,
                fontFamily: 'Cardo',
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              icon,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget defaultButton({
    Color background = Colors.pinkAccent,
    required Function function,
    required String text,
    // bool isUpperCase = true,
    double radius = 10.0,
    double width = double.infinity,
    double height = 50,
    IconData? icon,
    BuildContext? context,
  }) =>
      Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: background,
        ),
        child: MaterialButton(
          onPressed: () {
            function();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                //isUpperCase ? text.toUpperCase() :
                text,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontFamily: 'Cardo',
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                icon,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );
}
