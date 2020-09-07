import 'dart:async';

import 'package:chewie_extended/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;

class CustomMaterialControls extends StatefulWidget {
  const CustomMaterialControls({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomMaterialControlsState();
  }
}

class _CustomMaterialControlsState extends State<CustomMaterialControls> {
  VideoPlayerValue _latestValue;
  double _latestVolume;
  bool _hideStuff = true;
  Timer _hideTimer;
  Timer _initTimer;
  Timer _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;

  final barHeight = 48.0;
  final marginSize = 5.0;

  VideoPlayerController controller;
  ChewieController chewieController;

  @override
  Widget build(BuildContext context) {
    if (_latestValue.hasError) {
      return chewieController.errorBuilder != null
          ? chewieController.errorBuilder(
              context,
              chewieController.videoPlayerController.value.errorDescription,
            )
          : Center(
              child: Icon(
                Icons.error,
                color: Colors.white,
                size: 42,
              ),
            );
    }

    return MouseRegion(
      onHover: (_) {
        _cancelAndRestartTimer();
      },
      child: GestureDetector(
        onTap: () {
          if (_latestValue?.isPlaying == true) {
            _cancelAndRestartTimer();
          } else {
            _showStuff();
          }
        },
        child: AbsorbPointer(
          absorbing: _hideStuff,
          child: Stack(
            children: <Widget>[
              Positioned.fill(child: _buildHitArea()),
              Positioned.fill(
                child: _latestValue != null &&
                            !_latestValue.isPlaying &&
                            _latestValue.duration == null ||
                        _latestValue.isBuffering
                    ? const Center(
                        child: const CircularProgressIndicator(),
                      )
                    : _buildPlayPauseMiddle(),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: _buildTopBar(context),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildBottomBar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = chewieController;
    chewieController = ChewieController.of(context);
    controller = chewieController.videoPlayerController;

    if (_oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  AnimatedOpacity _buildTopBar(
    BuildContext context,
  ) {
    final iconColor = Theme.of(context).textTheme.button.color;

    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        height: barHeight,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Kimi no Nawa: Episode 1 (ANIKOD 1080p)',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
            Material(
              clipBehavior: Clip.hardEdge,
              type: MaterialType.circle,
              color: Colors.transparent,
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'copy_link') {
                    Clipboard.setData(
                        new ClipboardData(text: controller.dataSource));
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('URL copied to clipboard'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else if (value == 'open_external') {
                    controller.pause();
                    android_intent.Intent()
                      ..setAction(android_action.Action.ACTION_VIEW)
                      ..setData(Uri.parse(controller.dataSource))
                      ..setType('video/*')
                      ..startActivity(
                        createChooser: true,
                        chooserTitle: "Open with",
                      ).catchError((e) {
                        print(e);
                        controller.play();
                      });
                  }
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'open_external',
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 120.0),
                        child: Text('Open with'),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'copy_link',
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 120.0),
                        child: Text('Copy Link'),
                      ),
                    ),
                  ];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedOpacity _buildBottomBar(
    BuildContext context,
  ) {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        height: barHeight,
        child: Row(
          children: <Widget>[
            chewieController.isLive
                ? Expanded(child: const Text('LIVE'))
                : _buildPosition(),
            chewieController.isLive ? const SizedBox() : _buildProgressBar(),
            chewieController.allowMuting
                ? _buildMuteButton(controller)
                : Container(),
            chewieController.allowFullScreen
                ? _buildExpandButton()
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandButton() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Material(
          clipBehavior: Clip.hardEdge,
          type: MaterialType.circle,
          color: Colors.transparent,
          child: IconButton(
              icon: Icon(
                chewieController.isFullScreen
                    ? Icons.fullscreen_exit
                    : Icons.fullscreen,
                color: Colors.white,
              ),
              onPressed: _onExpandCollapse),
        ),
      ),
    );
  }

  Widget _buildPlayPauseMiddle() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Center(
        child: Material(
          clipBehavior: Clip.hardEdge,
          type: MaterialType.circle,
          color: Colors.transparent,
          child: InkWell(
            onTap: _playPause,
            child: SizedBox(
              width: 80.0,
              height: 80.0,
              child: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 58.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHitArea() {
    Function onTap = () {
      if (_latestValue?.isPlaying == true) {
        if (_displayTapped) {
          setState(() {
            _hideStuff = true;
          });
        } else
          _cancelAndRestartTimer();
      } else {
        setState(() {
          _hideStuff = true;
        });
      }
    };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildMuteButton(
    VideoPlayerController controller,
  ) {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Material(
        clipBehavior: Clip.hardEdge,
        type: MaterialType.circle,
        color: Colors.transparent,
        child: IconButton(
          icon: Icon(
            (_latestValue != null && _latestValue.volume > 0)
                ? Icons.volume_up
                : Icons.volume_off,
            color: Colors.white,
          ),
          onPressed: () {
            if (_latestValue?.isPlaying == true) {
              _cancelAndRestartTimer();
            }

            if (_latestValue.volume == 0) {
              controller.setVolume(_latestVolume ?? 0.5);
            } else {
              _latestVolume = controller.value.volume;
              controller.setVolume(0.0);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPlayPause(VideoPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 4.0),
      child: Material(
        clipBehavior: Clip.hardEdge,
        type: MaterialType.circle,
        color: Colors.transparent,
        child: IconButton(
          icon: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: _playPause,
        ),
      ),
    );
  }

  Widget _buildPosition() {
    final position = _latestValue != null && _latestValue.position != null
        ? _latestValue.position
        : Duration.zero;
    final duration = _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration
        : Duration.zero;

    return Padding(
      padding: EdgeInsets.only(top: 3.0, left: 14.0, right: 18.0),
      child: Text(
        '${formatDuration(position)} / ${formatDuration(duration)}',
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.white,
        ),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    _showStuff();
  }

  void _showStuff() {
    setState(() {
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  Future<Null> _initialize() async {
    controller.addListener(_updateState);

    _updateState();

    if ((controller.value != null && controller.value.isPlaying) ||
        chewieController.autoPlay) {
      _startHideTimer();
    }

    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(Duration(milliseconds: 200), () {
        setState(() {
          _hideStuff = false;
        });
      });
    }
  }

  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;

      chewieController.toggleFullScreen();
      _showAfterExpandCollapseTimer = Timer(Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _playPause() {
    bool isFinished = _latestValue.position >= _latestValue.duration;

    setState(() {
      if (controller.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.initialized) {
          controller.initialize().then((_) {
            controller.play();
          });
        } else {
          if (isFinished) {
            controller.seekTo(Duration(seconds: 0));
          }
          controller.play();
        }
      }
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = controller.value;
    });
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: MaterialVideoProgressBar(
          controller,
          onDragStart: () {
            setState(() {
              _dragging = true;
            });

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
              _dragging = false;
            });

            _startHideTimer();
          },
          colors: chewieController.materialProgressColors ??
              ChewieProgressColors(
                  playedColor: Theme.of(context).accentColor,
                  handleColor: Theme.of(context).accentColor,
                  bufferedColor: Colors.white,
                  backgroundColor: Colors.white.withAlpha(100)),
        ),
      ),
    );
  }
}
