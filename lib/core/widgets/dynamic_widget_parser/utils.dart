import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';

ScrollPhysics parseScrollPhysics(String scrollPhysics) {
  if (scrollPhysics == 'AlwaysScrollableScrollPhysics') {
    return AlwaysScrollableScrollPhysics();
  } else if (scrollPhysics == 'BouncingScrollPhysics') {
    return BouncingScrollPhysics();
  } else if (scrollPhysics == 'ClampingScrollPhysics') {
    return ClampingScrollPhysics();
  } else if (scrollPhysics == 'FixedExtentScrollPhysics') {
    return FixedExtentScrollPhysics();
  } else if (scrollPhysics == 'NeverScrollableScrollPhysics') {
    return NeverScrollableScrollPhysics();
  } else if (scrollPhysics == 'PageScrollPhysics') {
    return PageScrollPhysics();
  } else if (scrollPhysics == 'RangeMaintainingScrollPhysics') {
    return RangeMaintainingScrollPhysics();
  }
  return null;
}

CenterPageEnlargeStrategy parseEnlargeStrategy(String enlargeStrategy,
    {CenterPageEnlargeStrategy defaultValue}) {
  return CenterPageEnlargeStrategy.values.firstWhere(
    (element) => element.toString() == enlargeStrategy,
    orElse: () => defaultValue,
  );
}

Axis parseScrollDirection(String scrollDirection, {Axis defaultValue}) {
  return Axis.values.firstWhere(
    (element) => element.toString() == scrollDirection,
    orElse: () => defaultValue,
  );
}

Clip parseClip(String clip, {Clip defaultValue}) {
  return Clip.values.firstWhere(
    (element) => element.toString() == clip,
    orElse: () => defaultValue,
  );
}
