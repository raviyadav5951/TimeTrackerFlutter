import 'package:time_tracker/app/sign_in/validators.dart';

enum EmailSignInFormType { signin, register }

class EmailSignInModel with EmailAndPasswordValidators {
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool isSubmitted;

  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signin,
      this.isLoading = false,
      this.isSubmitted = false});

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isSubmitted,
  }) {
    return EmailSignInModel(
        email: email ?? this.email,
        password: password ?? this.password,
        formType: formType ?? this.formType,
        isLoading: isLoading ?? this.isLoading,
        isSubmitted: isSubmitted ?? this.isSubmitted);
  }

//Move the methods inside the model class
  String get primaryButtonText {
    return formType == EmailSignInFormType.signin
        ? 'Sign-in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signin
        ? 'Need an account? Register.'
        : 'Have an account? Sign-in';
  }

  bool get canSubmit {
    return emailValidator.isValidEmail(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get getPasswordErrorText {
    bool showErrorText = isSubmitted && !passwordValidator.isValid(password);
    return showErrorText ? passwordErrorText : null;
  }

  String get getEmailErrorText {
    bool showErrorText = isSubmitted && !emailValidator.isValidEmail(email);
    return showErrorText ? emailErrorText : null;
  }
}
