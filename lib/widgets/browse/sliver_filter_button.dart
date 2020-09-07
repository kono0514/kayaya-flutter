import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/cubit/browse_filter_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/widgets/browse/filter_dialog.dart';

class SliverFilterButton extends StatefulWidget {
  @override
  _SliverFilterButtonState createState() => _SliverFilterButtonState();
}

class _SliverFilterButtonState extends State<SliverFilterButton>
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
        'A SliverFilterButton must be wrapped in the widget returned by FlexibleSpaceBar.createSettings().',
      );
      final double deltaExtent = settings.maxExtent - settings.minExtent;

      // 0.0 -> Expanded
      // 1.0 -> Collapsed to toolbar
      final double t =
          (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
              .clamp(0.0, 1.0) as double;
      if (t == 0.0) {
        _controller.reverse().orCancel;
      } else if (t == 1.0) {
        _controller.forward().orCancel;
      }

      return BlocBuilder<BrowseFilterCubit, BrowseFilterState>(
        builder: (context, state) {
          final _hasFilter = state is BrowseFilterModified;

          return ButtonTheme(
            minWidth: 36.0,
            child: OutlineButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.tune,
                    color: _hasFilter
                        ? _isDark ? Colors.lightBlue : Colors.deepPurple
                        : null,
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => FadeTransition(
                      opacity: _fadeAnimation,
                      child: Align(
                        alignment: Alignment.center,
                        heightFactor: 1.0,
                        widthFactor: max(_collapseAnimation.value, 0.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            S.current.common_filter.toUpperCase(),
                            style: TextStyle(
                              color: _hasFilter
                                  ? _isDark
                                      ? Colors.lightBlue
                                      : Colors.deepPurple
                                  : null,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                BuildContext mainContext = context;
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => FilterDialog(
                    mainContext: mainContext,
                  ),
                );
              },
              highlightedBorderColor: Colors.transparent,
            ),
          );
        },
      );
    });
  }
}