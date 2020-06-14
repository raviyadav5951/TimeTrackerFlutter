import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker/services/auth.dart';

class SignInBloc {
  final AuthBase auth;
  final ValueNotifier isLoading;
  SignInBloc({@required this.auth,@required this.isLoading});


  ///Add methods for handling authentications using this bLoc which accepts function as a parameter
  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithFacebook);

  Future<User> signInAnonymously() async => await _signIn(auth.signInAnonymously);

  Future<User> signInWithFacebook() async =>await _signIn(auth.signInWithFacebook);

  /// common method for sign in
  Future<User>_signIn(Future<User> Function() signInMethod) async{
    try {
      isLoading.value=true;
      return await signInMethod();
    } catch (e) {
      isLoading.value=false;
      rethrow;
    }
  }
}
