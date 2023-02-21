import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timer_tracker/common_widgets/custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({required String text, required VoidCallback onPressed})
      : super(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            height: 44,
            color: Colors.indigo,
            borderRadius: 4,
            onPressed: onPressed);
}
