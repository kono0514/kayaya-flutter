import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/repository.dart';
import 'package:kayaya_flutter/routes.dart';
import 'package:kayaya_flutter/widgets/app_bar/custom_sliver_app_bar.dart';
import 'package:kayaya_flutter/widgets/dynamic_widget/auto_size_text_parser.dart';
import 'package:kayaya_flutter/widgets/dynamic_widget/carousel_slider_parser.dart';
import 'package:kayaya_flutter/widgets/dynamic_widget/childless_sized_box_parser.dart';
import 'package:kayaya_flutter/widgets/dynamic_widget/custom_listview_parser.dart';
import 'package:kayaya_flutter/widgets/dynamic_widget/rounded_cached_network_image_parser.dart';
import 'package:kayaya_flutter/widgets/launchers.dart';

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
              title: Text(S.current.tabs_discover),
            ),
          ];
        },
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              print('Error');
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
    print(featuredString);

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

    if (uri.scheme == 'route') {
      if (uri.host == 'series' || uri.host == 'movie') {
        // At minimum, id is needed
        if (uri.queryParameters.containsKey('id')) {
          launchMediaPage(
            context,
            MediaArguments(
              BrowseAnimes$Query$Animes$Data.fromJson(
                {
                  'id': uri.queryParameters['id'],
                  'coverImage': {
                    'large': uri.queryParameters['image'],
                  },
                  'name': uri.queryParameters['name'],
                  'animeType': uri.host.toUpperCase()
                },
              ),
              isMinimal: true,
            ),
          );
        }
      }
    }
  }
}
