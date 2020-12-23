import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

Tuple2<List<Color>, List<double>> _generateEasingLinearGradient(
    Color fromColor, Color toColor) {
  // Ease-in-out
  final colorStopsCoordinates =
      _cubicCoordinates(0.42, 0, 0.58, 1, polySteps: 15);
  final colors = <Color>[];
  final stops = <double>[];

  for (final coor in colorStopsCoordinates) {
    Color mixedColor = _mix(fromColor, toColor, ratio: coor.y.toDouble());
    mixedColor = mixedColor
        .withOpacity(double.parse(mixedColor.opacity.toStringAsFixed(3)));
    colors.add(mixedColor);
    stops.add(coor.x.toDouble());
  }

  return Tuple2(colors, stops);
}

Color _mix(Color color1, Color color2, {double ratio = 0.5}) {
  final mixedColor = Color.fromRGBO(
    sqrt(pow(color1.red, 2) * (1 - ratio) + pow(color2.red, 2) * ratio)
        .round()
        .clamp(0, 255)
        .toInt(),
    sqrt(pow(color1.green, 2) * (1 - ratio) + pow(color2.green, 2) * ratio)
        .round()
        .clamp(0, 255)
        .toInt(),
    sqrt(pow(color1.blue, 2) * (1 - ratio) + pow(color2.blue, 2) * ratio)
        .round()
        .clamp(0, 255)
        .toInt(),
    1,
  );
  return mixedColor
      .withOpacity(color1.opacity + ratio * (color2.opacity - color1.opacity));
}

double _getBezier(double t, double n1, double n2) {
  return (1 - t) * (1 - t) * (1 - t) * 0 +
      3 * ((1 - t) * (1 - t)) * t * n1 +
      3 * (1 - t) * (t * t) * n2 +
      t * t * t * 1;
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
      colors: _generateEasingLinearGradient(fromColor, toColor).value1,
      stops: _generateEasingLinearGradient(fromColor, toColor).value2,
    );
  }
}
