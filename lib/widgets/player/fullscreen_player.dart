import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auto_pip/flutter_auto_pip.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/widgets/player/custom_material_controls.dart';
import 'package:video_player/video_player.dart';

class FullscreenPlayer extends StatefulWidget {
  final GetAnimeEpisodes$Query$Episodes$Data$Releases release;

  const FullscreenPlayer({Key key, @required this.release}) : super(key: key);

  @override
  _FullscreenPlayerState createState() => _FullscreenPlayerState();
}

class _FullscreenPlayerState extends State<FullscreenPlayer> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  StreamSubscription onPipModeChangedSubscription;

  @override
  void initState() {
    super.initState();

    initializeVideo();
    FlutterAutoPip.autoPipModeEnable();
    onPipModeChangedSubscription =
        FlutterAutoPip.onPipModeChanged.listen((event) {
      if (event) {
        _chewieController?.hideControls();
      }
    });
  }

  @override
  void dispose() {
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
        title: 'Kimi No Nawa',
        subtitle: '${widget.release.group} / ${widget.release.resolution}',
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
