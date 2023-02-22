import 'package:timer_tracker/app/sign_in/string_validator.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  EmailSignInModel copyWith(
      {String? email,
      String? pass,
      EmailSignInFormType? type,
      bool? isLoading,
      bool? submitted}) {
    return EmailSignInModel(
        email: email ?? this.email,
        password: pass ?? password,
        formType: type ?? formType,
        isLoading: isLoading ?? this.isLoading,
        submitted: submitted ?? this.submitted);
  }

  String get primaryButtonText =>
      formType == EmailSignInFormType.signIn ? "Sign in" : "Create account";

  String get secondaryButtonText => formType == EmailSignInFormType.signIn
      ? "Need an account? Register"
      : "Have account? Sign in";

  bool get canSubmit =>
      emailValidator.isValid(email) && passValidator.isValid(password);

  bool get showErrorTextPassword => submitted && !passValidator.isValid(password);
  bool get showErrorTextEmail=> submitted && !emailValidator.isValid(email);
  bool get isEmailEditingCompleted=>emailValidator.isValid(email);
}
