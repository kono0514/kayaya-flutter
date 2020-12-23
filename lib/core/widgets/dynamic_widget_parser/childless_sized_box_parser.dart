import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';

class ChildlessSizedBoxWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    return SizedBox(
      width: map["width"] as double,
      height: map["height"] as double,
    );
  }

  @override
  String get widgetName => "ChildlessSizedBox";
}
