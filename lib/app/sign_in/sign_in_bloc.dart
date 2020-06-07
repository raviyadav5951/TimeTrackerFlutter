import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker/services/auth.dart';

//These steps 1-4 are required in every Bloc
class SignInBloc {
  final AuthBase auth;

  SignInBloc({@required this.auth});

  ///step1
  final StreamController<bool> _isLoadingController =
      new StreamController<bool>();

  ///step2
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  ///step3 add in stream
  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  ///step 4 dispose
  void dispose() => _isLoadingController.close();

  ///Add methods for handling authentications using this bLoc which accepts function as a parameter
  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithFacebook);

  Future<User> signInAnonymously() async => await _signIn(auth.signInAnonymously);

  Future<User> signInWithFacebook() async =>await _signIn(auth.signInWithFacebook);

  /// common method for sign in
  Future<User>_signIn(Future<User> Function() signInMethod) async{
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }
}
