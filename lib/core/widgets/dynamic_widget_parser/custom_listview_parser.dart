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

    var reverse = map.containsKey("reverse") ? map['reverse'] : false;
    var shrinkWrap = map.containsKey("shrinkWrap") ? map["shrinkWrap"] : false;
    var cacheExtent = map.containsKey("cacheExtent") ? map["cacheExtent"] : 0.0;
    var padding = map.containsKey('padding')
        ? parseEdgeInsetsGeometry(map['padding'])
        : null;
    var itemExtent = map.containsKey("itemExtent") ? map["itemExtent"] : null;
    var children = DynamicWidgetBuilder.buildWidgets(
        map['children'], buildContext, listener);
    var scrollPhysics = map.containsKey("scrollPhysics")
        ? parseScrollPhysics(map['scrollPhysics'])
        : null;

    var params = new ListViewParams(scrollDirection, reverse, shrinkWrap,
        cacheExtent, padding, itemExtent, children, scrollPhysics);

    return new ListViewWidget(params);
  }

  @override
  String get widgetName => "CustomListView";
}

class ListViewWidget extends StatefulWidget {
  final ListViewParams _params;

  ListViewWidget(this._params);

  @override
  _ListViewWidgetState createState() => _ListViewWidgetState(_params);
}

class _ListViewWidgetState extends State<ListViewWidget> {
  ListViewParams _params;
  List<Widget> _items = [];

  _ListViewWidgetState(this._params) {
    if (_params.children != null) {
      _items.addAll(_params.children);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: _params.scrollDirection,
      reverse: _params.reverse,
      shrinkWrap: _params.shrinkWrap,
      cacheExtent: _params.cacheExtent,
      padding: _params.padding,
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return _items[index];
      },
      physics: _params.scrollPhysics,
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

  ListViewParams(
      this.scrollDirection,
      this.reverse,
      this.shrinkWrap,
      this.cacheExtent,
      this.padding,
      this.itemExtent,
      this.children,
      this.scrollPhysics);
}
