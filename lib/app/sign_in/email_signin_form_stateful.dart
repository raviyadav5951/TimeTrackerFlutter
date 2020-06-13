import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/common_widgets/form_submit_button.dart';
import 'package:time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker/common_widgets/platform_exception_alert.dart';
import 'package:time_tracker/services/auth.dart';

import 'email_sign_in_model.dart';

class EmailSignInFormStateful extends StatefulWidget
    with EmailAndPasswordValidators {

  @override
  _EmailSignInFormStatefulState createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  //textediting controller for input fields like email and password.

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _submitted = false;
  bool _isLoading = false;

  //getter methods
  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signin;

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _emailEditingComplete() {
    final newFocusNode = widget.emailValidator.isValidEmail(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocusNode);
  }

  Future<void> _submit() async {
    try {
      setState(() {
        _submitted = true;
        _isLoading = true;
      });
      final authBase = Provider.of<AuthBase>(context, listen: false);
      switch (_formType) {
        case EmailSignInFormType.signin:
          await authBase.signInWithEmailAndPassword(_email, _password);
          break;
        case EmailSignInFormType.register:
          await authBase.createAccountWithEmailAndPassword(_email, _password);
          break;
      }
      //dismiss current screen
      Navigator.pop(context);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in Failed',
        exception: e,
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signin
          ? EmailSignInFormType.register
          : EmailSignInFormType.signin;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: _buildChildren(),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }

  List<Widget> _buildChildren() {
    bool _isSubmitEnabled = widget.emailValidator.isValidEmail(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    final primaryText = _formType == EmailSignInFormType.signin
        ? 'Sign-in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signin
        ? 'Need an account? Register.'
        : 'Have an account? Sign-in';

    return [
      _buildEmailTextInputField(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: _isSubmitEnabled ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
          onPressed: !_isLoading ? _toggleFormType : null,
          child: Text(secondaryText)),
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.passwordErrorText : null,
        enabled: _isLoading == false,
      ),
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (_password) => _updateState(),
    );
  }

  TextField _buildEmailTextInputField() {
    bool showErrorText =
        _submitted && !widget.emailValidator.isValidEmail(_email);
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText ? widget.emailErrorText : null,
        enabled: _isLoading == false,
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      onEditingComplete: _emailEditingComplete,
      onChanged: (_email) => _updateState(),
    );
  }

  void _updateState() {
    setState(() {});
  }
}
