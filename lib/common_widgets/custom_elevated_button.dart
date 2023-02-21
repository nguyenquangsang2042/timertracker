import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton(
      {super.key,
      required this.child,
      required this.color,
      this.borderRadius = 6,
      this.onPressed,
      this.height = 50});

  final Widget child;
  final Color color;
  double borderRadius = 6;
  final VoidCallback? onPressed;
  double height = 50;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(borderRadius)))),
              backgroundColor: MaterialStateProperty.all<Color>(color)),
          onPressed: onPressed,
          child: child),
    );
  }
}
