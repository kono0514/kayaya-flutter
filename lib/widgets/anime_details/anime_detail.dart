import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/cubit/anime_details/anime_details_cubit.dart';
import 'package:kayaya_flutter/hex_color.dart';
import 'package:kayaya_flutter/widgets/rating_bar.dart';
import 'package:kayaya_flutter/widgets/rounded_cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class AnimeDetail extends StatelessWidget {
  final ListItemAnimeMixin anime;
  final List<Widget> actions;

  const AnimeDetail({Key key, @required this.anime, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _buildPosterWidget(context),
        SizedBox(width: 20),
        Expanded(child: _buildInfoWidget(context)),
      ],
    );
  }

  Widget _buildPosterWidget(BuildContext context) {
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: <Widget>[
        RoundedCachedNetworkImage(
          url: anime.coverImage.large,
          width: 109,
          height: 163,
          placeholderColor: HexColor(
            anime.coverColor ?? "#000000",
          ),
          boxShadow: BoxShadow(
            blurRadius: 5.0,
            spreadRadius: 2.0,
            color: _isDark
                ? Colors.white.withOpacity(0.8)
                : Colors.grey[400].withOpacity(0.8),
          ),
        ),
        if (anime.rating != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RatingBar(
              rating: anime.rating,
              size: 16,
              color: _isDark ? Colors.yellow : Colors.yellow[800],
            ),
          ),
      ],
    );
  }

  Widget _buildInfoWidget(BuildContext context) {
    final separator = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text('•'),
    );
    TextTheme textTheme = Theme.of(context).textTheme;
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AutoSizeText(
          anime.name.mn,
          style: textTheme.headline4
              .apply(color: _isDark ? Colors.white : Colors.black),
          maxLines: 3,
        ),
        SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<AnimeDetailsCubit, AnimeDetailsState>(
              builder: (context, state) {
                if (state is AnimeDetailsInitial) {
                  return Shimmer.fromColors(
                    baseColor: _isDark ? Colors.grey[700] : Colors.grey[300],
                    highlightColor:
                        _isDark ? Colors.grey[500] : Colors.grey[100],
                    child: Row(
                      children: [
                        Container(width: 35, height: 5, color: Colors.white),
                        separator,
                        Container(width: 45, height: 5, color: Colors.white),
                        separator,
                        Container(width: 45, height: 5, color: Colors.white),
                      ],
                    ),
                  );
                }

                if (state is AnimeDetailsLoaded) {
                  final items = <Widget>[];

                  final year =
                      state.details.anilist.startDate?.year?.toString();
                  if (year != null) {
                    items.add(Text(year));
                  }

                  if (anime.animeType == AnimeType.series) {
                    final totalEpisodes =
                        state.details.anilist.episodes?.toString();
                    if (totalEpisodes != null) {
                      items.addAll([separator, Text('$totalEpisodes анги')]);
                    }
                  }

                  final duration = state.details.anilist.duration?.toString();
                  if (duration != null) {
                    items.addAll([separator, Text('$duration мин')]);
                  }

                  return Row(children: items);
                }

                return Row();
              },
            ),
          ],
        ),
        SizedBox(height: 12),
        if (actions != null)
          Row(
            children: actions,
          ),
      ],
    );
  }
}
