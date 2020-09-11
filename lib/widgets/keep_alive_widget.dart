import 'package:flutter/material.dart';

class KeepAliveWidget extends StatefulWidget {
  final Widget child;

  const KeepAliveWidget({Key key, this.child}) : super(key: key);

  @override
  KeepAliveWidgetState createState() => KeepAliveWidgetState();
}

class KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
