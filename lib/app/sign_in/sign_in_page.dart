import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/sign_in_button.dart';
import 'package:time_tracker/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker/constants.dart';
import 'package:time_tracker/services/auth.dart';

class SignInPage extends StatelessWidget {
  //constructor that will be called from Landing page
  SignInPage({@required this.authBase, @required this.onSignIn});

  final AuthBase authBase;

  //this function is callback to let the landing page know that we logged in.
  final Function(User) onSignIn;

  Future<void> _signInAnonymously() async {
    try {
      print("sign in anonymously called");
      final User user = await authBase.signInAnonymously();
      print(user.uid);
      onSignIn(user);
    } catch (e) {
      print('exception==${e.toString()}');
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
      body: _buildContent(),
    );
  }

  //extracted method

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: kButtonTextStyle,
          ),
          SizedBox(
            height: 48.0,
          ),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            bgColor: Colors.white,
            textColor: Colors.black87,
            onPressed: () {},
          ),
          SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Faceboook',
            bgColor: Color(0xff2F4288),
            textColor: Colors.white,
            onPressed: () {},
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Sign in with Email',
            bgColor: Color(0xff347164),
            textColor: Colors.white,
            onPressed: () {},
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
            onPressed: _signInAnonymously,
          ),
        ],
      ),
    );
  }
}
