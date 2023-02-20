import 'package:flutter/material.dart';
import 'package:timer_tracker/app/signin/sign_in_button.dart';
import 'package:timer_tracker/common_widgets/custom_elevated_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer Tracker"),
        elevation: 3.0,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Container _buildContent() {
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
            const SizedBox(
              height: 10,
            ),
            SignInButton(
                pathImage: 'assets/images/icon-facebook.png',
                heightImage: 30,
                wightImage: 30,
                text: "Sign in with Facebook",
                color: Colors.indigo,
                textColor: Colors.white,
                onPressed: _signInWithFacebook),
            const SizedBox(
              height: 10,
            ),
            SignInButton.noImage(
                text: "Sign in with Email",
                color: Colors.teal,
                textColor: Colors.white,
                onPressed: _signInWithEmail),
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

  void _signInWithGoogle() {
    print("Login Google");
  }

  void _signInWithFacebook() {
    print("Login Face");
  }

  void _signInWithEmail() {
    print("Login Email");
  }
  void _goAnonymous()
  {
    print("Login Anonymous");
  }
}
