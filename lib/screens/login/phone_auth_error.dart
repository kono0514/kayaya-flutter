import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kayaya_flutter/screens/login/firebase_auth_exception_extension.dart';

class FirebaseAuthError extends StatelessWidget {
  final FirebaseAuthException exception;

  const FirebaseAuthError(this.exception, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.red,
        ),
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                Icons.error,
                size: 18,
                color: Colors.red.shade400,
              ),
            ),
          ),
          TextSpan(
            text: exception.shortMessage,
          ),
        ],
      ),
    );
  }
}
