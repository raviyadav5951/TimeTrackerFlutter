import 'package:flutter/material.dart';
import 'package:time_tracker/app/home_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_page.dart';
import 'package:time_tracker/services/auth.dart';

class LandingPage extends StatefulWidget {
  final AuthBase authBase;
  LandingPage({@required this.authBase});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    User user = await widget.authBase.currentUser();
    _updateUser(user);
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        authBase: widget.authBase,
        onSignIn: _updateUser,
      );
    } else {
      return HomePage(
        authBase: widget.authBase,
        onSignOut: () => _updateUser(null),
      );
    }
  }
}
