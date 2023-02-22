import 'package:flutter/material.dart';
import 'package:timer_tracker/app/sign_in/email_sign_in_form_staful.dart';
class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sign In",
            textAlign: TextAlign.center,
          ),
          elevation: 2.0,
        ),
        body: Container(
          height: double.infinity,
          child: Container(
              color: Colors.grey[200],
              child: Wrap(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: EmailSignInFormStateful(),
                    ),
                  ),
                ],
              )),
        ));
  }
}
