import 'package:flutter/material.dart'
    hide NestedScrollView, NestedScrollViewState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/bloc/anime_episodes_bloc.dart';
import 'package:kayaya_flutter/cubit/anime_details_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';
import 'package:kayaya_flutter/routes.dart';
import 'package:kayaya_flutter/widgets/anime_details/detail_view.dart';
import 'package:kayaya_flutter/widgets/anime_details/tab_info.dart';
import 'package:kayaya_flutter/widgets/anime_details/tab_related.dart';
import 'package:kayaya_flutter/utils/launchers.dart';
import 'package:kayaya_flutter/widgets/player/source_chooser_dialog.dart';
import 'package:kayaya_flutter/widgets/spinner_button.dart';

// (Implemented workaround with extended_nested_scroll_view) TODO: https://github.com/flutter/flutter/issues/40740

class MoviePage extends StatefulWidget {
  final MediaArguments argument;

  MoviePage(this.argument);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  AnimeItemFieldsMixin anime;
  AnimeDetailsCubit animeDetailsCubit;

  @override
  void initState() {
    super.initState();
    anime = widget.argument.anime;
    animeDetailsCubit =
        AnimeDetailsCubit(context.repository<AniimRepository>());

    /// Only minimal amount of data (ie. when using dynamic remote widget) was passed (id, poster, name)
    /// as opposed to the full listing item data (id, poster, name, banner, genres, etc...)
    /// So we should fetch the missing informations along with the details.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animeDetailsCubit.listen((state) {
        if (state is AnimeDetailsLoaded) {
          if (widget.argument.isMinimal) {
            setState(() {
              anime = state.listData;
            });
          }
        } else if (state is AnimeDetailsError) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(S.of(context).error_fetch),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).reserved_word_return),
                ),
              ],
            ),
          ).then((value) => Navigator.of(context).pop());
        }
      });
      if (widget.argument.isMinimal) {
        animeDetailsCubit.loadDetailsFull(anime.id);
      } else {
        animeDetailsCubit.loadDetails(anime.id);
      }
    });
  }

  @override
  void dispose() {
    animeDetailsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: animeDetailsCubit),
        BlocProvider(
          create: (context) =>
              AnimeEpisodesBloc(context.repository<AniimRepository>())
                ..add(AnimeEpisodesFetched(anime.id)),
        ),
      ],
      child: DetailView(
        tabs: [S.of(context).info, S.of(context).related],
        tabViews: [
          InfoTabViewItem(tabKey: Key('Tab0')),
          RelatedTabViewItem(tabKey: Key('Tab1'), id: anime.id),
        ],
        anime: anime,
        actions: [
          _buildPlayButton(),
        ],
      ),
    );
  }

  Widget _buildPlayButton() {
    return BlocBuilder<AnimeEpisodesBloc, AnimeEpisodesState>(
      builder: (context, state) {
        Text label;
        Icon icon;
        Function onPressed = () {};
        bool loading = true;

        if (state is AnimeEpisodesLoaded) {
          loading = false;
          icon = Icon(Icons.play_circle_outline);
          label = Text(S.of(context).play.toUpperCase());
          onPressed = () async {
            if (state.episodes.length == 0) return;

            final chosenRelease =
                await showDialog<GetAnimeEpisodes$Query$Episodes$Data$Releases>(
              context: context,
              builder: (context) => SourceChooserDialog(
                releases: state.episodes.first.releases,
              ),
            );

            if (chosenRelease != null) {
              launchPlayRelease(context, chosenRelease);
            }
          };
        } else if (state is AnimeEpisodesInitial) {
          loading = true;
        } else {
          loading = false;
          icon = Icon(Icons.warning);
          label = Text('Not available');
        }

        return SpinnerButton(
          label: label,
          loading: loading,
          icon: icon,
          onPressed: onPressed,
        );
      },
    );
  }
}
