import 'package:flutter/material.dart'
    hide NestedScrollView, NestedScrollViewState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart';
import 'package:kayaya_flutter/cubit/anime_details_cubit.dart';
import 'package:kayaya_flutter/cubit/anime_subscription_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';
import 'package:kayaya_flutter/widgets/anime_details/detail_view.dart';
import 'package:kayaya_flutter/widgets/anime_details/tab_episodes.dart';
import 'package:kayaya_flutter/widgets/anime_details/tab_info.dart';
import 'package:kayaya_flutter/widgets/anime_details/tab_related.dart';
import 'package:kayaya_flutter/widgets/spinner_button.dart';

// (Implemented workaround with extended_nested_scroll_view) TODO: https://github.com/flutter/flutter/issues/40740

class SeriesPage extends StatefulWidget {
  final AnimeItemFieldsMixin anime;
  final bool isMinimal;

  SeriesPage(this.anime, {this.isMinimal = false});

  @override
  _SeriesPageState createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  AnimeItemFieldsMixin anime;
  AnimeDetailsCubit animeDetailsCubit;

  @override
  void initState() {
    super.initState();
    anime = widget.anime;
    animeDetailsCubit = AnimeDetailsCubit(context.read<AniimRepository>());

    /// Only minimal amount of data was passed (id, poster, name)
    /// as opposed to the full listing item data (id, poster, name, banner, genres, etc...)
    /// So we should fetch other missing informations along with the details.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animeDetailsCubit.listen((state) {
        if (state is AnimeDetailsLoaded) {
          if (widget.isMinimal) {
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
                TextButton(
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
      if (widget.isMinimal) {
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
          create: (context) => AnimeSubscriptionCubit(
            context.read<AniimRepository>(),
          ),
        ),
      ],
      child: DetailView(
        anime: anime,
        actions: [
          SeriesSubscribeButton(id: anime.id),
        ],
        tabs: [
          S.of(context).info,
          S.of(context).episodes,
          S.of(context).related,
        ],
        tabViews: [
          InfoTabViewItem(tabKey: Key('Tab0')),
          EpisodesTabViewItem(tabKey: Key('Tab1'), id: anime.id, anime: anime),
          RelatedTabViewItem(tabKey: Key('Tab2'), id: anime.id),
        ],
      ),
    );
  }
}

class SeriesSubscribeButton extends StatelessWidget {
  final String id;

  const SeriesSubscribeButton({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AnimeDetailsCubit, AnimeDetailsState>(
      listener: (context, state) {
        if (state is AnimeDetailsLoaded) {
          context
              .read<AnimeSubscriptionCubit>()
              .assignData(id, state.details.subscribed);
        }
      },
      child: BlocConsumer<AnimeSubscriptionCubit, AnimeSubscriptionState>(
        listener: (context, state) {
          if (state is AnimeSubscriptionLoaded) {
            if (state.isDirty) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.subscribed
                        ? S.of(context).subscribe_success
                        : S.of(context).unsubscribe_success),
                  ),
                );
            }
          }
        },
        builder: (context, state) {
          Text label;
          Icon icon;
          Function onPressed = () {};
          bool loading = true;

          if (state is AnimeSubscriptionLoaded) {
            loading = false;
            label = Text((state.subscribed
                    ? S.of(context).unsubscribe
                    : S.of(context).subscribe)
                .toUpperCase());
            icon = Icon(state.subscribed
                ? Icons.notifications_active
                : Icons.notifications_none);
            onPressed = () {
              final bloc = context.read<AnimeSubscriptionCubit>();
              if (state.subscribed) {
                bloc.unsubscribe();
              } else {
                bloc.subscribe();
              }
            };
          }

          return SizedBox(
            width: 180,
            child: SpinnerButton(
              label: label,
              icon: icon,
              loading: loading,
              onPressed: onPressed,
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          );
        },
      ),
    );
  }
}
