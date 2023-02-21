import 'package:flutter/material.dart';
import 'package:timer_tracker/app/sign_in/string_validator.dart';
import 'package:timer_tracker/common_widgets/form_submit_button.dart';
import 'package:timer_tracker/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInForm({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

  String get _email => _emailController.text;

  String get _pass => _passController.text;
  bool _submitted = false;
  bool _isLoading = false;

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPass(_email, _pass);
      } else {
        await widget.auth.createAccountWithEmailAndPass(_email, _pass);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingCompleted() {
    final newFocus= widget.emailValidator.isValid(_email)?_passFocusNode:_emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _updateState() {
    setState(() {});
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
            children: _buildChildren(),
          ),
        ));
  }

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSignInFormType.signIn ? "Sign in" : "Create account";
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? "Need an account? Register"
        : "Have account? Sign in";
    bool submitEnable = widget.emailValidator.isValid(_email) &&
        widget.passValidator.isValid(_pass);
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
            color: submitEnable ? Colors.indigo : Colors.grey,
            text: primaryText,
            onPressed: submitEnable && !_isLoading ? _submit : null,
          )),
      TextButton(
          onPressed: !_isLoading?_toggleFormType:null,
          child: Text(
            secondaryText,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.normal),
          ))
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorEmailText =
        _submitted && !widget.passValidator.isValid(_pass);
    return TextField(
      enabled: !_isLoading,
      focusNode: _passFocusNode,
      autocorrect: false,
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Type your password",
          errorText: showErrorEmailText ? widget.strInvalidPass : null),
      obscureText: true,
      textInputAction: TextInputAction.done,
      controller: _passController,
      onEditingComplete: _submit,
      onChanged: (pass) => _updateState(),
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorEmailText =
        _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      enabled: !_isLoading,
      focusNode: _emailFocusNode,
      autocorrect: false,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingCompleted,
      onChanged: (pass) => _updateState(),
      decoration: InputDecoration(
          labelText: "Email",
          hintText: "Type your email",
          errorText: showErrorEmailText ? widget.strInValidEmail : null),
    );
  }
}
