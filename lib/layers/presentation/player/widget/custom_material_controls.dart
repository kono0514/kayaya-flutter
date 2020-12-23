import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auto_pip/flutter_auto_pip.dart';
import 'package:intent/action.dart' as android_action;
import 'package:intent/intent.dart' as android_intent;
import 'package:package_info/package_info.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/widgets/material_dialog.dart';
import '../util/helper.dart';
import 'material_progress_bar.dart';
import 'player_circle_button.dart';
import 'player_ui_controller.dart';
import 'seek_rectangle_clipper.dart';

class CustomMaterialControls extends StatefulWidget {
  final String title;
  final String subtitle;
  final PlayerUIController uiController;

  const CustomMaterialControls({
    Key key,
    @required this.title,
    this.subtitle,
    @required this.uiController,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomMaterialControlsState();
  }
}

class _CustomMaterialControlsState extends State<CustomMaterialControls> {
  VideoPlayerValue _latestValue;
  Duration _latestPosition;
  double _latestVolume;
  bool _hideStuff = true;
  Duration _hideStuffAnimationDuration = const Duration(milliseconds: 300);
  Timer _hideTimer;
  Timer _initTimer;
  Timer _showAfterExpandCollapseTimer;

  // bool _dragging = false;

  final barHeight = 48.0;
  final marginSize = 5.0;

  final _rewindDuration = 10;
  final _forwardDuration = 10;

  int _rewindValue = 0;
  int _forwardValue = 0;
  Timer _buttonSeekTimer;
  bool _seekUIVisible = false;
  bool _wasPlayingBeforeSeek = false;
  bool _wasControlsVisibleBeforeSeek = false;

  bool get isSeekingForward => _forwardValue > 0;

  bool get isSeekingBackward => _rewindValue > 0;

  bool get isSeeking => isSeekingForward || isSeekingBackward;

  bool _showPipButton = false;

  VideoPlayerController controller;
  ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    FlutterAutoPip.isPipSupported().then((value) {
      if (value && mounted) {
        setState(() {
          _showPipButton = true;
        });
      }
    });
  }

