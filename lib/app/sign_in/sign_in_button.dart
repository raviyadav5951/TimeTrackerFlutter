import 'package:flutter/widgets.dart';
import 'package:time_tracker/common_widgets/custom_raied_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
            child: (Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 15.0,
              ),
            )),
            color: bgColor,
            onPressed: onPressed);
}
