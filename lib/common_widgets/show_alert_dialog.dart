import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showAlertDialog(BuildContext context,
    {required String title,
    required String content,
    required String defaultActionText,
    String? cancelActionText,
    required bool allowBarrierDismissible}) {
  if (!Platform.isIOS) {
    return showDialog(
        barrierDismissible: allowBarrierDismissible,
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                title,
                style: const TextStyle(color: Colors.indigo),
              ),
              content: Text(content),
              actions: [
                if (cancelActionText != null)
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        cancelActionText,
                        style: const TextStyle(color: Colors.black),
                      )),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      defaultActionText,
                      style: const TextStyle(color: Colors.indigo),
                    ))
              ],
            ));
  } else {
    return showDialog(
        barrierDismissible: allowBarrierDismissible,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(
                title,
                style: const TextStyle(color: Colors.indigo),
              ),
              content: Text(content),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      defaultActionText,
                      style: const TextStyle(color: Colors.indigo),
                    ))
              ],
            ));
  }
}
