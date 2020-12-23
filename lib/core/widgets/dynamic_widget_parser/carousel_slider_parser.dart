import 'package:carousel_slider/carousel_slider.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'utils.dart';

class CarouselSliderWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    return CarouselSliderWithIndicator(
      map: map,
      // context: buildContext,
      listener: listener,
    );
  }

  @override
  String get widgetName => "CarouselSlider";
}

class CarouselSliderWithIndicator extends StatefulWidget {
  final Map<String, dynamic> map;
  // final BuildContext context;
  final ClickListener listener;

  const CarouselSliderWithIndicator({
    Key key,
    @required this.map,
    @required this.listener,
  }) : super(key: key);

  @override
  _CarouselSliderWithIndicatorState createState() =>
      _CarouselSliderWithIndicatorState();
}

class _CarouselSliderWithIndicatorState
    extends State<CarouselSliderWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final map = widget.map;

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              height: map["height"] as double,
              enlargeCenterPage: map["enlargeCenterPage"] as bool ?? true,
              aspectRatio: map["aspectRatio"] as double ?? 16 / 9,
              autoPlay: false,
              // autoPlay: map["autoPlay"] ?? false,
              autoPlayAnimationDuration:
                  map["autoPlayAnimationDuration"] != null
                      ? Duration(
                          milliseconds: map["autoPlayAnimationDuration"] as int)
                      : const Duration(milliseconds: 800),
              autoPlayInterval: map["autoPlayInterval"] != null
                  ? Duration(milliseconds: map["autoPlayInterval"] as int)
                  : const Duration(seconds: 4),
              disableCenter: map["disableCenter"] as bool ?? false,
              enableInfiniteScroll: map["enableInfiniteScroll"] as bool ?? true,
              enlargeStrategy: parseEnlargeStrategy(
                map["enlargeStrategy"] as String,
                defaultValue: CenterPageEnlargeStrategy.scale,
              ),
              initialPage: map["initialPage"] as int ?? 0,
              pauseAutoPlayInFiniteScroll:
                  map["pauseAutoPlayInFiniteScroll"] as bool ?? false,
              pauseAutoPlayOnManualNavigate:
                  map["pauseAutoPlayOnManualNavigate"] as bool ?? true,
              pauseAutoPlayOnTouch: map["pauseAutoPlayOnTouch"] as bool ?? true,
              reverse: map["reverse"] as bool ?? false,
              scrollDirection: parseScrollDirection(
                map["scrollDirection"] as String,
                defaultValue: Axis.horizontal,
              ),
              scrollPhysics: parseScrollPhysics(map["scrollPhysics"] as String),
              viewportFraction: map["viewportFraction"] as double ?? 0.8,
              onPageChanged: (index, reason) {
                if (map["showIndicator"] as bool ?? false) {
                  setState(() {
                    _current = index;
                  });
                }
              }),
          items: DynamicWidgetBuilder.buildWidgets(
              map["items"] as List, context, widget.listener),
        ),
        if (map["showIndicator"] as bool ?? false)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (map["items"] as List).map<Widget>((item) {
              final index = (map["items"] as List).indexOf(item);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.only(left: 3.0, right: 3.0, top: 16.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(0.9)
                      : Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(0.3),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
