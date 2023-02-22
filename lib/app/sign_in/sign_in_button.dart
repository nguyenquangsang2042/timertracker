import 'package:flutter/material.dart';
import 'package:timer_tracker/common_widgets/custom_elevated_button.dart';

// ignore: must_be_immutable
class SignInButton extends CustomElevatedButton {
  SignInButton.noImage({
    super.key,
    required String text,
    required Color color,
    required Color textColor,
    VoidCallback? onPressed,
  }) : super(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            color: color,
            onPressed: onPressed);

  SignInButton(
      {super.key,
      required String text,
      required Color color,
      required Color textColor,
      VoidCallback? onPressed,
      double heightImage = 0,
      double wightImage = 0,
      String pathImage = ""})
      : super(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(pathImage, height: heightImage, width: wightImage),
                Text(
                  text,
                  style: TextStyle(color: textColor, fontSize: 15),
                ),
                Opacity(
                  opacity: 0.0,
                  child: Container(
                    width: wightImage,
                    height: heightImage,
                  ),
                )
              ],
            ),
            color: color,
            onPressed: onPressed);
}
