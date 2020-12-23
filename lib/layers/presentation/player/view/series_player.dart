import 'dart:async';
import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auto_pip/flutter_auto_pip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/widgets/list_bottom_loader.dart';
import '../../../../locale/generated/l10n.dart';
import '../../../domain/entities/anime.dart';
import '../../../domain/entities/episode.dart';
import '../../../domain/entities/release.dart';
import '../bloc/player_episodes_bloc.dart';
import '../widget/custom_material_controls.dart';
import '../widget/player_ui_controller.dart';
import '../widget/playlist_item.dart';

class SeriesPlayer extends StatefulWidget {
  final Anime anime;
  final Either<Episode, int> episode;
  final Release release;

  const SeriesPlayer({
    Key key,
    @required this.anime,
    @required this.episode,
    this.release,
  }) : super(key: key);

  @override
  _SeriesPlayerState createState() => _SeriesPlayerState();
}

class _SeriesPlayerState extends State<SeriesPlayer> {
  VideoPlayerController playerController;
  ChewieController chewieController;
  PlayerUIController playerUIController = PlayerUIController();
  bool isPlayingValue = false;
  bool isFullscreenValue = false;

  StreamSubscription onPipModeChangedSubscription;
  bool renderPipFriendlyView = false;
  double playlistScrollPositionBeforePip;

  ScrollController playlistScrollController = ScrollController();
  bool scrolledToInitialEpisode = false;

  Episode currentEpisode;

  int get startingEpisode =>
      widget.episode.fold((l) => l.number, (r) => r) ?? 1;
  bool get isLazyLoadInitialEpisode => widget.episode.isRight();
  bool lazyLoadedInitialEpisode = false;

  @override
  void initState() {
    super.initState();

    // Lock orientation for this screen only
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if (widget.episode.isLeft()) {
      setupVideo(
        widget.episode.fold<Episode>((l) => l, (_) => null),
        release: widget.release,
      );
    }
    setupPIP();
  }

