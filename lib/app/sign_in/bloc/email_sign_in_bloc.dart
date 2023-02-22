import 'dart:async';

import 'package:timer_tracker/services/auth.dart';

import '../model/email_sign_in_model.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});
  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInModel _model = EmailSignInModel();
  void dispose() {
    _modelController.close();
  }

  void updateWith(
      {String? email,
      String? pass,
      EmailSignInFormType? type,
      bool? isLoading,
      bool? submitted}) {
    _model = _model.copyWith(
        email: email,
        pass: pass,
        type: type,
        isLoading: isLoading,
        submitted: submitted);
    _modelController.add(_model);
  }
  Future<void> submit() async {
    updateWith(submitted: true,isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPass(_model.email, _model.password);
      } else {
        await auth.createAccountWithEmailAndPass(_model.email, _model.password);
      }
    }  catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }


}
