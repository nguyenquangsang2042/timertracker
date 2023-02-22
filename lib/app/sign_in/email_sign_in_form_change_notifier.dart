import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tracker/common_widgets/form_submit_button.dart';
import 'package:timer_tracker/common_widgets/show_alert_dialog.dart';
import 'package:timer_tracker/services/auth.dart';

import 'model/email_sign_in_change_model.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({Key? key, required this.model})
      : super(key: key);
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(
          model: model,
        ),
      ),
    );
  }

  @override
  State<EmailSignInFormChangeNotifier> createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  EmailSignInChangeModel get model => widget.model;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

  void _emailEditingCompleted(EmailSignInChangeModel model) {
    final newFocus =
        model.isEmailEditingCompleted ? _passFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
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
    return [
      _buildEmailTextField(),
      _buildPasswordTextField(),
      const SizedBox(
        height: 20,
      ),
      SizedBox(
          height: 50,
          child: FormSubmitButton(
            color: model.canSubmit ? Colors.indigo : Colors.grey,
            text: model.primaryButtonText,
            onPressed: () => model.canSubmit && !model.isLoading
                ? model.submit().onError((error, stackTrace) {
                    FirebaseException? e = error as FirebaseException?;
                    showAlertDialog(context,
                        title: model.primaryButtonText,
                        content: e!.message!,
                        defaultActionText: "Đóng",
                        allowBarrierDismissible: true);
                  })
                : null,
          )),
      TextButton(
          onPressed: () =>
              !model.isLoading ? model.toggleFormType(model) : null,
          child: Text(
            model.secondaryButtonText,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.normal),
          ))
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      enabled: !model.isLoading,
      focusNode: _passFocusNode,
      autocorrect: false,
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Type your password",
          errorText: model.showErrorTextPassword ? model.strInvalidPass : null),
      obscureText: true,
      textInputAction: TextInputAction.done,
      controller: _passController,
      onEditingComplete: () => model.submit().onError((error, stackTrace) {
        FirebaseException? e = error as FirebaseException?;
        showAlertDialog(context,
            title: model.primaryButtonText,
            content: e!.message!,
            defaultActionText: "Đóng",
            allowBarrierDismissible: true);
      }),
      onChanged: (pass) => model.updatePassword(pass),
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      enabled: !model.isLoading,
      focusNode: _emailFocusNode,
      autocorrect: false,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingCompleted(model),
      onChanged: (email) => model.updateEmail(email),
      decoration: InputDecoration(
          labelText: "Email",
          hintText: "Type your email",
          errorText: model.showErrorTextEmail ? model.strInValidEmail : null),
    );
  }
}
