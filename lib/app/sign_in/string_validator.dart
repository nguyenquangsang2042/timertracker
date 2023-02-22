abstract class StringValidator {
  bool isValid(String? value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String? value) {
    if (value != null) {
      return value.isNotEmpty;
    } else {
      return false;
    }
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passValidator = NonEmptyStringValidator();
  final String strInValidEmail = 'Email can\'t be empty';
  final String strInvalidPass = 'Password can\'t be empty';
}
