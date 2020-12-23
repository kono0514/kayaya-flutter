import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/widgets.dart';

import '../../utils/hex_color.dart';
import '../rounded_cached_network_image.dart';
import 'utils.dart';

class RoundedCachedNetworkImageWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    final widget = RoundedCachedNetworkImage(
      url: map["url"] as String,
      width: map["height"] != null
          ? ((map["height"] as double) / 1.5).roundToDouble()
          : null,
      height: map["height"] as double,
      adaptiveColor: map["adaptiveColor"] as bool ?? false,
      placeholderColor:
          map["color"] != null ? HexColor(map["color"] as String) : null,
      childClipBehavior: parseClip(
        map["clip"] as String,
        defaultValue: Clip.none,
      ),
      child: map["child"] != null
          ? DynamicWidgetBuilder.buildFromMap(
              map["child"] as Map<String, dynamic>, buildContext, listener)
          : null,
    );

    final String clickEvent =
        map.containsKey("click_event") ? map['click_event'] as String : "";
    if (listener != null && (clickEvent != null && clickEvent.isNotEmpty)) {
      return GestureDetector(
        onTap: () {
          listener.onClicked(clickEvent);
        },
        child: widget,
      );
    }
    return widget;
  }

  @override
  String get widgetName => "RoundedCachedNetworkImage";
}
