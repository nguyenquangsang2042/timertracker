enum EmailSignInFormType { signIn, register }
class EmailSignInModel {
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
  EmailSignInModel copyWith({String? email,
    String? pass,
    EmailSignInFormType? type,
    bool? isLoading,
    bool? submitted})
  {
      return EmailSignInModel(email: email??this.email,
      password: pass??password,
        formType: type??formType,
        isLoading: isLoading??this.isLoading,
        submitted: submitted??this.submitted
      );
  }
}
