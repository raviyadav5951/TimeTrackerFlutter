import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/form_submit_button.dart';
import 'package:time_tracker/common_widgets/platform_exception_alert.dart';
import 'package:time_tracker/services/auth.dart';
import 'email_sign_in_bloc.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  final EmailSignInBloc bloc;

  EmailSignInFormBlocBased({@required this.bloc});

  ///We will use this static method to create EmailSignInPage.
  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      create: (BuildContext context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBlocBased(
          bloc: bloc,
        ),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  //textediting controller for input fields like email and password.

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocusNode = model.emailValidator.isValidEmail(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocusNode);
  }

  Future<void> _submit() async {
    try {
      widget.bloc.submit();
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
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: _buildChildren(model),
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          );
        });
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextInputField(model),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(model),
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

  TextField _buildPasswordTextField(EmailSignInModel model) {

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
      onChanged: (_password) => widget.bloc.updatePassword(model.password),
    );
  }

  TextField _buildEmailTextInputField(EmailSignInModel model) {

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
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: (_email) => widget.bloc.updateEmail(model.email),
    );
  }

}
