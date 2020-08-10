import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kayaya_flutter/widgets/app_bar/custom_sliver_app_bar.dart';
import 'package:kayaya_flutter/widgets/navigation_bar/navigation_tab.dart';

class FeaturedPage extends StatefulWidget {
  final ScrollController scrollController;

  const FeaturedPage({Key key, this.scrollController}) : super(key: key);

  @override
  _FeaturedPageState createState() => _FeaturedPageState();
}

class _FeaturedPageState extends State<FeaturedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: widget.scrollController,
        slivers: <Widget>[
          CustomSliverAppBar(
            title: Text(
              'Онцлох',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SliverFillRemaining(
            child: Center(
              child: Text(
                'ya',
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
