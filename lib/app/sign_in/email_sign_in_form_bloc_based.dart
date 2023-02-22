import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tracker/app/sign_in/bloc/email_sign_in_bloc.dart';
import 'package:timer_tracker/app/sign_in/string_validator.dart';
import 'package:timer_tracker/common_widgets/form_submit_button.dart';
import 'package:timer_tracker/services/auth.dart';

import 'model/email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget
{
  EmailSignInFormBlocBased({Key? key, required this.bloc}) : super(key: key);
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(
          bloc: bloc,
        ),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<EmailSignInFormBlocBased> createState() => _EmailSignInFormBlocBased();
}

class _EmailSignInFormBlocBased extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

  void _emailEditingCompleted(EmailSignInModel model) {
    final newFocus =model.isEmailEditingCompleted
        ? _passFocusNode
        : _emailFocusNode;
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
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        builder: (context, snapshot) {
          EmailSignInModel? model = snapshot.data;
          model ??= EmailSignInModel();
          return Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildChildren(model),
                ),
              ));
        });
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    void _toggleFormType(EmailSignInModel model) {
     widget.bloc.updateWith(
       email: '',
       pass: '',
       type:  model.formType == EmailSignInFormType.signIn
           ? EmailSignInFormType.register
           : EmailSignInFormType.signIn
     );
     _emailController.clear();
     _passController.clear();
    }

    return [
      _buildEmailTextField(model),
      _buildPasswordTextField(model),
      const SizedBox(
        height: 20,
      ),
      SizedBox(
          height: 50,
          child: FormSubmitButton(
            color: model.canSubmit ? Colors.indigo : Colors.grey,
            text: model.primaryButtonText,
            onPressed: () =>
                model.canSubmit &&  !model.isLoading ? widget.bloc.submit() : null,
          )),
      TextButton(
          onPressed:()=>  !model.isLoading ? _toggleFormType(model) : null,
          child: Text(
            model.secondaryButtonText,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.normal),
          ))
    ];
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
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
      onEditingComplete: () => widget.bloc.submit(),
      onChanged: (pass) => widget.bloc.updatePassword( pass),
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      enabled: !model.isLoading,
      focusNode: _emailFocusNode,
      autocorrect: false,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingCompleted(model),
      onChanged: (email) => widget.bloc.updateEmail( email),
      decoration: InputDecoration(
          labelText: "Email",
          hintText: "Type your email",
          errorText: model.showErrorTextEmail ? model.strInValidEmail : null),
    );
  }
}
