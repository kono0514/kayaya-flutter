import 'dart:async';
import 'dart:math';

import 'package:chewie/chewie.dart';
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
  final Episode episode;
  final Release release;

  const SeriesPlayer({
    Key key,
    @required this.anime,
    @required this.episode,
    @required this.release,
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

  ScrollController playlistScrollController = ScrollController();
  bool scrolledToInitialEpisode = false;

  @override
  void initState() {
    super.initState();

    // Lock orientation for this screen only
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    setupVideo();
    setupPIP();
  }

  @override
  void dispose() {
    playlistScrollController.dispose();
    playerUIController.dispose();
    onPipModeChangedSubscription.cancel();
    FlutterAutoPip.autoPipModeDisable();
    playerController
      ..removeListener(playerEventListener)
      ..dispose();
    chewieController
      ..removeListener(chewieEventListener)
      ..dispose();
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  void setupVideo() {
    print(widget.release.url);
    playerController = VideoPlayerController.network(
        'https://anikodcdn.net/static/media/mp4/479/1_480.mp4');
    chewieController = ChewieController(
      videoPlayerController: playerController,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      aspectRatio: 16 / 9,
      allowFullScreen: true,
      allowedScreenSleep: false,
      autoInitialize: true,
      autoPlay: true,
      allowMuting: false,
      allowPlaybackSpeedChanging: true,
      customControls: CustomMaterialControls(
        title: widget.anime.name,
        subtitle: TR.current.episode_item(widget.episode.number),
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
          setState(() {
            renderPipFriendlyView = true;
          });
        }
        playerUIController.hide();
      } else {
        if (!chewieController.isFullScreen) {
          setState(() {
            renderPipFriendlyView = false;
          });
        }
      }
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

  @override
  Widget build(BuildContext context) {
    final chewie = Chewie(controller: chewieController);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => GetIt.I<PlayerEpisodesBloc>(
            param1: widget.anime.id,
            param2: widget.episode.number,
          )..add(PlayerEpisodesFetchNext()),
          child: _buildLayout(chewie),
        ),
      ),
    );
  }

  Widget _buildLayout(Chewie chewie) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: chewie,
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
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 16, top: 24),
                    child: Text('Now playing:'),
                  ),
                  SizedBox(height: 12),
                  Container(width: 40, height: 70, color: Colors.red),
                  SizedBox(height: 12),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 16, top: 24),
                    child: Text('Queue:'),
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
        // Scroll to the initially selected episode
        // when the list loads first time
        if (state is PlayerEpisodesLoaded && !scrolledToInitialEpisode) {
          scrolledToInitialEpisode = true;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            final initialIndex = state.positiveEpisodes.elements.indexWhere(
              (episode) => episode.number == widget.episode.number,
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
          return Center(child: Text('Error'));
        }

        if (state is PlayerEpisodesLoaded) {
          return _buildPlaylistList(state);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildPlaylistList(PlayerEpisodesLoaded state) {
    const Key centerKey = ValueKey('second-sliver-list');

    return Builder(
      builder: (context) => NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            if (notification.depth != 0) return false;
            if (notification.metrics.maxScrollExtent == 0) return false;

            // reach the pixels to loading more
            if (notification.metrics.pixels >
                notification.metrics.maxScrollExtent - 160) {
              context.read<PlayerEpisodesBloc>().add(PlayerEpisodesFetchNext());
            } else if (notification.metrics.pixels < 160) {
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
                  title:
                      'Episode ${state.negativeEpisodes.elements[index].number}',
                  subtitle: state.negativeEpisodes.elements[index].title,
                  onTap: () {
                    print(state.negativeEpisodes.elements[index].title);
                  },
                ),
                childCount: state.negativeEpisodes?.elements?.length ?? 0,
              ),
            ),
            SliverFixedExtentList(
              key: centerKey,
              itemExtent: 80,
              delegate: SliverChildBuilderDelegate(
                (context, index) => PlaylistItem(
                  title:
                      'Episode ${state.negativeEpisodes.elements[index].number}',
                  subtitle: state.negativeEpisodes.elements[index].title,
                  onTap: () {
                    print(state.negativeEpisodes.elements[index].title);
                  },
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
