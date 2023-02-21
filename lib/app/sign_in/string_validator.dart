import 'package:flutter/cupertino.dart';

import 'email_sign_in_form.dart';

abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    // TODO: implement isValid
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators  {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passValidator = NonEmptyStringValidator();
  final String strInValidEmail = 'Email can\'t be emplty';
  final String strInvalidPass = 'Password can\'t be emplty';
}
