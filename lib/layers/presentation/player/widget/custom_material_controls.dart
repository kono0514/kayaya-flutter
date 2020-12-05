import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auto_pip/flutter_auto_pip.dart';
import 'package:intent/action.dart' as android_action;
import 'package:intent/intent.dart' as android_intent;
import 'package:package_info/package_info.dart';
import 'package:video_player/video_player.dart';

import '../util/helper.dart';
import 'material_progress_bar.dart';
import 'player_circle_button.dart';

class CustomMaterialControls extends StatefulWidget {
  final String title;
  final String subtitle;

  const CustomMaterialControls({
    Key key,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomMaterialControlsState();
  }
}

class _CustomMaterialControlsState extends State<CustomMaterialControls> {
  VideoPlayerValue _latestValue;
  double _latestVolume;
  bool _hideStuff = true;
  Duration _hideStuffAnimationDuration = Duration(milliseconds: 300);
  Timer _hideTimer;
  Timer _initTimer;
  Timer _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;

  final barHeight = 48.0;
  final marginSize = 5.0;

  int _rewindDuration = 10;
  int _forwardDuration = 30;

  int _rewindValue = 0;
  int _forwardValue = 0;
  Timer _buttonSeekTimer;

  bool _showPipButton = false;

  VideoPlayerController controller;
  ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    FlutterAutoPip.isPipSupported().then((value) {
      if (value) {
        setState(() {
          _showPipButton = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_latestValue.hasError) {
      return chewieController.errorBuilder != null
          ? chewieController.errorBuilder(
              context,
              chewieController.videoPlayerController.value.errorDescription,
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 42,
                  ),
                  SizedBox(height: 10),
                  Text(_latestValue.errorDescription),
                ],
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
                    : _buildMiddleControls(),
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
    chewieController.removeListener(_chewieListener);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _buttonSeekTimer?.cancel();
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
      duration: _hideStuffAnimationDuration,
      child: Container(
        height: 58,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showPipButton) _buildPipButton(),
            PlayerCircleButton(
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'copy_link') {
                    Clipboard.setData(
                        new ClipboardData(text: controller.dataSource));
                    Scaffold.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('URL copied to clipboard'),
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
      duration: _hideStuffAnimationDuration,
      child: Container(
        height: barHeight,
        child: Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14.0),
          child: Row(
            children: <Widget>[
              chewieController.isLive
                  ? Expanded(child: const Text('LIVE'))
                  : _buildPosition(),
              chewieController.isLive ? const SizedBox() : _buildProgressBar(),
              chewieController.allowPlaybackSpeedChanging
                  ? _buildSpeedButton(controller)
                  : Container(),
              chewieController.allowMuting
                  ? _buildMuteButton(controller)
                  : Container(),
              chewieController.allowFullScreen
                  ? _buildExpandButton()
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPipButton() {
    void _launchPipIntent() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      android_intent.Intent()
        ..setAction('android.settings.PICTURE_IN_PICTURE_SETTINGS')
        ..setData(Uri.parse("package:${packageInfo.packageName}"))
        ..startActivity().catchError((e) {
          print(e);
        });
    }

    return PlayerCircleButton(
      child: IconButton(
        icon: Icon(Icons.picture_in_picture_alt),
        color: Colors.white,
        tooltip: 'Picture-in-Picture',
        onPressed: () async {
          try {
            await FlutterAutoPip.enterPipMode();
          } on PlatformException catch (e) {
            if (e.code == 'PIP_EXCEPTION') {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(e.message),
                    duration: const Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'PERMISSION',
                      onPressed: () async {
                        controller.pause();
                        _launchPipIntent();
                      },
                    ),
                  ),
                );
            } else {
              rethrow;
            }
          }
        },
      ),
    );
  }

  Widget _buildExpandButton() {
    return PlayerCircleButton(
      child: IconButton(
        icon: Icon(
          chewieController.isFullScreen
              ? Icons.fullscreen_exit
              : Icons.fullscreen,
          color: Colors.white,
        ),
        tooltip: 'Fullscreen',
        onPressed: _onExpandCollapse,
      ),
    );
  }

  Widget _buildMiddleControls() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: _hideStuffAnimationDuration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildRewindButton(),
          _buildPlayPause(),
          _buildForwardButton(),
        ],
      ),
    );
  }

