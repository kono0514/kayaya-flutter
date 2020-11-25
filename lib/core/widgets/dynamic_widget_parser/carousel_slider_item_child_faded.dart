import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:kayaya_flutter/core/widgets/easing_linear_gradient.dart';

class CarouselSliderItemFadedChildWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: EasingLinearGradient.generate(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          fromColor: Color.fromRGBO(0, 0, 0, 0.85),
          toColor: Color.fromRGBO(0, 0, 0, 0),
        ),
        border: Border.all(width: 0, color: Colors.transparent),
      ),
      child: map["child"] != null
          ? DynamicWidgetBuilder.buildFromMap(
              map["child"], buildContext, listener)
          : null,
    );
  }

  @override
  String get widgetName => "CarouselSliderItemFadedChild";
}
