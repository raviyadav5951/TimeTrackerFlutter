import 'package:flutter/material.dart';
import 'package:time_tracker/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({ @required this.authBase,@required this.onSignOut});

  final VoidCallback onSignOut;
  final AuthBase authBase;

  Future<void> _signOut() async {
    try {
      await authBase.signOut();
      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    print("homepage");
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
              onPressed: _signOut,
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.0,
                ),
              ))
        ],
      ),
    );
  }
}
