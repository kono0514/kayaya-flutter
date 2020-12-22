import 'package:flutter/material.dart'
    hide NestedScrollView, NestedScrollViewState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/widgets/spinner_button.dart';
import '../../../../locale/generated/l10n.dart';
import '../../../../router.dart';
import '../../../domain/entities/anime.dart';
import '../../../domain/entities/release.dart';
import '../../player/widget/source_chooser_dialog.dart';
import '../bloc/episodes_bloc.dart';
import '../cubit/details_cubit.dart';
import '../widget/detail_view.dart';
import '../widget/tab_info.dart';
import '../widget/tab_related.dart';

// (Implemented workaround with extended_nested_scroll_view) TODO: https://github.com/flutter/flutter/issues/40740

class MoviePage extends StatelessWidget {
  final Anime anime;
  final bool isMinimal;

  MoviePage(this.anime, {this.isMinimal = false});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = GetIt.I<DetailsCubit>();
            if (isMinimal) {
              return cubit..loadDetailsFull(anime.id);
            } else {
              return cubit..loadDetails(anime.id);
            }
          },
        ),
        BlocProvider(
          create: (context) =>
              GetIt.I<EpisodesBloc>()..add(EpisodesFetched(anime.id)),
        ),
      ],
      child: BlocConsumer<DetailsCubit, DetailsState>(
        listener: (context, state) async {
          if (state is DetailsError) {
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(TR.of(context).error_fetch),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(TR.of(context).reserved_word_return),
                  ),
                ],
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return DetailView(
            anime: (state is DetailsLoaded && state.hasListData)
                ? state.animeListData
                : anime,
            actions: [
              Expanded(child: _MoviePlayButton(anime: anime)),
            ],
            tabs: [TR.of(context).info, TR.of(context).related],
            tabViews: [
              InfoTabViewItem(tabKey: Key('Tab0')),
              RelatedTabViewItem(tabKey: Key('Tab1'), id: anime.id),
            ],
          );
        },
      ),
    );
  }
}

class _MoviePlayButton extends StatelessWidget {
  final Anime anime;

  const _MoviePlayButton({
    Key key,
    @required this.anime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EpisodesBloc, EpisodesState>(
      builder: (context, state) {
        Text label = Text('...');
        Icon icon;
        Function onPressed = () {};
        bool loading = true;

        if (state is EpisodesLoaded) {
          loading = false;
          icon = Icon(Icons.play_circle_outline);
          label = Text(TR.of(context).play.toUpperCase());
          onPressed = () async {
            if (state.episodes.elements.length == 0) return;

            final chosenRelease = await showDialog<Release>(
              context: context,
              builder: (context) => SourceChooserDialog(
                releases: state.episodes.elements.first.releases,
              ),
            );

            if (chosenRelease != null) {
              Navigator.of(context, rootNavigator: true).pushNamed(
                Routes.moviePlayer,
                arguments: MoviePlayerArguments(
                  anime: anime,
                  release: chosenRelease,
                ),
              );
            }
          };
        } else if (state is EpisodesInitial) {
          loading = true;
        } else {
          loading = false;
          icon = Icon(Icons.warning);
          label = Text('Not available');
        }

        return SizedBox(
          height: 50,
          child: SpinnerButton(
            label: label,
            loading: loading,
            icon: icon,
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
