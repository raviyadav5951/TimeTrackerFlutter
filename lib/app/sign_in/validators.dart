abstract class StringValidators {
  bool isValid(String value);
  bool isValidEmail(String value);
}

class NonEmptyStringValidator implements StringValidators {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }

  @override
  bool isValidEmail(String value) {
    return value.isNotEmpty &&
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value);
  }
}

class EmailAndPasswordValidators {
  final StringValidators emailValidator = NonEmptyStringValidator();
  final StringValidators passwordValidator = NonEmptyStringValidator();
  final String emailErrorText = 'Please enter valid email address.';
  final String passwordErrorText = 'Password can\'t be empty';
}
