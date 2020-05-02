import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_raied_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required assetName,
    @required String text,
    Color bgColor,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(assetName),
                Text(
                  text,
                  style: TextStyle(color: textColor),
                ),
                Opacity(opacity: 0.0, child: Image.asset(assetName)),
              ],
            ),
            color: bgColor,
            onPressed: onPressed);
}
