import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

//we have to return our own user object instead of FirebaseUser .
//For e.g we have the model/bean object in native.
class User {
  User({@required this.uid});

  final String uid;
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<void> signOut();
  Future<User> signInWithGoogle();
  Future<void> signOutFromGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createAccountWithEmailAndPassword(String email, String password);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }

    return User(uid: user.uid);
  }

  //this method will be used as a Stram map which we wil use later in sigin and signout function.
  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> createAccountWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<User> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      if (googleSignInAuthentication.accessToken != null &&
          googleSignInAuthentication.idToken != null) {
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final AuthResult authResult =
            await _firebaseAuth.signInWithCredential(credential);

        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR MISSING GOOGLE TOKEN',
          message: 'Missing auth token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR ABORTED BY USER',
        message: 'SignIn aborted by user',
      );
    }
  }

  //We have to logout from Firebase as well as google/facebook both.
  @override
  Future<void> signOutFromGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final FacebookLogin facebookSignIn = new FacebookLogin();
    await facebookSignIn.logOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<User> signInWithFacebook() async {
    final FacebookLogin facebookSignIn = new FacebookLogin();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    User user;

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        if (accessToken != null) {
          final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: accessToken.token,
          );

          final AuthResult authResult =
              await _firebaseAuth.signInWithCredential(credential);

          user = _userFromFirebase(authResult.user);
        } else {
          throw PlatformException(
            code: 'ERROR MISSING TOKEN',
            message: 'Missing auth token',
          );
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        throw PlatformException(
          code: 'ERROR LOGIN CANCELLED',
          message: 'Login cancelled by the user.',
        );
        break;
      case FacebookLoginStatus.error:
        throw PlatformException(
          code: 'ERROR MISSING GOOGLE TOKEN',
          message: 'Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}',
        );
        break;
    }

    return user;
  }
}
