import 'package:flutter/material.dart';
import 'package:timer_tracker/common_widgets/form_submit_button.dart';
import 'package:timer_tracker/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  String get email => _emailController.text;

  String get pass => _passController.text;

  void _submit() async {
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPass(email, pass);
      } else {
        await widget.auth.createAccountWithEmailAndPass(email, pass);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildrent(),
          ),
        ));
  }

  List<Widget> _buildChildrent() {
    final primaryText =
        _formType == EmailSignInFormType.signIn ? "Sign in" : "Create account";
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? "Need an account? Register"
        : "Have account? Sign in";
    void _toggleFormType() {
      setState(() {
        _formType = _formType == EmailSignInFormType.signIn
            ? EmailSignInFormType.register
            : EmailSignInFormType.signIn;
      });
    }

    return [
      _buildEmailTextField(),
      _buildPasswordTextField(),
      const SizedBox(
        height: 20,
      ),
      SizedBox(
          height: 50,
          child: FormSubmitButton(
            text: primaryText,
            onPressed: _submit,
          )),
      TextButton(onPressed: _toggleFormType, child: Text(secondaryText))
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      autocorrect: false,
      decoration: const InputDecoration(
          labelText: "Password", hintText: "Type your password"),
      obscureText: true,
      textInputAction: TextInputAction.done,
      controller: _passController,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      autocorrect: false,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
          labelText: "Email", hintText: "Type your email"),
    );
  }
}
