import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:timer_tracker/common_widgets/show_alert_dialog.dart';

Future<void> showExceptionAlertDialog(BuildContext context,
        {required String title, required Exception exception}) =>
    showAlertDialog(context,
        title: title,
        content: _mess(exception),
        defaultActionText: "OK",
        allowBarrierDismissible: true);
String _mess(Exception exception)
{
  if(exception is FirebaseAuthException) {
    return exception.message.toString();
  }
  return exception.toString();
}