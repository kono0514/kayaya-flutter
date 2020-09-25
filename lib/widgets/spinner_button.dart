import 'package:flutter/material.dart';

class SpinnerButton extends StatelessWidget {
  final double fixedWidth;
  final Icon icon;
  final Widget label;
  final bool loading;
  final Function onPressed;

  const SpinnerButton(
      {Key key,
      this.fixedWidth,
      this.icon,
      this.label,
      this.loading = false,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (loading) {
      child = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: icon,
            ),
          label,
        ],
      );
    }

    final button = RaisedButton(
      onPressed: onPressed,
      child: child,
      padding: icon == null ? null : EdgeInsets.only(left: 12.0, right: 16.0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    if (fixedWidth != null) {
      return SizedBox(
        width: fixedWidth,
        child: button,
      );
    }

    return button;
  }
}
