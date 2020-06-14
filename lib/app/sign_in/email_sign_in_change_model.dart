import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/services/auth.dart';

import 'email_sign_in_model.dart';

//We have removed final (immutable) and also changed updateWith
class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool isSubmitted;

  EmailSignInChangeModel(
      {@required this.auth,
      this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signin,
      this.isLoading = false,
      this.isSubmitted = false});

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isSubmitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.isSubmitted = isSubmitted ?? this.isSubmitted;
    notifyListeners();
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

  Future<void> submit() async {
    updateWith(isSubmitted: true, isLoading: true);
    try {
      switch (formType) {
        case EmailSignInFormType.signin:
          await auth.signInWithEmailAndPassword(email, password);
          break;
        case EmailSignInFormType.register:
          await auth.createAccountWithEmailAndPassword(
              email, password);
          break;
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signin
        ? EmailSignInFormType.register
        : EmailSignInFormType.signin;

    updateWith(email: '', password: '', isSubmitted: false, formType: formType);
  }
}
