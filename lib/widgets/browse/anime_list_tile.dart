import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/cubit/browse_filter_cubit.dart';
import 'package:kayaya_flutter/hex_color.dart';
import 'package:kayaya_flutter/widgets/rounded_cached_network_image.dart';

class AnimeListTile extends StatelessWidget {
  final BrowseAnimes$Query$Animes$Data anime;
  final VoidCallback onPressed;

  const AnimeListTile({Key key, this.anime, @required this.onPressed})
      : super(key: key);

  List<Widget> _buildGenres(BuildContext context) {
    List<Widget> _items = [];
    for (var i = 0; i < min(5, this.anime.genres.length); i++) {
      final genre = this.anime.genres[i];
      _items.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ButtonTheme(
            minWidth: 50,
            height: 26,
            child: FlatButton(
              onPressed: () {
                final _filterCubit =
                    BlocProvider.of<BrowseFilterCubit>(context);
                _filterCubit.changeFilter(
                    _filterCubit.state.filter.copyWith(genres: [genre.id]));
              },
              child: Text(
                genre.name,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
            ),
          ),
        ),
      );
    }
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            RoundedCachedNetworkImage(
              url: anime.coverImage.large,
              width: 90,
              height: 135,
              placeholderColor: HexColor(
                anime.coverColor ?? "#000000",
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      anime.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headline6,
                    ),
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          anime.animeType == AnimeType.movie
                              ? 'Кино'
                              : 'Цуврал',
                          style: textTheme.caption.copyWith(fontSize: 13),
                        ),
                        SizedBox(width: 12),
                        if (anime.rating != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14.0,
                              ),
                              SizedBox(width: 2),
                              Text(
                                '${anime.rating / 10}',
                                style: textTheme.caption.copyWith(fontSize: 13),
                              ),
                            ],
                          )
                      ],
                    ),
                    SizedBox(height: 12),
                    ScrollConfiguration(
                      behavior: const ScrollBehavior()
                        ..buildViewportChrome(
                            context, null, AxisDirection.right),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _buildGenres(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