  @override
  void dispose() {
    playlistScrollController.dispose();
    playerUIController.dispose();
    onPipModeChangedSubscription.cancel();
    FlutterAutoPip.autoPipModeDisable();
    playerController?.removeListener(playerEventListener);
    playerController?.dispose();
    chewieController?.removeListener(chewieEventListener);
    chewieController?.dispose();
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  void setupVideo(Episode episode, {Release release}) {
    isPlayingValue = false;
    currentEpisode = episode;
    release ??= episode.releases.first;
    playerController = VideoPlayerController.network(release.url);
    chewieController = ChewieController(
      videoPlayerController: playerController,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      aspectRatio: 16 / 9,
      allowedScreenSleep: false,
      autoInitialize: true,
      autoPlay: true,
      allowMuting: false,
      showControlsOnInitialize: false,
      customControls: CustomMaterialControls(
        title: widget.anime.name,
        subtitle: TR.current.episode_item(currentEpisode.number),
        uiController: playerUIController,
      ),
    );

    playerController.addListener(playerEventListener);
    chewieController.addListener(chewieEventListener);
  }

  void setupPIP() {
    // Application entered/exited PIP mode (by pressing home, recent buttons etc...)
    onPipModeChangedSubscription =
        FlutterAutoPip.onPipModeChanged.listen((inPipMode) {
      if (inPipMode) {
        // If player is not fullscreen, hide the additional
        // UI stuff (queue list etc...) and render only the video.
        // Don't need to do anything if player is already in fullscreen
        // since the only thing thats rendered is the video itself.
        if (!chewieController.isFullScreen) {
          enterPipMode();
        }
        playerUIController.hide();
      } else {
        if (!chewieController.isFullScreen) {
          exitPipMode();
        }
      }
    });
  }

  void enterPipMode() {
    setState(() {
      playlistScrollPositionBeforePip =
          playlistScrollController.position.pixels;
      renderPipFriendlyView = true;
    });
  }

  void exitPipMode() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (playlistScrollPositionBeforePip != null) {
        playlistScrollController.jumpTo(playlistScrollPositionBeforePip);
      }
    });
    setState(() {
      renderPipFriendlyView = false;
    });
  }

  void toggleAutoPipMode(bool value) {
    if (value) {
      print('Enable Auto PIP mode');
      FlutterAutoPip.autoPipModeEnable();
    } else {
      print('Disable Auto PIP mode');
      FlutterAutoPip.autoPipModeDisable();
    }
  }

  void playerEventListener() {
    if (isPlayingValue != playerController.value?.isPlaying) {
      isPlayingValue = playerController.value?.isPlaying;

      // When not in fullscreen mode, don't auto-enter PIP mode
      // if the video is not playing (paused)
      if (!chewieController.isFullScreen) {
        toggleAutoPipMode(isPlayingValue);
      }
    }
  }

  void chewieEventListener() {
    if (isFullscreenValue != chewieController.isFullScreen) {
      isFullscreenValue = chewieController.isFullScreen;

      // When in fullscreen mode, auto-enter PIP mode
      // regardless of the video state (playing, paused)
      toggleAutoPipMode(isFullscreenValue);

      // Fullscreen exited. Restore non-fullscreen mode behavior
      if (!isFullscreenValue) {
        toggleAutoPipMode(isPlayingValue);
      }
    }
  }

  Future<void> changeVideo(Episode episode) async {
    // First create and assign new controllers for video player and chewie.
    // Then we dispose the old controllers after that. Disposing it this way (after)
    // is safe because it is no longer used by anything (video player or chewie)
    final oldPlayerController = playerController;
    final oldChewieController = chewieController;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      oldPlayerController?.removeListener(playerEventListener);
      await oldPlayerController?.dispose();
      oldChewieController?.removeListener(chewieEventListener);
      oldChewieController?.dispose();
    });

    setupVideo(episode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => GetIt.I<PlayerEpisodesBloc>(
            param1: widget.anime.id,
            param2: startingEpisode,
          )..add(PlayerEpisodesFetchNext()),
          child: _buildLayout(),
        ),
      ),
    );
  }

  Widget _buildLayout() {
    return Column(
      children: [
        Container(
          color: Colors.black,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: isLazyLoadInitialEpisode && !lazyLoadedInitialEpisode
                  ? const Center(child: CircularProgressIndicator())
                  : Chewie(controller: chewieController),
            ),
          ),
        ),
        if (!renderPipFriendlyView)
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('${TR.of(context).episodes}:'),
                  ),
                  Expanded(
                    child: _buildPlaylist(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaylist() {
    return BlocConsumer<PlayerEpisodesBloc, PlayerEpisodesState>(
      listener: (context, state) {
        if (state is PlayerEpisodesLoaded &&
            isLazyLoadInitialEpisode &&
            !lazyLoadedInitialEpisode) {
          lazyLoadedInitialEpisode = true;
          final e = state.positiveEpisodes.elements.firstWhere(
              (episode) => episode.number == startingEpisode,
              orElse: () => null);
          if (e != null) {
            changeVideo(e);
          }
        }

        // Scroll to the initially selected episode
        // when the list loads first time
        if (state is PlayerEpisodesLoaded && !scrolledToInitialEpisode) {
          scrolledToInitialEpisode = true;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            final initialIndex = state.positiveEpisodes.elements.indexWhere(
              (episode) => episode.number == startingEpisode,
            );
            playlistScrollController.jumpTo(
              min(
                playlistScrollController.position.maxScrollExtent,
                80.0 * max(0, initialIndex),
              ),
            );
          });
        }
      },
      builder: (context, state) {
        if (state is PlayerEpisodesError) {
          return const Center(child: Text('Error'));
        }

        if (state is PlayerEpisodesLoaded) {
          return _buildPlaylistList(state);
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  ScrollDirection scrollDirection = ScrollDirection.reverse;
  Widget _buildPlaylistList(PlayerEpisodesLoaded state) {
    const Key centerKey = ValueKey('second-sliver-list');

    return Builder(
      builder: (context) => NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is UserScrollNotification) {
            scrollDirection = notification.direction;
          }
          if (notification is ScrollEndNotification) {
            if (notification.depth != 0) return false;
            if (notification.metrics.maxScrollExtent == 0) return false;

            // reach the pixels to load more
            final maxExtent = notification.metrics.maxScrollExtent - 160;
            final minExtent = notification.metrics.minScrollExtent + 160;
            if (scrollDirection == ScrollDirection.reverse &&
                notification.metrics.pixels > maxExtent) {
              context.read<PlayerEpisodesBloc>().add(PlayerEpisodesFetchNext());
            } else if (scrollDirection == ScrollDirection.forward &&
                notification.metrics.pixels < minExtent) {
              context
                  .read<PlayerEpisodesBloc>()
                  .add(PlayerEpisodesFetchPrevious());
            }
            return true;
          }
          return false;
        },
        child: CustomScrollView(
          center: centerKey,
          controller: playlistScrollController,
          slivers: [
            if (state.hasMoreNegativeEpisodes)
              SliverToBoxAdapter(
                child: ListLoader(
                  error: state.negativeError != null,
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  spinnerSize: 24.0,
                ),
              ),
            SliverFixedExtentList(
              itemExtent: 80,
              delegate: SliverChildBuilderDelegate(
                (context, index) => PlaylistItem(
                  title: TR.current.episode_item(
                      state.negativeEpisodes.elements[index].number),
                  subtitle: state.negativeEpisodes.elements[index].title,
                  onTap: () {
                    changeVideo(state.negativeEpisodes.elements[index]);
                  },
                  isActive:
                      currentEpisode == state.negativeEpisodes.elements[index],
                ),
                childCount: state.negativeEpisodes?.elements?.length ?? 0,
              ),
            ),
            SliverFixedExtentList(
              key: centerKey,
              itemExtent: 80,
              delegate: SliverChildBuilderDelegate(
                (context, index) => PlaylistItem(
                  title: TR.current.episode_item(
                      state.positiveEpisodes.elements[index].number),
                  subtitle: state.positiveEpisodes.elements[index].title,
                  onTap: () {
                    changeVideo(state.positiveEpisodes.elements[index]);
                  },
                  isActive:
                      currentEpisode == state.positiveEpisodes.elements[index],
                ),
                childCount: state.positiveEpisodes?.elements?.length ?? 0,
              ),
            ),
            if (state.hasMorePositiveEpisodes)
              SliverToBoxAdapter(
                child: ListLoader(
                  error: state.positiveError != null,
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  spinnerSize: 24.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
