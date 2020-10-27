import 'dart:async';

import 'package:chewie_extended/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auto_pip/flutter_auto_pip.dart';
import 'package:kayaya_flutter/widgets/player/custom_material_controls.dart';
import 'package:video_player/video_player.dart';

class FullscreenPlayer extends StatefulWidget {
  final String url;

  const FullscreenPlayer({Key key, @required this.url}) : super(key: key);

  @override
  _FullscreenPlayerState createState() => _FullscreenPlayerState();
}

class _FullscreenPlayerState extends State<FullscreenPlayer> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  StreamSubscription onPipModeChangedSubscription;

  void initializeVideo() async {
    _controller = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 16 / 9,
      allowFullScreen: false,
      allowedScreenSleep: false,
      autoInitialize: true,
      autoPlay: true,
      allowMuting: false,
      customControls: CustomMaterialControls(),
    );
  }

  @override
  void initState() {
    super.initState();

    initializeVideo();

    FlutterAutoPip.autoPipModeEnable();
    onPipModeChangedSubscription =
        FlutterAutoPip.onPipModeChanged.listen((event) {
      if (event) {
        _chewieController.hideControls();
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

  @override
  Widget build(BuildContext context) {
    return ChewieFS(
      controller: _chewieController,
    );
  }
}
