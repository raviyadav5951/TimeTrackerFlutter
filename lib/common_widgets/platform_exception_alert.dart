import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker/common_widgets/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog(
      {@required String title, @required PlatformException exception})
      : super(
            title: title,
            content: _message(exception),
            defaultActionText: 'Ok');

  static _message(PlatformException exception) {
    return _errors[exception.message] ?? exception.message;
  }

  static Map<String, String> _errors = {
    'ERROR_WEAK_PASSWORD': 'Password is not strong enough',
    'ERROR_INVALID_EMAIL': 'Invalid email address.',
    'ERROR_EMAIL_ALREADY_IN_USE':
        'Email is already in use by a different account.',
    'ERROR_INVALID_CREDENTIAL': 'Email address is malformed.',
    'ERROR_WRONG_PASSWORD': 'Password is wrong.',
    'ERROR_USER_NOT_FOUND':
        'No user corresponding to the given email address, or the user has been deleted.',
    'ERROR_USER_DISABLED':
        'User has been disabled (for example, in the Firebase console)',
    'ERROR_TOO_MANY_REQUESTS': 'Too many attempts to sign in as this user.',
    'ERROR_OPERATION_NOT_ALLOWED': 'Email & Password accounts are not enabled.',
  };
}
