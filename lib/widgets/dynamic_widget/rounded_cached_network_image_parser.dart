import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:kayaya_flutter/hex_color.dart';
import 'package:kayaya_flutter/widgets/dynamic_widget/utils.dart';
import 'package:kayaya_flutter/widgets/rounded_cached_network_image.dart';

class RoundedCachedNetworkImageWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    final widget = RoundedCachedNetworkImage(
      url: map["url"],
      width:
          map["height"] != null ? (map["height"] / 1.5).roundToDouble() : null,
      height: map["height"],
      adaptiveColor: map["adaptiveColor"] ?? false,
      placeholderColor: map["color"] != null
          ? HexColor(
              map["color"],
            )
          : null,
      childClipBehavior: parseClip(
        map["clip"],
        defaultValue: Clip.none,
      ),
      child: map["child"] != null
          ? DynamicWidgetBuilder.buildFromMap(
              map["child"], buildContext, listener)
          : null,
    );

    String clickEvent =
        map.containsKey("click_event") ? map['click_event'] : "";
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
