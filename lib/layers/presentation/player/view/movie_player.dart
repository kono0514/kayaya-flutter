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
  VideoPlayerController playerController;
  ChewieController chewieController;
  StreamSubscription onPipModeChangedSubscription;
  PlayerUIController playerUIController = PlayerUIController();

  @override
  void initState() {
    super.initState();

    setupVideo();
    setupPIP();
  }

  @override
  void dispose() {
    playerUIController.dispose();
    onPipModeChangedSubscription.cancel();
    FlutterAutoPip.autoPipModeDisable();
    playerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  void setupVideo() {
    playerController = VideoPlayerController.network(widget.release.url);
    chewieController = ChewieController(
      videoPlayerController: playerController,
      aspectRatio: 16 / 9,
      allowFullScreen: false,
      allowedScreenSleep: false,
      autoInitialize: true,
      autoPlay: true,
      allowMuting: false,
      showControlsOnInitialize: false,
      customControls: CustomMaterialControls(
        title: widget.anime.name,
        uiController: playerUIController,
      ),
    );
  }

  void setupPIP() {
    onPipModeChangedSubscription =
        FlutterAutoPip.onPipModeChanged.listen((event) {
      if (event) {
        playerUIController.hide();
      }
    });
    FlutterAutoPip.autoPipModeEnable();
  }

  @override
  Widget build(BuildContext context) {
    return ChewieFS(
      controller: chewieController,
    );
  }
}
