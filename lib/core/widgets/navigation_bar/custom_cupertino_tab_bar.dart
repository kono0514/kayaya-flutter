import 'package:flutter/cupertino.dart';

/*
  TODO: Snap behaviour not implemented
*/

class CustomCupertinoTabBar extends CupertinoTabBar {
  final ValueNotifier<double> valueListenable;

  const CustomCupertinoTabBar({
    Key key,
    @required List<BottomNavigationBarItem> items,
    ValueChanged<int> onTap,
    int currentIndex = 0,
    Color backgroundColor,
    Color activeColor,
    Color inactiveColor = CupertinoColors.inactiveGray,
    double iconSize = 30.0,
    Border border = const Border(
      top: BorderSide(
        color: CupertinoDynamicColor.withBrightness(
          color: Color(0x4C000000),
          darkColor: Color(0x29000000),
        ),
        width: 0.0, // One physical pixel.
      ),
    ),
    @required this.valueListenable,
  }) : super(
          items: items,
          onTap: onTap,
          currentIndex: currentIndex,
          backgroundColor: backgroundColor,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          iconSize: iconSize,
          border: border,
        );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: valueListenable,
      builder: (context, value, child) => Align(
        heightFactor: value,
        alignment: const Alignment(0, -1),
        child: super.build(context),
      ),
    );
  }

  @override
  CupertinoTabBar copyWith({
    Key key,
    List<BottomNavigationBarItem> items,
    Color backgroundColor,
    Color activeColor,
    Color inactiveColor,
    double iconSize,
    Border border,
    int currentIndex,
    ValueChanged<int> onTap,
    ValueNotifier<double> valueListenable,
  }) {
    return CustomCupertinoTabBar(
      key: key ?? this.key,
      items: items ?? this.items,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      iconSize: iconSize ?? this.iconSize,
      border: border ?? this.border,
      currentIndex: currentIndex ?? this.currentIndex,
      onTap: onTap ?? this.onTap,
      valueListenable: valueListenable ?? this.valueListenable,
    );
  }
}
