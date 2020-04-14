import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton(
      {this.child,
      this.color,
      this.borderRadius: 4.0,
      this.buttonHeight: 50.0,
      this.onPressed});

  final Widget child;
  final double borderRadius;
  final VoidCallback onPressed;
  final Color color;
  final double buttonHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: RaisedButton(
        onPressed: () {},
        child: this.child,
        color: this.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
    );
  }
}
