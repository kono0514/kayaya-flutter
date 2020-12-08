import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auto_pip/flutter_auto_pip.dart';
import 'package:video_player/video_player.dart';

import '../../../domain/entities/anime.dart';
import '../../../domain/entities/release.dart';
import '../widget/custom_material_controls.dart';
import '../widget/player_ui_controller.dart';

class MoviePlayer extends StatefulWidget {
  final Anime anime;
  final Release release;

  const MoviePlayer({
    Key key,
    @required this.anime,
    @required this.release,
  }) : super(key: key);

  @override
  _MoviePlayerState createState() => _MoviePlayerState();
}

class _MoviePlayerState extends State<MoviePlayer> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  StreamSubscription onPipModeChangedSubscription;
  PlayerUIController playerUIController = PlayerUIController();

  @override
  void initState() {
    super.initState();

    initializeVideo();
    FlutterAutoPip.autoPipModeEnable();
    onPipModeChangedSubscription =
        FlutterAutoPip.onPipModeChanged.listen((event) {
      if (event) {
        playerUIController.hide();
      }
    });
  }

  @override
  void dispose() {
    playerUIController.dispose();
    FlutterAutoPip.autoPipModeDisable();
    _controller.dispose();
    _chewieController.dispose();
    onPipModeChangedSubscription.cancel();
    super.dispose();
  }

  void initializeVideo() {
    _controller = VideoPlayerController.network(widget.release.url);
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 16 / 9,
      allowFullScreen: false,
      allowedScreenSleep: false,
      autoInitialize: true,
      autoPlay: true,
      allowMuting: false,
      allowPlaybackSpeedChanging: true,
      customControls: CustomMaterialControls(
        title: widget.anime.name,
        uiController: playerUIController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChewieFS(
      controller: _chewieController,
    );
  }
}
