import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/cubit/anime_details/anime_details_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoTabViewItem extends StatefulWidget {
  final Key tabKey;
  final ListItemAnimeMixin anime;

  const InfoTabViewItem({Key key, this.tabKey, this.anime}) : super(key: key);

  @override
  _InfoTabViewItemState createState() => _InfoTabViewItemState();
}

class _InfoTabViewItemState extends State<InfoTabViewItem>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollViewInnerScrollPositionKeyWidget(
      widget.tabKey,
      CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: BlocBuilder<AnimeDetailsCubit, AnimeDetailsState>(
              builder: (context, state) {
                if (state is AnimeDetailsError) {
                  return Center(
                    child: Text(state.exception.toString()),
                  );
                }

                if (state is AnimeDetailsLoaded) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 30),
                    child: Builder(
                      builder: (context) {
                        final items = <Widget>[];
                        items.addAll([
                          Text(
                            'Genres:',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.anime.genres
                                .map((e) => e.name.mn)
                                .join(', '),
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ]);

                        items.addAll([
                          SizedBox(height: 30),
                          Text(
                            'Агуулга:',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(height: 10),
                          Html(
                            data: state.details.description.mn,
                            style: {
                              'body': Style.fromTextStyle(
                                      Theme.of(context).textTheme.caption)
                                  .merge(Style(margin: EdgeInsets.zero)),
                            },
                          ),
                        ]);

                        if (state.details.anilist.trailer?.site == 'youtube' &&
                            state.details.anilist.trailer?.thumbnail != null) {
                          items.addAll([
                            SizedBox(height: 30),
                            Text(
                              'Trailer:',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () async {
                                final url =
                                    'https://youtube.com/watch?v=${state.details.anilist.trailer.id}';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: CachedNetworkImage(
                                      imageUrl: state
                                          .details.anilist.trailer.thumbnail,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.black54, // border color
                                      border: Border.all(
                                          width: 1, color: Colors.white),
                                      shape: BoxShape.circle,
                                    ),
                                    width: 54.0,
                                    height: 54.0,
                                    child: Icon(
                                      Icons.play_arrow,
                                      size: 36.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: items,
                        );
                      },
                    ),
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}