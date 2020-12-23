import 'package:auto_size_text/auto_size_text.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/material.dart';

class AutoSizeTextWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    return AutoSizeText(
      map["data"] as String,
      maxLines: map["maxLines"] as int ?? 2,
      overflow: TextOverflow.ellipsis,
      textAlign: parseTextAlign(map["textAlign"] as String),
    );
  }

  @override
  String get widgetName => "AutoSizeText";
}
