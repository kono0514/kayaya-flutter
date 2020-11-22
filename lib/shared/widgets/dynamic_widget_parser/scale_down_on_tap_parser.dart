import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:kayaya_flutter/shared/widgets/scale_down_on_tap.dart';

class ScaleDownOnTapWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    return ScaleDownOnTap(
      child: DynamicWidgetBuilder.buildFromMap(
        map["child"],
        buildContext,
        listener,
      ),
    );
  }

  @override
  String get widgetName => "ScaleDownOnTap";
}
