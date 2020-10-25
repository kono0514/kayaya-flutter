import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';
import 'package:kayaya_flutter/routes.dart';
import 'package:kayaya_flutter/widgets/app_bar/custom_sliver_app_bar.dart';
import 'package:kayaya_flutter/widgets/dynamic_widget_parser/auto_size_text_parser.dart';
import 'package:kayaya_flutter/widgets/dynamic_widget_parser/carousel_slider_item_child_faded.dart';
import 'package:kayaya_flutter/widgets/dynamic_widget_parser/carousel_slider_parser.dart';
import 'package:kayaya_flutter/widgets/dynamic_widget_parser/childless_sized_box_parser.dart';
import 'package:kayaya_flutter/widgets/dynamic_widget_parser/custom_listview_parser.dart';
import 'package:kayaya_flutter/widgets/dynamic_widget_parser/rounded_cached_network_image_parser.dart';
import 'package:kayaya_flutter/widgets/dynamic_widget_parser/scale_down_on_tap_parser.dart';

class FeaturedPage extends StatefulWidget {
  final ScrollController scrollController;

  const FeaturedPage({Key key, this.scrollController}) : super(key: key);

  @override
  _FeaturedPageState createState() => _FeaturedPageState();
}

class _FeaturedPageState extends State<FeaturedPage> {
  Future<Widget> _future;

  @override
  void initState() {
    super.initState();
    DynamicWidgetBuilder.addParser(AutoSizeTextWidgetParser());
    DynamicWidgetBuilder.addParser(ChildlessSizedBoxWidgetParser());
    DynamicWidgetBuilder.addParser(RoundedCachedNetworkImageWidgetParser());
    DynamicWidgetBuilder.addParser(CustomListViewWidgetParser());
    DynamicWidgetBuilder.addParser(CarouselSliderWidgetParser());
    DynamicWidgetBuilder.addParser(CarouselSliderItemFadedChildWidgetParser());
    DynamicWidgetBuilder.addParser(ScaleDownOnTapWidgetParser());
    _future = _buildWidget(context);
  }

  Future<void> _refreshData() async {
    setState(() {
      _future = _buildWidget(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: NestedScrollView(
        controller: widget.scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CustomSliverAppBar(
              title: Text(S.of(context).tabs_discover),
            ),
          ];
        },
        // body: CarouselSlider(
        //   options: CarouselOptions(height: 200.0),
        //   items: [
        //     RoundedCachedNetworkImage(
        //       childClipBehavior: Clip.hardEdge,
        //       url:
        //           'https://s4.anilist.co/file/anilistcdn/media/anime/banner/21-wf37VakJmZqs.jpg',
        //       child: Align(
        //         alignment: Alignment.bottomLeft,
        //         child: Container(
        //           width: double.infinity,
        //           decoration: BoxDecoration(
        //             gradient: EasingLinearGradient.generate(
        //               begin: Alignment.bottomCenter,
        //               end: Alignment.topCenter,
        //               fromColor: Color.fromRGBO(0, 0, 0, 0.8),
        //               toColor: Color.fromRGBO(0, 0, 0, 0),
        //             ),
        //             border: Border.all(width: 0, color: Colors.transparent),
        //           ),
        //           child: Padding(
        //             padding: const EdgeInsets.only(
        //               left: 16.0,
        //               right: 16.0,
        //               bottom: 8.0,
        //               top: 40.0,
        //             ),
        //             child: Text(
        //               'One Piece',
        //               style: TextStyle(fontSize: 20.0),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.error.toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                    RaisedButton(
                      onPressed: _refreshData,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refreshData,
              child: snapshot.data,
            );
          },
        ),
      ),
    );
  }

  Future<Widget> _buildWidget(BuildContext context) async {
    final repository = RepositoryProvider.of<AniimRepository>(context);
    final featuredString = await repository.fetchFeatured();

    return DynamicWidgetBuilder.build(
        featuredString, context, new DefaultClickListener(context: context));
  }
}

class DefaultClickListener implements ClickListener {
  BuildContext context;

  DefaultClickListener({@required this.context});

  @override
  void onClicked(String event) {
    print("Receive click event: " + event);
    if (event.trim().isEmpty) return;

    final uri = Uri.parse(event.trim());
    final route = Routes.fromURI(uri);

    if (route != null) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).push(route);
    }
  }
}
