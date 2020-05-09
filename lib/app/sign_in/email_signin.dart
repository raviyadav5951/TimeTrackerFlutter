import 'package:flutter/material.dart';
import 'package:time_tracker/services/auth.dart';
import 'email_signin_form.dart';

class EmailSignInPage extends StatelessWidget {
  final AuthBase auth;
  EmailSignInPage({@required this.auth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign-in'),
        elevation: 10.0,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInForm(
              auth: auth,
            ),
          ),
        ),
      ),
    );
  }
}
