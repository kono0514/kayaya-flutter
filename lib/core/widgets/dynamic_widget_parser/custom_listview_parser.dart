import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'utils.dart';

class CustomListViewWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    var scrollDirection = Axis.vertical;
    if (map.containsKey("scrollDirection") &&
        "horizontal" == map["scrollDirection"]) {
      scrollDirection = Axis.horizontal;
    }

    final bool reverse = map.containsKey("reverse") && map['reverse'] as bool;
    final bool shrinkWrap =
        map.containsKey("shrinkWrap") && map["shrinkWrap"] as bool;
    final double cacheExtent =
        map.containsKey("cacheExtent") ? map["cacheExtent"] as double : 0.0;
    final EdgeInsetsGeometry padding = map.containsKey('padding')
        ? parseEdgeInsetsGeometry(map['padding'] as String)
        : null;
    final double itemExtent =
        map.containsKey("itemExtent") ? map["itemExtent"] as double : null;
    final children = DynamicWidgetBuilder.buildWidgets(
        map['children'] as List, buildContext, listener);
    final ScrollPhysics scrollPhysics = map.containsKey("scrollPhysics")
        ? parseScrollPhysics(map['scrollPhysics'] as String)
        : null;

    return ListViewWidget(
      params: ListViewParams(
        scrollDirection: scrollDirection,
        reverse: reverse,
        shrinkWrap: shrinkWrap,
        cacheExtent: cacheExtent,
        padding: padding,
        itemExtent: itemExtent,
        children: children,
        scrollPhysics: scrollPhysics,
      ),
    );
  }

  @override
  String get widgetName => "CustomListView";
}

class ListViewWidget extends StatefulWidget {
  final ListViewParams params;

  const ListViewWidget({@required this.params});

  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  final _items = <Widget>[];

  @override
  void initState() {
    super.initState();
    if (widget.params.children != null) {
      _items.addAll(widget.params.children);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: widget.params.scrollDirection,
      reverse: widget.params.reverse,
      shrinkWrap: widget.params.shrinkWrap,
      cacheExtent: widget.params.cacheExtent,
      padding: widget.params.padding,
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return _items[index];
      },
      physics: widget.params.scrollPhysics,
    );
  }
}

class ListViewParams {
  Axis scrollDirection;
  bool reverse;
  bool shrinkWrap;
  double cacheExtent;
  EdgeInsetsGeometry padding;
  double itemExtent;
  List<Widget> children;
  ScrollPhysics scrollPhysics;

  ListViewParams({
    @required this.scrollDirection,
    @required this.reverse,
    @required this.shrinkWrap,
    @required this.cacheExtent,
    @required this.padding,
    @required this.itemExtent,
    @required this.children,
    @required this.scrollPhysics,
  });
}
