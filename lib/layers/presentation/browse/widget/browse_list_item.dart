import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/hex_color.dart';
import '../../../../core/widgets/rounded_cached_network_image.dart';
import '../../../../locale/generated/l10n.dart';
import '../../../domain/entities/anime.dart';
import '../cubit/browse_filter_cubit.dart';

class BrowseListItem extends StatelessWidget {
  final Anime anime;
  final VoidCallback onPressed;

  const BrowseListItem({Key key, this.anime, @required this.onPressed})
      : super(key: key);

  List<Widget> _buildGenres(BuildContext context) {
    final _isDark = Theme.of(context).brightness == Brightness.dark;

    List<Widget> _items = [];
    for (var i = 0; i < min(5, this.anime.genres.length); i++) {
      final genre = this.anime.genres[i];
      _items.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ButtonTheme(
            minWidth: 50,
            height: 26,
            child: TextButton(
              onPressed: () {
                final _filterCubit = context.read<BrowseFilterCubit>();
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
              style: TextButton.styleFrom(
                backgroundColor:
                    _isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                primary: _isDark ? Colors.white : Colors.black87,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size(60, 26),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
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
              url: anime.coverImage,
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
                          anime.isMovie
                              ? TR.of(context).movie
                              : TR.of(context).series,
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