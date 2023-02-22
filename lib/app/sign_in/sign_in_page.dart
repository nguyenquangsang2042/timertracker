import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tracker/app/sign_in/bloc/sign_in_bloc.dart';
import 'package:timer_tracker/app/sign_in/email_sign_in_page.dart';
import 'package:timer_tracker/app/sign_in/sign_in_button.dart';
import 'package:timer_tracker/common_widgets/show_exception_alert_dialog.dart';

import '../../services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key,required this.bloc}) : super(key: key);
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    return Provider<SignInBloc>(
      dispose: (_,bloc)=>bloc.dispose(),
      create: (_) => SignInBloc(auth: Provider.of<AuthBase>(context,listen: false)),
      child: Consumer<SignInBloc>(
        builder: (_,bloc,__)=>SignInPage(bloc: bloc,),
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
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer Tracker"),
        elevation: 3.0,
      ),
      body: StreamBuilder<bool>(
        stream: bloc.isLoadStream,
        initialData: false,
        builder: (context, snapshot) => _buildContent(context, snapshot.data),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (Provider.of<SignInBloc>(context).isLoadStream == true) {
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
