import 'dart:math';

import 'package:flutter/material.dart';

class SliverButton extends StatefulWidget {
  final Icon icon;
  final Text text;
  final Color backgroundColor;
  final Color color;
  final bool collapsible;
  final VoidCallback onPressed;

  const SliverButton({
    Key key,
    this.icon,
    @required this.text,
    this.collapsible = true,
    this.backgroundColor,
    this.color,
    @required this.onPressed,
  }) : super(key: key);

  @override
  _SliverButtonState createState() => _SliverButtonState();
}

class _SliverButtonState extends State<SliverButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _collapseAnimation;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _collapseAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)));
    _fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final FlexibleSpaceBarSettings settings = context
          .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
      assert(
        settings != null,
        'A SliverButton must be wrapped in the widget returned by FlexibleSpaceBar.createSettings().',
      );
      final double deltaExtent = settings.maxExtent - settings.minExtent;

      // 0.0 -> Expanded
      // 1.0 -> Collapsed to toolbar
      final double t =
          (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
              .clamp(0.0, 1.0) as double;

      if (widget.collapsible) {
        if (t == 0.0) {
          _controller.reverse().orCancel;
        } else if (t == 1.0) {
          _controller.forward().orCancel;
        }
      }

      return ButtonTheme(
        minWidth: 36.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: widget.backgroundColor ??
                (_isDark ? Colors.grey[800] : Colors.white),
            onPrimary: widget.color ?? (_isDark ? Colors.white : Colors.black),
          ),
          onPressed: widget.onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.icon != null) widget.icon,
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => FadeTransition(
                  opacity: _fadeAnimation,
                  child: Align(
                    heightFactor: 1.0,
                    widthFactor: max(_collapseAnimation.value, 0.0),
                    child: Padding(
                      padding: widget.icon != null
                          ? const EdgeInsets.only(left: 8.0)
                          : EdgeInsets.zero,
                      child: widget.text,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
