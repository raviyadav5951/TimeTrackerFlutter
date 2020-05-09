import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_raied_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({@required String text, VoidCallback onPressed})
      : super(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          borderRadius: 4.0,
          buttonHeight: 44.0,
          onPressed: onPressed,
          color: Colors.indigo,
        );
}
