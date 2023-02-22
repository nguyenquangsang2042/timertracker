import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tracker/app/sign_in/bloc/sign_in_manager.dart';
import 'package:timer_tracker/app/sign_in/email_sign_in_page.dart';
import 'package:timer_tracker/app/sign_in/sign_in_button.dart';
import 'package:timer_tracker/common_widgets/show_exception_alert_dialog.dart';

import '../../services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.bloc,required this.isLoading}) : super(key: key);
  final SignInManager bloc;
  final bool isLoading;

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(
              auth: Provider.of<AuthBase>(context, listen: false),
              isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, bloc, __) => SignInPage(bloc: bloc,isLoading: isLoading.value,),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on Exception catch (ex) {
      _showSignInError(context, ex);
    }
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseAuthException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(context,
        title: "Sign in fail", exception: exception);
  }

  void _signInWithEmail(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 150), () {
      Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => const EmailSignInPage()));
    });
  }

  Future<void> _goAnonymous(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<ValueNotifier<bool>>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer Tracker"),
        elevation: 3.0,
      ),
      body: _buildContent(context, isLoading.value),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (isLoading == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return const Text(
        "Sign in",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      );
    }
  }

  Container _buildContent(BuildContext context, bool? isLoading) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: _buildHeader(context),
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
                onPressed: isLoading != null && isLoading
                    ? null
                    : () => _signInWithGoogle(context)),
            const SizedBox(
              height: 10,
            ),
            SignInButton.noImage(
                text: "Sign in with Email",
                color: Colors.teal,
                textColor: Colors.white,
                onPressed: isLoading != null && isLoading
                    ? null
                    : () => _signInWithEmail(context)),
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
                onPressed: isLoading != null && isLoading
                    ? null
                    : () => _goAnonymous(context)),
            const SizedBox(
              height: 10,
            ),
          ]),
    );
  }
}
