import 'package:flutter/material.dart';

class PlayerCircleButton extends StatelessWidget {
  final Widget child;

  const PlayerCircleButton({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      type: MaterialType.circle,
      color: Colors.transparent,
      child: child,
    );
  }
}
