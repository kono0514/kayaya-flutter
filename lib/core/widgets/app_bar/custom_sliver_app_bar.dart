import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final Widget title;
  final List<Widget> actions;

  const CustomSliverAppBar(
      {Key key, this.actions = const [], @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 44.0 + 52.0,
      pinned: true,
      flexibleSpace: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          FlexibleSpaceBar(
            title: title,
            titlePadding: EdgeInsetsDirectional.only(
              start: 16,
              bottom: 16,
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
}
