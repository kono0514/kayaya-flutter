import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auto_pip/flutter_auto_pip.dart';
import 'package:video_player/video_player.dart';

import '../../../../locale/generated/l10n.dart';
import '../../../domain/entities/anime.dart';
import '../../../domain/entities/episode.dart';
import '../../../domain/entities/release.dart';
import '../widget/custom_material_controls.dart';
import '../widget/player_ui_controller.dart';

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
  VideoPlayerController _controller;
  ChewieController _chewieController;
  StreamSubscription onPipModeChangedSubscription;
  bool renderPipFriendlyView = false;
  bool isPlayingValue = false;
  bool isFullscreenValue = false;
  PlayerUIController playerUIController = PlayerUIController();

  @override
  void initState() {
    super.initState();

    // Lock orientation for this screen only
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    initializeVideo();

    _controller.addListener(playerEventListener);
    _chewieController.addListener(chewieEventListener);

    // Application entered/exited PIP mode (by pressing home, recent buttons etc...)
    onPipModeChangedSubscription =
        FlutterAutoPip.onPipModeChanged.listen((inPipMode) {
      if (inPipMode) {
        // If player is not fullscreen, hide the additional
        // UI stuff (queue list etc...) and render only the video.
        // Don't need to do anything if player is already in fullscreen
        // since the only thing thats rendered is the video itself.
        if (!_chewieController.isFullScreen) {
          setState(() {
            renderPipFriendlyView = true;
          });
        }
        playerUIController.hide();
      } else {
        if (!_chewieController.isFullScreen) {
          setState(() {
            renderPipFriendlyView = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    playerUIController.dispose();
    FlutterAutoPip.autoPipModeDisable();
    onPipModeChangedSubscription.cancel();
    _controller
      ..removeListener(playerEventListener)
      ..dispose();
    _chewieController
      ..removeListener(chewieEventListener)
      ..dispose();
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  void initializeVideo() {
    print(widget.release.url);
    _controller = VideoPlayerController.network(
        'https://anikodcdn.net/static/media/mp4/479/1_480.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _controller,
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
    if (isPlayingValue != _controller.value?.isPlaying) {
      isPlayingValue = _controller.value?.isPlaying;

      // When not in fullscreen mode, don't auto-enter PIP mode
      // if the video is not playing (paused)
      if (!_chewieController.isFullScreen) {
        toggleAutoPipMode(isPlayingValue);
      }
    }
  }

  void chewieEventListener() {
    if (isFullscreenValue != _chewieController.isFullScreen) {
      isFullscreenValue = _chewieController.isFullScreen;

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
    final chewie = Chewie(controller: _chewieController);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: _buildMainView(chewie),
      ),
    );
  }

  Widget _buildMainView(Chewie chewie) {
    return Column(
      children: [
        ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
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
                    child: ListView.builder(
                      itemBuilder: (context, index) => ListTile(
                        title: Text('Episode $index'),
                        onTap: () {},
                      ),
                      itemCount: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
