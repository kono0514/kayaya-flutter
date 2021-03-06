import 'package:flutter/material.dart';

class ColoredTabBar extends StatelessWidget implements PreferredSizeWidget {
  const ColoredTabBar({this.color, this.tabBar});

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: Material(
          type: MaterialType.transparency,
          child: Align(
            alignment: Alignment.centerLeft,
            child: tabBar,
          ),
        ),
      );
}
