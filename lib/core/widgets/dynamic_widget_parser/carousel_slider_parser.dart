import 'package:carousel_slider/carousel_slider.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kayaya_flutter/core/widgets/dynamic_widget_parser/utils.dart';

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
              height: map["height"],
              enlargeCenterPage: map["enlargeCenterPage"] ?? true,
              aspectRatio: map["aspectRatio"] ?? 16 / 9,
              autoPlay: false,
              // autoPlay: map["autoPlay"] ?? false,
              autoPlayAnimationDuration:
                  map["autoPlayAnimationDuration"] != null
                      ? Duration(milliseconds: map["autoPlayAnimationDuration"])
                      : const Duration(milliseconds: 800),
              autoPlayInterval: map["autoPlayInterval"] != null
                  ? Duration(milliseconds: map["autoPlayInterval"])
                  : const Duration(seconds: 4),
              disableCenter: map["disableCenter"] ?? false,
              enableInfiniteScroll: map["enableInfiniteScroll"] ?? true,
              enlargeStrategy: parseEnlargeStrategy(
                map["enlargeStrategy"],
                defaultValue: CenterPageEnlargeStrategy.scale,
              ),
              initialPage: map["initialPage"] ?? 0,
              pauseAutoPlayInFiniteScroll:
                  map["pauseAutoPlayInFiniteScroll"] ?? false,
              pauseAutoPlayOnManualNavigate:
                  map["pauseAutoPlayOnManualNavigate"] ?? true,
              pauseAutoPlayOnTouch: map["pauseAutoPlayOnTouch"] ?? true,
              reverse: map["reverse"] ?? false,
              scrollDirection: parseScrollDirection(
                map["scrollDirection"],
                defaultValue: Axis.horizontal,
              ),
              scrollPhysics: parseScrollPhysics(map["scrollPhysics"]),
              viewportFraction: map["viewportFraction"] ?? 0.8,
              onPageChanged: (index, reason) {
                if (map["showIndicator"] ?? false) {
                  setState(() {
                    _current = index;
                  });
                }
              }),
          items: DynamicWidgetBuilder.buildWidgets(
              map["items"], context, widget.listener),
        ),
        if (map["showIndicator"] ?? false)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map["items"].map<Widget>((item) {
              int index = map["items"].indexOf(item);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.only(
                    left: 3.0, right: 3.0, top: 16.0, bottom: 0.0),
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
