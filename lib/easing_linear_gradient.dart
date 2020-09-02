import 'dart:math';
import 'package:flutter/material.dart';

List _generateEasingLinearGradient(Color fromColor, Color toColor) {
  // Ease-in-out
  final colorStopsCoordinates =
      _cubicCoordinates(0.42, 0, 0.58, 1, polySteps: 15);
  final colors = <Color>[];
  final stops = <double>[];

  colorStopsCoordinates.forEach((e) {
    Color mixedColor = _mix(fromColor, toColor, ratio: e.y);
    mixedColor = mixedColor
        .withOpacity(double.parse(mixedColor.opacity.toStringAsFixed(3)));
    colors.add(mixedColor);
    stops.add(e.x);
  });

  return [colors, stops];
}

Color _mix(Color color1, Color color2, {double ratio = 0.5}) {
  Color mixed = Color.fromRGBO(
    sqrt(pow(color1.red, 2) * (1 - ratio) + pow(color2.red, 2) * ratio)
        .round()
        .clamp(0, 255),
    sqrt(pow(color1.green, 2) * (1 - ratio) + pow(color2.green, 2) * ratio)
        .round()
        .clamp(0, 255),
    sqrt(pow(color1.blue, 2) * (1 - ratio) + pow(color2.blue, 2) * ratio)
        .round()
        .clamp(0, 255),
    1,
  );
  return mixed
      .withOpacity(color1.opacity + ratio * (color2.opacity - color1.opacity));
}

double _getBezier(double t, double n1, double n2) {
  return ((1 - t) * (1 - t) * (1 - t) * 0 +
      3 * ((1 - t) * (1 - t)) * t * n1 +
      3 * (1 - t) * (t * t) * n2 +
      t * t * t * 1);
}

List<Point> _cubicCoordinates(double x1, double y1, double x2, double y2,
    {int polySteps = 10}) {
  final increment = 1 / polySteps;
  final coordinates = <Point>[];
  for (double i = 0; i <= 1; i += increment) {
    coordinates.add(Point(
      double.parse(_getBezier(i, x1, x2).toStringAsFixed(10)),
      double.parse(_getBezier(i, y1, y2).toStringAsFixed(10)),
    ));
  }
  return coordinates;
}

class EasingLinearGradient {
  static LinearGradient generate({
    @required Color fromColor,
    @required Color toColor,
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
    TileMode tileMode = TileMode.clamp,
    GradientTransform transform,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      tileMode: tileMode,
      transform: transform,
      colors: _generateEasingLinearGradient(fromColor, toColor)[0],
      stops: _generateEasingLinearGradient(fromColor, toColor)[1],
    );
  }
}
