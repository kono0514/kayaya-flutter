import 'package:flutter/material.dart';

typedef SpinnerButtonChildBuilder = Widget Function(
  BuildContext context,
  Widget spinner,
);

class SpinnerButton extends StatelessWidget {
  final Widget icon;
  final Widget label;
  final bool loading;
  final bool disabled;
  final VoidCallback onPressed;
  final ButtonStyle style;
  final Type buttonType;
  final SpinnerButtonChildBuilder childBuilder;
  final Color spinnerColor;

  const SpinnerButton({
    Key key,
    this.icon,
    this.label,
    this.loading = false,
    this.disabled = false,
    this.onPressed,
    this.style,
    this.buttonType = ElevatedButton,
    this.childBuilder,
    this.spinnerColor,
  })  : assert(buttonType == TextButton || buttonType == ElevatedButton),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _spinner = SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(spinnerColor ?? Colors.white),
      ),
    );

    Widget child;
    if (childBuilder != null) {
      child = childBuilder(context, _spinner);
    } else {
      if (loading) {
        child = _spinner;
      } else {
        child = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null)
              Padding(
                padding: EdgeInsets.only(right: label == null ? 0.0 : 8.0),
                child: icon,
              ),
            if (label != null) label,
          ],
        );
      }
    }

    var buttonStyle = style ?? const ButtonStyle();
    buttonStyle = buttonStyle.copyWith(
      animationDuration: Duration.zero,
      padding: buttonStyle.padding ??
          (icon == null
              ? null
              : MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.only(left: 12.0, right: 16.0),
                )),
      tapTargetSize: buttonStyle.tapTargetSize ?? MaterialTapTargetSize.padded,
    );

    Widget button;
    if (buttonType == TextButton) {
      button = TextButton(
        onPressed: disabled || loading ? null : onPressed,
        style: buttonStyle,
        child: child,
      );
    } else {
      button = ElevatedButton(
        onPressed: disabled || loading ? null : onPressed,
        style: buttonStyle,
        child: child,
      );
    }

    return button;
  }
}
