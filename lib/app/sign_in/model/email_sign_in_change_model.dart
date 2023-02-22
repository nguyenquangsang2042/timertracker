import 'package:flutter/cupertino.dart';
import 'package:timer_tracker/app/sign_in/string_validator.dart';
import 'package:timer_tracker/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInChangeModel with EmailAndPasswordValidators ,ChangeNotifier{
  final AuthBase auth;
  String? email;
  String? password;
  EmailSignInFormType? formType;
  bool isLoading;
  bool? submitted;
  EmailSignInChangeModel(
      {required this.auth,this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false}) ;

  void updateWith(
      {String? email,
      String? pass,
      EmailSignInFormType? type,
      bool? isLoading,
      bool? submitted}) {
    this.email = email ?? this.email;
    password = pass ?? password;
    formType = type ?? formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
  void toggleFormType(EmailSignInChangeModel model) {
    updateWith(
        email: '',
        pass: '',
        type:  model.formType == EmailSignInFormType.signIn
            ? EmailSignInFormType.register
            : EmailSignInFormType.signIn
    );
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPass(email!, password!);
      } else {
        await auth.createAccountWithEmailAndPass(email!, password!);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(pass: password);


  String get primaryButtonText =>
      formType == EmailSignInFormType.signIn ? "Sign in" : "Create account";

  String get secondaryButtonText => formType == EmailSignInFormType.signIn
      ? "Need an account? Register"
      : "Have account? Sign in";

  bool get canSubmit =>
      emailValidator.isValid(email) && passValidator.isValid(password);

  bool get showErrorTextPassword =>
      submitted! && !passValidator.isValid(password);

  bool get showErrorTextEmail => submitted! && !emailValidator.isValid(email);

  bool get isEmailEditingCompleted => emailValidator.isValid(email);
}
