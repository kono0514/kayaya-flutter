import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'glowless_scroll_behavior.dart';

Future<T> showCustomMaterialSheet<T>({
  @required BuildContext context,
  double closeProgressThreshold = 0.5,
  @required WidgetBuilder builder,
  Color backgroundColor,
  double elevation,
  ShapeBorder shape,
  Clip clipBehavior = Clip.none,
  Color barrierColor,
  bool bounce = false,
  AnimationController secondAnimation,
  Curve animationCurve,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  Duration duration = const Duration(milliseconds: 250),
  double height,
  WidgetBuilder labelBuilder,
}) async {
  assert(height == null || (height > 0 && height <= 1));
  final _shape = shape ??
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      );
  final _barrierColor = barrierColor ?? Colors.black.withOpacity(0.5);

  final result = await Navigator.of(context, rootNavigator: useRootNavigator)
      .push(ModalBottomSheetRoute<T>(
    closeProgressThreshold: closeProgressThreshold,
    secondAnimationController: secondAnimation,
    bounce: bounce,
    expanded: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    isDismissible: isDismissible,
    modalBarrierColor: _barrierColor,
    enableDrag: enableDrag,
    animationCurve: animationCurve,
    duration: duration,
    builder: (context) {
      final child = (labelBuilder != null)
          ? Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 3,
                  width: 18,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: DefaultTextStyle.merge(
                    style: Theme.of(context).textTheme.headline6,
                    child: labelBuilder(context),
                  ),
                ),
                const Divider(height: 1.3, thickness: 1.3),
                Expanded(child: builder(context)),
              ],
            )
          : builder(context);

      final bottomSheetTheme = Theme.of(context).bottomSheetTheme;
      final orientation = MediaQuery.of(context).orientation;
      final _width = orientation == Orientation.landscape
          ? MediaQuery.of(context).size.width * 0.65
          : MediaQuery.of(context).size.width;
      final _height =
          height == null ? null : MediaQuery.of(context).size.height * height;

      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              if (isDismissible)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: _width,
                  height: _height,
                  child: Material(
                    color: backgroundColor ??
                        bottomSheetTheme?.modalBackgroundColor ??
                        bottomSheetTheme?.backgroundColor,
                    elevation: elevation ?? bottomSheetTheme.elevation ?? 0.0,
                    shape: _shape ?? bottomSheetTheme.shape,
                    clipBehavior: clipBehavior,
                    child: ScrollConfiguration(
                      behavior: GlowlessScrollBehavior(),
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ));
  return result;
}
