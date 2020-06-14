import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker/common_widgets/form_submit_button.dart';
import 'package:time_tracker/common_widgets/platform_exception_alert.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  final EmailSignInChangeModel model;

  EmailSignInFormChangeNotifier({@required this.model});

  ///We will use this static method to create EmailSignInPage.
  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (BuildContext context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) =>
            EmailSignInFormChangeNotifier(
              model: model,
            ),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  //textediting controller for input fields like email and password.

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _emailEditingComplete() {
    final newFocusNode = model.emailValidator.isValidEmail(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocusNode);
  }

  Future<void> _submit() async {
    try {
      widget.model.submit();
      //dismiss current screen
      Navigator.pop(context);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in Failed',
        exception: e,
      ).show(context);
    } finally {

    }
  }

  void _toggleFormType() {
    widget.model.toggleFormType();
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
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
          onPressed: !model.isLoading ? _toggleFormType : null,
          child: Text(model.secondaryButtonText)),
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (_password) => widget.model.updatePassword(model.password),
    );
  }

  TextField _buildEmailTextInputField() {
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      onEditingComplete: () => _emailEditingComplete,
      onChanged: (_email) => widget.model.updateEmail(model.email),
    );
  }
}
