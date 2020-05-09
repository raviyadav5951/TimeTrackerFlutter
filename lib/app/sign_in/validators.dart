abstract class StringValidators {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidators {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }

}

class EmailAndPasswordValidators {
  final StringValidators emailValidator = NonEmptyStringValidator();
  final StringValidators passwordValidator = NonEmptyStringValidator();
  final String emailErrorText = 'Email can\'t be empty';
  final String passwordErrorText = 'Password can\'t be empty';
}
