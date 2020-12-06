import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:video_player/video_player.dart';

import '../../../../locale/generated/l10n.dart';
import '../../../domain/entities/anime.dart';
import '../../../domain/entities/episode.dart';
import '../../../domain/entities/release.dart';
import '../widget/custom_material_controls.dart';

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
  StreamSubscription onDeviceOrientationChangedSubscription;

  @override
  void initState() {
    super.initState();

    initializeVideo();
    // FlutterAutoPip.autoPipModeEnable();
    // onPipModeChangedSubscription =
    //     FlutterAutoPip.onPipModeChanged.listen((event) {
    //   if (event) {
    //     _chewieController?.hideControls();
    //   }
    // });
    onDeviceOrientationChangedSubscription =
        NativeDeviceOrientationCommunicator()
            .onOrientationChanged(useSensor: true)
            .listen((event) {
      if (event == NativeDeviceOrientation.landscapeLeft ||
          event == NativeDeviceOrientation.landscapeRight) {
        print('go fullscreen');
      } else if (event == NativeDeviceOrientation.portraitDown ||
          event == NativeDeviceOrientation.portraitUp) {
        print('exit fullscreen');
      }
    });
  }

  @override
  void dispose() {
    // FlutterAutoPip.autoPipModeDisable();
    _controller.dispose();
    _chewieController.dispose();
    // onPipModeChangedSubscription.cancel();
    onDeviceOrientationChangedSubscription.cancel();
    super.dispose();
  }

  void initializeVideo() {
    _controller = VideoPlayerController.network(widget.release.url);
    _chewieController = ChewieController(
      videoPlayerController: _controller,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Chewie(
                controller: _chewieController,
              ),
            ),
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
                        ),
                        itemCount: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
