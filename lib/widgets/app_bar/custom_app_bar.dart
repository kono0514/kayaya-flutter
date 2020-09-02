import 'package:flutter/material.dart';

class CustomStaticAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;

  const CustomStaticAppBar(
      {Key key, this.actions = const [], @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;

    return AppBar(
      elevation: 0.0,
      flexibleSpace: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 16,
                bottom: 16,
              ),
              child: DefaultTextStyle(
                style: titleStyle.copyWith(fontSize: titleStyle.fontSize * 1.5),
                child: title,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                height: kToolbarHeight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: actions,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(44.0 + 52.0);
}
