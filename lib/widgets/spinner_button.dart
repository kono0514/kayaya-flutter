import 'package:flutter/material.dart';

class SpinnerButton extends StatelessWidget {
  final double fixedWidth;
  final Icon icon;
  final Widget label;
  final bool loading;
  final bool disabled;
  final Function onPressed;
  final ButtonStyle style;
  bool _isTextButton = false;

  SpinnerButton({
    Key key,
    this.fixedWidth,
    this.icon,
    this.label,
    this.loading = false,
    this.disabled = false,
    this.onPressed,
    this.style,
  }) : super(key: key);

  SpinnerButton.text({
    Key key,
    this.fixedWidth,
    this.icon,
    this.label,
    this.loading = false,
    this.disabled = false,
    this.onPressed,
    this.style,
  })  : _isTextButton = true,
        super(key: key);

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

    var buttonStyle = style ?? ButtonStyle();
    buttonStyle = buttonStyle.copyWith(
      padding: icon == null
          ? null
          : MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.only(left: 12.0, right: 16.0)),
      tapTargetSize: buttonStyle.tapTargetSize ?? MaterialTapTargetSize.padded,
    );

    var button;
    if (_isTextButton) {
      button = TextButton(
        onPressed: disabled || loading ? null : onPressed,
        child: child,
        style: buttonStyle,
      );
    } else {
      button = ElevatedButton(
        onPressed: disabled || loading ? null : onPressed,
        child: child,
        style: buttonStyle,
      );
    }

    if (fixedWidth != null) {
      return SizedBox(
        width: fixedWidth,
        child: button,
      );
    }

    return button;
  }
}
