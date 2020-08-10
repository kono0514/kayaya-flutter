import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/*
  TODO: Snap behaviour not implemented
*/

class ScrollBottomNavigationBar extends StatelessWidget {
  final ValueNotifier<double> heightNotifier;
  final ValueNotifier<double> snapNotifier;
  final Widget child;
  final _kTabBarHeight = 50.0;

  ScrollBottomNavigationBar({
    Key key,
    @required this.heightNotifier,
    @required this.snapNotifier,
    @required this.child,
  })  : assert(heightNotifier != null),
        assert(snapNotifier != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double _delta = 0.0, _oldOffset = 0.0;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is UserScrollNotification) {
          if (notification.direction == ScrollDirection.idle) {
            if ([0.0, 1.0].contains(1.0 - (_delta / _kTabBarHeight))) {
              return true;
            }

            final offset = (1.0 - (_delta / _kTabBarHeight)).round() == 1
                ? -_delta
                : _kTabBarHeight - _delta;

            snapNotifier.value = offset;
          }
          return null;
        }

        ScrollMetrics position = notification.metrics;
        double pixels = notification.metrics.pixels;
        _delta = (_delta + pixels - _oldOffset).clamp(0.0, _kTabBarHeight);
        _oldOffset = pixels;

        if (position.axisDirection == AxisDirection.down &&
            position.extentAfter == 0.0) {
          if (heightNotifier.value == 0.0) return null;
          heightNotifier.value = 0.0;
          return null;
        }

        if (position.axisDirection == AxisDirection.up &&
            position.extentBefore == 0.0) {
          if (heightNotifier.value == 1.0) return null;
          heightNotifier.value = 1.0;
          return null;
        }

        if ((_delta == 0.0 && heightNotifier.value == 0.0) ||
            (_delta == _kTabBarHeight && heightNotifier.value == 1.0))
          return null;

        heightNotifier.value = 1.0 - (_delta / _kTabBarHeight);
      },
      child: child,
    );
  }
}
