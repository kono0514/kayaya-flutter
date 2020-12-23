import 'package:dartz/dartz.dart' show Right;
import 'package:flutter/material.dart'
    hide NestedScrollView, NestedScrollViewState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/widgets/spinner_button.dart';
import '../../../../locale/generated/l10n.dart';
import '../../../../router.dart';
import '../../../domain/entities/anime.dart';
import '../../library/cubit/subscription_list_cubit.dart';
import '../cubit/details_cubit.dart';
import '../cubit/subscription_cubit.dart';
import '../widget/detail_view.dart';
import '../widget/tab_episodes.dart';
import '../widget/tab_info.dart';
import '../widget/tab_related.dart';

// (Implemented workaround with extended_nested_scroll_view) TODO: https://github.com/flutter/flutter/issues/40740

class SeriesPage extends StatelessWidget {
  final Anime anime;
  final bool isMinimal;

  const SeriesPage(this.anime, {this.isMinimal = false});

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
        buildWhen: (_, __) =>
            isMinimal, // buildWhen is bypassed on initial state (that means builder method is always called)
        builder: (context, state) {
          return DetailView(
            anime: (state is DetailsLoaded && state.hasListData)
                ? state.animeListData
                : anime,
            actions: [
              Expanded(
                child: _SeriesPlayButton(
                  anime: anime,
                ),
              ),
              const SizedBox(width: 10),
              _SeriesSubscribeButton(
                anime: anime,
                isMinimal: isMinimal,
              ),
            ],
            tabs: [
              TR.of(context).info,
              TR.of(context).episodes,
              TR.of(context).related,
            ],
            tabViews: [
              const InfoTabViewItem(tabKey: Key('Tab0')),
              EpisodesTabViewItem(tabKey: const Key('Tab1'), anime: anime),
              RelatedTabViewItem(tabKey: const Key('Tab2'), id: anime.id),
            ],
          );
        },
      ),
    );
  }
}

class _SeriesPlayButton extends StatelessWidget {
  final Anime anime;

  const _SeriesPlayButton({
    Key key,
    @required this.anime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: SpinnerButton(
        label: Text(TR.of(context).play.toUpperCase()),
        icon: const Icon(Icons.play_circle_outline),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            Routes.seriesPlayer,
            arguments: SeriesPlayerArguments(
              anime: anime,
              episode: const Right(1),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

class _SeriesSubscribeButton extends StatelessWidget {
  final Anime anime;
  final bool isMinimal;

  const _SeriesSubscribeButton({
    Key key,
    @required this.anime,
    @required this.isMinimal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = GetIt.I<SubscriptionCubit>(
          param1: context.read<SubscriptionListCubit>(),
        );
        if (!isMinimal) {
          return cubit
            ..loadData(anime)
            ..check();
        }
        return cubit;
      },
      child: BlocListener<DetailsCubit, DetailsState>(
        listener: (context, state) {
          if (state is DetailsLoaded) {
            if (isMinimal) {
              context.read<SubscriptionCubit>().loadData(state.animeListData);
              context.read<SubscriptionCubit>().check();
            }
          }
        },
        child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            Icon icon;
            VoidCallback onPressed = () {};
            bool loading = true;
            Color buttonColor;
            String tooltip = '';

            if (state is SubscriptionLoaded) {
              loading = false;
              icon = Icon(state.subscribed
                  ? Icons.notifications_active
                  : Icons.notifications_none);
              buttonColor = state.subscribed ? Colors.red : null;
              tooltip = state.subscribed
                  ? TR.of(context).unsubscribe
                  : TR.of(context).subscribe;
              onPressed = () {
                final cubit = context.read<SubscriptionCubit>();
                if (state.subscribed) {
                  cubit.unsubscribe();
                } else {
                  cubit.subscribe();
                }
              };
            }

            return SizedBox(
              height: 50,
              child: Tooltip(
                message: tooltip,
                preferBelow: false,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                margin: const EdgeInsets.only(bottom: 10.0),
                child: SpinnerButton(
                  loading: loading,
                  icon: icon,
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    primary: buttonColor,
                    padding: const EdgeInsets.all(0),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