  Widget _buildRewindButton() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        if (_rewindValue > 0)
          Positioned(
            top: -26,
            child: Text(
              '- ${formatDuration(Duration(seconds: _rewindValue))}s',
              style: TextStyle(color: Colors.white),
            ),
          ),
        SizedBox(
          width: 80.0,
          height: 80.0,
          child: PlayerCircleButton(
            child: IconButton(
              icon: Icon(
                Icons.replay_10,
                size: 36.0,
                color: _latestValue?.isBuffering == true
                    ? Colors.white54
                    : Colors.white,
              ),
              onPressed: () {
                if (_latestValue?.isPlaying == true) {
                  _cancelAndRestartTimer();
                }

                if (_latestValue?.isBuffering == true) {
                  return;
                }

                setState(() {
                  _forwardValue = 0;
                  _rewindValue += _rewindDuration;
                  _cancelAndRestartButtonSeekTimer();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForwardButton() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        if (_forwardValue > 0)
          Positioned(
            top: -26,
            child: Text(
              '+ ${formatDuration(Duration(seconds: _forwardValue))}s',
              style: TextStyle(color: Colors.white),
            ),
          ),
        SizedBox(
          width: 80.0,
          height: 80.0,
          child: PlayerCircleButton(
            child: IconButton(
              icon: Icon(
                Icons.forward_30,
                size: 36.0,
                color: _latestValue?.isBuffering == true
                    ? Colors.white54
                    : Colors.white,
              ),
              onPressed: () {
                if (_latestValue?.isPlaying == true) {
                  _cancelAndRestartTimer();
                }

                if (_latestValue?.isBuffering == true) {
                  return;
                }

                setState(() {
                  _rewindValue = 0;
                  _forwardValue += _forwardDuration;
                  _cancelAndRestartButtonSeekTimer();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayPause() {
    bool _isFinished = false;
    if (_latestValue.duration != null) {
      _isFinished = _latestValue.position >= _latestValue.duration;
    }

    return SizedBox(
      width: 80.0,
      height: 80.0,
      child: PlayerCircleButton(
        child: IconButton(
          icon: Icon(
            _latestValue.isPlaying
                ? Icons.pause
                : _isFinished
                    ? Icons.autorenew
                    : Icons.play_arrow,
            size: 58.0,
            color: Colors.white,
          ),
          onPressed: _playPause,
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
        duration: _hideStuffAnimationDuration,
        child: Container(
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildMuteButton(
    VideoPlayerController controller,
  ) {
    return PlayerCircleButton(
      child: IconButton(
        icon: Icon(
          (_latestValue != null && _latestValue.volume > 0)
              ? Icons.volume_up
              : Icons.volume_off,
          color: Colors.white,
        ),
        tooltip: 'Mute',
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
    );
  }

  Widget _buildSpeedButton(
    VideoPlayerController controller,
  ) {
    return PlayerCircleButton(
      child: IconButton(
        icon: AutoSizeText(
          '${_latestValue.playbackSpeed}x',
          maxLines: 1,
          minFontSize: 8,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        tooltip: 'Speed',
        onPressed: () async {
          final wasPlaying = _latestValue?.isPlaying ?? false;

          if (wasPlaying) {
            _pause();
          }

          final chosenSpeed = await showModalBottomSheet<double>(
            context: context,
            isScrollControlled: true,
            useRootNavigator: true,
            builder: (context) => PlaybackSpeedDialog(
              speeds: chewieController.playbackSpeeds,
              selected: _latestValue.playbackSpeed,
            ),
          );

          if (chosenSpeed != null) {
            controller.setPlaybackSpeed(chosenSpeed);
          }

          if (wasPlaying) {
            _play();
          }
        },
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
      padding: EdgeInsets.only(top: 3.0),
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

  void _cancelAndRestartButtonSeekTimer() {
    _buttonSeekTimer?.cancel();
    _startButtonSeekTimer();
  }

  Future<Null> _initialize() async {
    controller.addListener(_updateState);
    chewieController.addListener(_chewieListener);

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

  void _chewieListener() async {
    if (chewieController.shouldHideControlsNow) {
      setState(() {
        _hideStuff = true;
        _hideStuffAnimationDuration = Duration.zero;
        _hideTimer?.cancel();
      });
      _hideStuffAnimationDuration = Duration(milliseconds: 300);
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
    if (controller.value.isPlaying) {
      _pause();
    } else {
      _play();
    }
  }

  void _play() {
    bool isFinished = _latestValue.position >= _latestValue.duration;

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

  void _pause() {
    setState(() {
      _hideStuff = false;
      _hideTimer?.cancel();
      controller.pause();
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _startButtonSeekTimer() {
    _buttonSeekTimer = Timer(
      const Duration(seconds: 1),
      () {
        if (_forwardValue == 0 && _rewindValue == 0) return;

        if (_forwardValue > 0) {
          controller
              .seekTo(_latestValue.position + Duration(seconds: _forwardValue));
        } else {
          controller
              .seekTo(_latestValue.position - Duration(seconds: _rewindValue));
        }

        setState(() {
          _rewindValue = 0;
          _forwardValue = 0;
        });
      },
    );
  }

  void _updateState() {
    setState(() {
      _latestValue = controller.value;
    });
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 18.0, right: 18.0),
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

class PlaybackSpeedDialog extends StatelessWidget {
  const PlaybackSpeedDialog({
    Key key,
    @required List<double> speeds,
    @required double selected,
  })  : _speeds = speeds,
        _selected = selected,
        super(key: key);

  final List<double> _speeds;
  final double _selected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color selectedColor = theme.brightness == Brightness.light
        ? theme.primaryColor
        : theme.accentColor;

    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        final _speed = _speeds[index];
        return ListTile(
          dense: true,
          title: Row(
            children: [
              _speed == _selected
                  ? Icon(
                      Icons.check,
                      size: 20.0,
                      color: selectedColor,
                    )
                  : Container(width: 20.0),
              SizedBox(width: 16.0),
              Text(_speed == 1.0 ? 'Normal' : '${_speed}x'),
            ],
          ),
          selected: _speed == _selected,
          onTap: () {
            Navigator.of(context).pop(_speed);
          },
        );
      },
      itemCount: _speeds.length,
    );
  }
}
