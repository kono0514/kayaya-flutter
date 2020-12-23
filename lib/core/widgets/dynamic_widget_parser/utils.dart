import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';

ScrollPhysics parseScrollPhysics(String scrollPhysics) {
  if (scrollPhysics == 'AlwaysScrollableScrollPhysics') {
    return const AlwaysScrollableScrollPhysics();
  } else if (scrollPhysics == 'BouncingScrollPhysics') {
    return const BouncingScrollPhysics();
  } else if (scrollPhysics == 'ClampingScrollPhysics') {
    return const ClampingScrollPhysics();
  } else if (scrollPhysics == 'FixedExtentScrollPhysics') {
    return const FixedExtentScrollPhysics();
  } else if (scrollPhysics == 'NeverScrollableScrollPhysics') {
    return const NeverScrollableScrollPhysics();
  } else if (scrollPhysics == 'PageScrollPhysics') {
    return const PageScrollPhysics();
  } else if (scrollPhysics == 'RangeMaintainingScrollPhysics') {
    return const RangeMaintainingScrollPhysics();
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
