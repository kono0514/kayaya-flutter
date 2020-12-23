import 'package:flutter/material.dart';

import '../../../../core/widgets/spinner_button.dart';

class SignInButton extends SpinnerButton {
  SignInButton({
    Key key,
    Widget icon,
    Widget label,
    bool loading = false,
    bool disabled = false,
    VoidCallback onPressed,
    Color color,
    Color spinnerColor,
  }) : super(
          key: key,
          icon: icon,
          label: label,
          loading: loading,
          disabled: disabled,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: color,
            onSurface: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ).copyWith(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return color.withOpacity(0.2);
                }
                return color;
              },
            ),
          ),
          spinnerColor: spinnerColor,
          childBuilder: (context, spinner) {
            return Row(
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
