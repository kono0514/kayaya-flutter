import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auto_pip/flutter_auto_pip.dart';
import 'package:video_player/video_player.dart';

import '../model/media_info.dart';
import '../widget/custom_material_controls.dart';

class FullscreenPlayer extends StatefulWidget {
  final MediaInfo mediaInfo;

  const FullscreenPlayer({
    Key key,
    @required this.mediaInfo,
  }) : super(key: key);

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
    _controller = VideoPlayerController.network(widget.mediaInfo.url);
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
        title: widget.mediaInfo.title,
        subtitle: widget.mediaInfo.subtitle,
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
