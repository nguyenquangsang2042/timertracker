import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timer_tracker/app/sign_in/email_sign_in_form.dart';

import '../../services/auth.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key? key,required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
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
                children:  [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:  EmailSignInForm(auth: auth,),
                  ),
                ],
              )),
        ));
  }
}
