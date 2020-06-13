import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInBloc {
  final StreamController<EmailSignInModel> _modelController =
      new StreamController<EmailSignInModel>();
  final AuthBase auth;

  EmailSignInBloc({@required this.auth});

  //define getter and setter
  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInModel _model = new EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  //We want to update the model using copywith whenever ww send updated values from form.
  void updateWith(
      {String email,
      String password,
      EmailSignInFormType formType,
      bool isLoading,
      bool isSubmitted}) {
    _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        isSubmitted: isSubmitted);
    _modelController.add(_model);
  }

  Future<void> submit() async {
    updateWith(isSubmitted: true, isLoading: true);
    try {
      switch (_model.formType) {
        case EmailSignInFormType.signin:
          await auth.signInWithEmailAndPassword(_model.email, _model.password);
          break;
        case EmailSignInFormType.register:
          await auth.createAccountWithEmailAndPassword(
              _model.email, _model.password);
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
    final formType = _model.formType == EmailSignInFormType.signin
        ? EmailSignInFormType.register
        : EmailSignInFormType.signin;

    updateWith(email: '', password: '', isSubmitted: false, formType: formType);
  }
}
