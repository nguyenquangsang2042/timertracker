import 'dart:async';

import 'package:timer_tracker/services/auth.dart';

import '../model/email_sign_in_change_model.dart';

/*class EmailSignInBloc {
  EmailSignInBloc({required this.auth});

  final AuthBase auth;
  final StreamController<EmailSignInChangeModel> _modelController =
      StreamController();

  Stream<EmailSignInChangeModel> get modelStream => _modelController.stream;

  final EmailSignInChangeModel _model = EmailSignInChangeModel(auth: auth);

  void dispose() {
    _modelController.close();
  }
  void updateWith(
      {String? email,
      String? pass,
      EmailSignInFormType? type,
      bool? isLoading,
      bool? submitted}) {
    _model.updateWith(
        email: email,
        pass: pass,
        type: type,
        isLoading: isLoading,
        submitted: submitted);
    _modelController.add(_model);
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPass(_model.email, _model.password);
      } else {
        await auth.createAccountWithEmailAndPass(_model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(pass: password);
}*/
