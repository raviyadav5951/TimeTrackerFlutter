import 'package:flutter/material.dart';
import 'package:time_tracker/services/auth.dart';

class AuthProvider extends InheritedWidget{
  AuthProvider({@required this.auth, @required this.child});
  final AuthBase auth;
  final Widget child;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget)=>false;

  //we need to achieve something like AuthProvider.of(context)
  static AuthBase of(BuildContext context){
    AuthProvider provider=context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    return provider.auth;
  }

}