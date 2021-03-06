import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';

import '../scale_down_on_tap.dart';

class ScaleDownOnTapWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    return ScaleDownOnTap(
      child: DynamicWidgetBuilder.buildFromMap(
        map["child"] as Map<String, dynamic>,
        buildContext,
        listener,
      ),
    );
  }

  @override
  String get widgetName => "ScaleDownOnTap";
}
