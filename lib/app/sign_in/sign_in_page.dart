import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_signin.dart';
import 'package:time_tracker/app/sign_in/sign_in_button.dart';
import 'package:time_tracker/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker/common_widgets/platform_exception_alert.dart';
import 'package:time_tracker/constants.dart';
import 'package:time_tracker/services/auth.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  //for adding loader state
  bool _isLoading = false;

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(title: 'Sign in Failed', exception: exception)
        .show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      setState(() => _isLoading = true);

      final authBase = Provider.of<AuthBase>(context, listen: false);
      await authBase.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      final authBase = Provider.of<AuthBase>(context, listen: false);
      await authBase.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR ABORTED BY USER') _showSignInError(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      final authBase = Provider.of<AuthBase>(context, listen: false);
      await authBase.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR ABORTED BY USER') _showSignInError(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _signInWithEmail(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => EmailSignInPage(),
        ),
      );
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 10.0,
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50.0, child: _buildProgressIndicator()),
          SizedBox(
            height: 48.0,
          ),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            bgColor: Colors.white,
            textColor: Colors.black87,
            onPressed: () => _isLoading?null:_signInWithGoogle(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            bgColor: Color(0xff2F4288),
            textColor: Colors.white,
            onPressed: () => _isLoading?null:_signInWithFacebook(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Sign in with Email',
            bgColor: Color(0xff347164),
            textColor: Colors.white,
            onPressed: () => _isLoading?null:_signInWithEmail(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black87,
            bgColor: Color(0xffD7E270),
            onPressed: () => _isLoading?null:_signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Text(
        'Sign-in',
        textAlign: TextAlign.center,
        style: kButtonTextStyle,
      );
    }
  }
}