  void _uiControllerListener() {
    if (widget.uiController.hideControls) {
      setState(() {
        _hideStuff = true;
        _hideStuffAnimationDuration = Duration.zero;
        _hideTimer?.cancel();
      });
      _hideStuffAnimationDuration = const Duration(milliseconds: 300);
    }
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
                  const Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 42,
                  ),
                  const SizedBox(height: 10),
                  Text(_latestValue.errorDescription),
                ],
              ),
            );
    }

    GestureTapCallback onTap = () {
      if (_latestValue?.isPlaying == true) {
        _cancelAndRestartTimer();
      } else {
        _showStuff();
      }
    };

    return MouseRegion(
      onHover: (_) {
        _cancelAndRestartTimer();
      },
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            // Process click events when player UI isn't visible
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    onDoubleTapDown: (_) {
                      _showSeekUI();
                      _seekBackwardTick();
                      _cancelAndRestartButtonSeekTimer();
                    },
                    onDoubleTap: () {},
                  ),
                ),
                SizedBox(
                  width: 80.0,
                  child: GestureDetector(
                    onTap: onTap,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    onDoubleTapDown: (_) {
                      _showSeekUI();
                      _seekForwardTick();
                      _cancelAndRestartButtonSeekTimer();
                    },
                    onDoubleTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: _hideStuff,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(child: _buildHitArea()),
                  Positioned.fill(
                    child: _latestValue != null &&
                                !_latestValue.isPlaying &&
                                _latestValue.duration == null ||
                            _latestValue.isBuffering ||
                            isSeeking
                        ? const Center(
                            child: CircularProgressIndicator(),
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
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !_seekUIVisible,
              child: AnimatedOpacity(
                opacity: _seekUIVisible ? 1.0 : 0.0,
                duration: _hideStuffAnimationDuration,
                child: Row(
                  children: [
                    Expanded(
                      child: Opacity(
                        opacity: isSeekingBackward ? 1 : 0,
                        child: ClipPath(
                          clipper: SeekRectangleArcClipper(
                              side: AxisDirection.right),
                          child: Material(
                            color: Colors.white.withAlpha(25),
                            child: InkWell(
                              onTap: () {},
                              onTapDown: (_) {
                                _seekBackwardTick();
                                _cancelAndRestartButtonSeekTimer();
                              },
                              splashColor: Colors.white.withAlpha(50),
                              child: Center(
                                child: Text(
                                  '$_rewindValue seconds',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Opacity(
                        opacity: isSeekingForward ? 1 : 0,
                        child: ClipPath(
                          clipper:
                              SeekRectangleArcClipper(side: AxisDirection.left),
                          child: Material(
                            color: Colors.white.withAlpha(25),
                            child: InkWell(
                              onTap: () {},
                              onTapDown: (_) {
                                _seekForwardTick();
                                _cancelAndRestartButtonSeekTimer();
                              },
                              splashColor: Colors.white.withAlpha(50),
                              splashFactory: InkSplash.splashFactory,
                              child: Center(
                                child: Text(
                                  '$_forwardValue seconds',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
    _buttonSeekTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
    _rewindValue = 0;
    _forwardValue = 0;
    _seekUIVisible = false;
    widget.uiController.removeListener(_uiControllerListener);
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
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: _hideStuffAnimationDuration,
      child: SizedBox(
        height: 58,
        child: Row(
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
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      widget.subtitle ?? '',
                      style: const TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildQualityButton(),
            if (_showPipButton) _buildPipButton(),
            PlayerCircleButton(
              child: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'copy_link') {
                    Clipboard.setData(
                        ClipboardData(text: controller.dataSource));
                    Scaffold.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text('URL copied to clipboard'),
                          duration: Duration(seconds: 2),
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
                  } else if (value == 'change_speed') {
                    final wasPlaying = _latestValue?.isPlaying ?? false;

                    if (wasPlaying) {
                      _pause();
                    }

                    final chosenSpeed = await showCustomMaterialSheet<double>(
                      context: context,
                      useRootNavigator: true,
                      builder: (context) => PlayerChooserDialog<double>(
                        values: {
                          for (var v in chewieController.playbackSpeeds)
                            v: v == 1.0 ? 'Normal' : v.toString()
                        },
                        selected: _latestValue.playbackSpeed,
                      ),
                    );

                    if (chosenSpeed != null) {
                      controller.setPlaybackSpeed(chosenSpeed);
                    }

                    if (wasPlaying) {
                      _play();
                    }
                  }
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'open_external',
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 120.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.open_in_new_rounded,
                              color: Theme.of(context)
                                  .iconTheme
                                  .color
                                  .withOpacity(0.8),
                            ),
                            const SizedBox(width: 10),
                            const Text('Open with'),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'copy_link',
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 120.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.copy_rounded,
                              color: Theme.of(context)
                                  .iconTheme
                                  .color
                                  .withOpacity(0.8),
                            ),
                            const SizedBox(width: 10),
                            const Text('Copy Link'),
                          ],
                        ),
                      ),
                    ),
                    if (chewieController.allowPlaybackSpeedChanging)
                      PopupMenuItem<String>(
                        value: 'change_speed',
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 120.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.speed,
                                color: Theme.of(context)
                                    .iconTheme
                                    .color
                                    .withOpacity(0.8),
                              ),
                              const SizedBox(width: 10),
                              const Text('Speed'),
                            ],
                          ),
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
      child: SizedBox(
        height: barHeight,
        child: Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14.0),
          child: Row(
            children: <Widget>[
              chewieController.isLive
                  ? const Expanded(child: Text('LIVE'))
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
      ),
    );
  }

  Widget _buildPipButton() {
    Future<void> _launchPipPermissionIntent() async {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      android_intent.Intent()
        ..setAction('android.settings.PICTURE_IN_PICTURE_SETTINGS')
        ..setData(Uri.parse("package:${packageInfo.packageName}"))
        ..startActivity().catchError((e) {
          print(e);
        });
    }

    return PlayerCircleButton(
      child: IconButton(
        icon: const Icon(Icons.picture_in_picture_alt),
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
                        _launchPipPermissionIntent();
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

  Widget _buildQualityButton() {
    return PlayerCircleButton(
      child: IconButton(
        icon: const Icon(Icons.high_quality),
        color: Colors.white,
        tooltip: 'Quality',
        onPressed: () async {
          if (_latestValue?.isPlaying ?? false) {
            _pause();
          }

          final chosenQuality = await showCustomMaterialSheet<int>(
            context: context,
            useRootNavigator: true,
            builder: (context) => const PlayerChooserDialog<int>(
              values: {
                480: '480p',
                720: '720p',
                1080: '1080p',
              },
              selected: 720,
            ),
          );

          if (chosenQuality != null) {
            // TODO
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
        children: [
          // _buildRewindButton(),
          _buildPlayPause(),
          // _buildForwardButton(),
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
              style: const TextStyle(color: Colors.white),
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
              style: const TextStyle(color: Colors.white),
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
      _isFinished = _latestPosition >= _latestValue.duration;
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

  // Process click events when player UI is visible
  Widget _buildHitArea() {
    GestureTapCallback onTap = () {
      setState(() {
        _hideStuff = true;
      });
    };

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: _hideStuff ? 0.0 : 1.0,
            duration: _hideStuffAnimationDuration,
            child: Container(
              color: Colors.black54,
            ),
          ),
        ),
        Positioned.fill(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  onDoubleTapDown: (_) {
                    _showSeekUI();
                    _seekBackwardTick();
                    _cancelAndRestartButtonSeekTimer();
                  },
                  onDoubleTap: () {},
                ),
              ),
              SizedBox(
                width: 80.0,
                child: GestureDetector(
                  onTap: onTap,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  onDoubleTapDown: (_) {
                    _showSeekUI();
                    _seekForwardTick();
                    _cancelAndRestartButtonSeekTimer();
                  },
                  onDoubleTap: () {},
                ),
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildPosition() {
    var position = _latestPosition ?? Duration.zero;
    if (isSeeking) {
      final _seeked = isSeekingForward ? _forwardValue : -_rewindValue;
      position = position + Duration(seconds: _seeked);
    }
    final duration = _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration
        : Duration.zero;

    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Text(
        '${formatDuration(position)} / ${formatDuration(duration)}',
        style: const TextStyle(
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
    });
  }

  void _cancelAndRestartButtonSeekTimer() {
    _buttonSeekTimer?.cancel();
    _startButtonSeekTimer();
  }

  void _showSeekUI() {
    _wasControlsVisibleBeforeSeek = !_hideStuff;
    _wasPlayingBeforeSeek = controller.value.isPlaying;
    if (_wasPlayingBeforeSeek) {
      controller.pause();
    }
    _showStuff();
    setState(() {
      _seekUIVisible = true;
    });
  }

  void _hideSeekUI() {
    if (_wasPlayingBeforeSeek) {
      controller.play();
    }
    setState(() {
      if (_wasPlayingBeforeSeek || !_wasControlsVisibleBeforeSeek) {
        _hideTimer?.cancel();
        _hideStuff = true;
      }
      _seekUIVisible = false;
    });
  }

  void _seekBackwardTick() {
    setState(() {
      _forwardValue = 0;
      _rewindValue += _rewindDuration;
    });

    if (_wasPlayingBeforeSeek) {
      _cancelAndRestartTimer();
    } else {
      _showStuff();
    }
  }

  void _seekForwardTick() {
    setState(() {
      _rewindValue = 0;
      _forwardValue += _forwardDuration;
    });

    if (_wasPlayingBeforeSeek) {
      _cancelAndRestartTimer();
    } else {
      _showStuff();
    }
  }

  Future<void> _initialize() async {
    controller.addListener(_updateState);
    widget.uiController.addListener(_uiControllerListener);

    _updateState();

    if ((controller.value != null && controller.value.isPlaying) ||
        chewieController.autoPlay) {
      _startHideTimer();
    }

    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
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
      _showAfterExpandCollapseTimer = Timer(const Duration(milliseconds: 300), () {
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
    final isFinished = _latestPosition >= _latestValue.duration;

    _cancelAndRestartTimer();

    if (!controller.value.initialized) {
      controller.initialize().then((_) {
        controller.play();
      });
    } else {
      if (isFinished) {
        controller.seekTo(const Duration());
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
      const Duration(milliseconds: 600),
      () async {
        _hideSeekUI();

        if (_forwardValue == 0 && _rewindValue == 0) return;

        if (_forwardValue > 0) {
          await controller
              .seekTo(_latestPosition + Duration(seconds: _forwardValue));
        } else {
          await controller
              .seekTo(_latestPosition - Duration(seconds: _rewindValue));
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
      if (_latestValue.position != null &&
          _latestValue.position != _latestPosition) {
        _latestPosition = _latestValue.position;
      }
    });
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
        child: MaterialVideoProgressBar(
          controller,
          rewindValue: _rewindValue,
          forwardValue: _forwardValue,
          onDragStart: () {
            // setState(() {
            //   _dragging = true;
            // });

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            // setState(() {
            //   _dragging = false;
            // });

            _startHideTimer();
          },
          onTap: () {
            _cancelAndRestartTimer();
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

class PlayerChooserDialog<T> extends StatelessWidget {
  const PlayerChooserDialog({
    Key key,
    this.values,
    this.selected,
  }) : super(key: key);

  final Map<T, String> values;
  final T selected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color selectedColor = theme.brightness == Brightness.light
        ? theme.primaryColor
        : theme.accentColor;

    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        final _key = values.keys.elementAt(index);
        final _value = values[_key];
        return ListTile(
          dense: true,
          title: Row(
            children: [
              _key == selected
                  ? Icon(
                      Icons.check,
                      size: 20.0,
                      color: selectedColor,
                    )
                  : Container(width: 20.0),
              const SizedBox(width: 16.0),
              Text(_value),
            ],
          ),
          selected: _key == selected,
          onTap: () {
            Navigator.of(context).pop(_key);
          },
        );
      },
      itemCount: values.length,
    );
  }
}
