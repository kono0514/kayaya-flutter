import 'package:chewie_extended/chewie.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

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
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChewieFS(
      controller: _chewieController,
    );
  }
}
