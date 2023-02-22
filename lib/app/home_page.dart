import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tracker/common_widgets/show_alert_dialog.dart';
import 'package:timer_tracker/services/auth.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      await Provider.of<AuthBase>(context,listen: false).signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final showRequestAccept = await showAlertDialog(context,
        title: "Logout",
        content: "Are you sure that you want to logout?",
        defaultActionText: "Yes",
        cancelActionText: "No",
        allowBarrierDismissible: false);
    if (showRequestAccept) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
        actions: <Widget>[
          TextButton(
              onPressed: () => _confirmSignOut(context),
              child: const Text(
                "Log out",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              )),
        ],
      ),
    );
  }
}
