import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timer_tracker/app/sign_in/email_sign_in_page.dart';
import 'package:timer_tracker/app/sign_in/sign_in_button.dart';
import 'package:timer_tracker/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key, required this.auth});

  final AuthBase auth;

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithFacebook() async {
    try {
      await auth.signInWithFacebook();
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 150),(){
      Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true, builder: (context) =>  EmailSignInPage(auth: auth,)));
    });
  }

  Future<void> _goAnonymous() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer Tracker"),
        elevation: 3.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Container _buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign in",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            SignInButton(
                pathImage: 'assets/images/icon-google.png',
                heightImage: 30,
                wightImage: 30,
                text: "Sign in with google",
                color: Colors.white,
                textColor: Colors.black,
                onPressed: _signInWithGoogle),
            /*const SizedBox(
              height: 10,
            ),
            SignInButton(
                pathImage: 'assets/images/icon-facebook.png',
                heightImage: 30,
                wightImage: 30,
                text: "Sign in with Facebook",
                color: Colors.indigo,
                textColor: Colors.white,
                onPressed: _signInWithFacebook),*/
            const SizedBox(
              height: 10,
            ),
            SignInButton.noImage(
                text: "Sign in with Email",
                color: Colors.teal,
                textColor: Colors.white,
                onPressed: () => _signInWithEmail(context)),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "or",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            SignInButton.noImage(
                text: "Go anonymous",
                color: (Colors.lightGreen[400])!,
                textColor: Colors.white,
                onPressed: _goAnonymous),
            const SizedBox(
              height: 10,
            ),
          ]),
    );
  }
}
