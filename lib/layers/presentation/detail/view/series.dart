import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart'
    hide NestedScrollView, NestedScrollViewState;
import 'package:kayaya_flutter/layers/presentation/library/cubit/subscription_list_cubit.dart';

import '../../../../core/widgets/spinner_button.dart';
import '../../../../locale/generated/l10n.dart';
import '../../../domain/entities/anime.dart';
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

  SeriesPage(this.anime, {this.isMinimal = false});

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
        builder: (context, state) {
          return DetailView(
            anime: (state is DetailsLoaded && state.hasListData)
                ? state.animeListData
                : anime,
            actions: [
              SeriesSubscribeButton(
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
              InfoTabViewItem(tabKey: Key('Tab0')),
              EpisodesTabViewItem(tabKey: Key('Tab1'), anime: anime),
              RelatedTabViewItem(tabKey: Key('Tab2'), id: anime.id),
            ],
          );
        },
      ),
    );
  }
}

class SeriesSubscribeButton extends StatelessWidget {
  final Anime anime;
  final bool isMinimal;

  const SeriesSubscribeButton({
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
        child: BlocConsumer<SubscriptionCubit, SubscriptionState>(
          listener: (context, state) {
            if (state is SubscriptionLoaded) {
              if (state.isDirty) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.subscribed
                          ? TR.of(context).subscribe_success
                          : TR.of(context).unsubscribe_success),
                    ),
                  );
              }
            }
          },
          builder: (context, state) {
            Text label = Text('...');
            Icon icon;
            Function onPressed = () {};
            bool loading = true;

            if (state is SubscriptionLoaded) {
              loading = false;
              label = Text((state.subscribed
                      ? TR.of(context).unsubscribe
                      : TR.of(context).subscribe)
                  .toUpperCase());
              icon = Icon(state.subscribed
                  ? Icons.notifications_active
                  : Icons.notifications_none);
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
      ),
    );
  }
}
