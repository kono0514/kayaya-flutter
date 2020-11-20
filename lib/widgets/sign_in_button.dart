import 'package:flutter/material.dart';
import 'package:kayaya_flutter/widgets/spinner_button.dart';

class SignInButton extends SpinnerButton {
  SignInButton({
    Key key,
    Widget icon,
    Widget label,
    bool loading,
    bool disabled,
    Function onPressed,
    Color color,
    Color spinnerColor,
  }) : super(
          key: key,
          icon: icon,
          label: label,
          loading: loading,
          disabled: disabled,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(primary: color),
          spinnerColor: spinnerColor,
          childBuilder: (context, spinner) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                icon,
                Expanded(
                  child: Center(
                    child: loading ? spinner : label,
                  ),
                ),
              ],
            );
          },
        );
}
