import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';

class PlayerWidget extends StatefulWidget {
  final String url;
  final String title;

  const PlayerWidget({super.key, required this.url, required this.title});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> with WidgetsBindingObserver {
  bool playerState = true;
  double volume = 0;
  double brightness = 0;
  late double initialBrightness;
  late double initialVolume;

  bool showBrightnessIndicator = false;
  bool showVolumeIndicator = false;
  bool showInfoPanel = false;
  bool isPaused = false;
  Timer? _hideTimerBrightness;
  Timer? _hideTimerVolume;
  Timer? _hideTimerInfo;

  double currentVolume = 0;
  double currentBrightness = 0;

  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  //Chewie [Mobile]
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  //Web Media Kit
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getInitialBrightness();
    _getInitialVolume();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });

    if (kIsWeb) {
      player.open(Media(widget.url));
      return;
    }

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      aspectRatio: 16 / 9,
      showControls: false,
      isLive: true,
      autoInitialize: true,
      fullScreenByDefault: true,
      errorBuilder: (context, errorMessage) {
        return const Center(
          child: Text(
            'Error loading video',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
    _chewieController.play();

    _videoPlayerController.initialize().then((_) {
      setState(() {});
    }).catchError((err) {});
  }

  Future<void> _getInitialBrightness() async {
    try {
      initialBrightness = await ScreenBrightness().current;
      setState(() {
        brightness = initialBrightness;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _getInitialVolume() {
    try {
      VolumeController().getVolume().then((vol) {
        setState(() {
          volume = vol;
          initialVolume = vol;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _setBrightness(initialBrightness);
    _setVolume(initialVolume);

    _hideTimerBrightness?.cancel();
    _hideTimerVolume?.cancel();
    _hideTimerInfo?.cancel();
    _timer.cancel();

    _videoPlayerController.dispose();
    _chewieController.dispose();
    player.dispose();
    VolumeController().removeListener();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.hidden) {
      if (!kIsWeb && _videoPlayerController.value.isInitialized) {
        _chewieController.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (!kIsWeb && _videoPlayerController.value.isInitialized) {
        _chewieController.play();
      }
    }
  }

  Future<void> _setBrightness(double brightness) async {
    try {
      brightness = brightness.clamp(0.0, 1.0);
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _setVolume(double value) {
    try {
      volume = volume.clamp(0.0, 1.0);
      VolumeController().showSystemUI = false;
      VolumeController().setVolume(value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _showBrightnessIndicator() {
    setState(() {
      showBrightnessIndicator = true;
    });
    _hideTimerBrightness?.cancel();
    _hideTimerBrightness = Timer(const Duration(seconds: 2), () {
      setState(() {
        showBrightnessIndicator = false;
      });
    });
  }

  void _showVolumeIndicator() {
    setState(() {
      showVolumeIndicator = true;
    });
    _hideTimerVolume?.cancel();
    _hideTimerVolume = Timer(const Duration(seconds: 2), () {
      setState(() {
        showVolumeIndicator = false;
      });
    });
  }

  void _showInfoPanel() {
    setState(() {
      if (showInfoPanel) {
        _hideTimerInfo?.cancel();
        showInfoPanel = false;
      } else {
        showInfoPanel = true;
        _hideTimerInfo?.cancel();
        _hideTimerInfo = Timer(const Duration(seconds: 5), () {
          setState(() {
            showInfoPanel = false;
          });
        });
      }
    });
  }

  void seek(int duration) {
    if (kIsWeb) {
      player.seek(Duration(seconds: duration));
    } else {
      _videoPlayerController
          .seekTo(Duration(seconds: _videoPlayerController.value.position.inSeconds + duration));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Center(
                child: kIsWeb
                    ? Video(controller: controller)
                    : _videoPlayerController.value.isInitialized
                        ? Chewie(controller: _chewieController)
                        : const CircularProgressIndicator()),
            DetailsOverlay(),
            mediaControls(context)
          ],
        ),
      ),
    );
  }

  Positioned mediaControls(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Positioned.fill(
      child: Row(
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () {
                _showInfoPanel();
              },
              onVerticalDragUpdate: (details) {
                double sensitivity = 0.005;
                setState(() {
                  brightness -= details.delta.dy * sensitivity;
                  brightness = brightness.clamp(0.0, 1.0);
                  _setBrightness(brightness);
                  _showBrightnessIndicator();
                });
              },
              child: AnimatedOpacity(
                opacity: showBrightnessIndicator ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: showBrightnessIndicator
                        ? const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0x63000000),
                              Color(0x00000000),
                            ],
                          )
                        : null,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: (screenWidth / 20)),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: LinearPercentIndicator(
                            percent: brightness,
                            lineHeight: 30,
                            width: 250,
                            leading: RotatedBox(
                                quarterTurns: -3,
                                child: IconButton(
                                  onPressed: () {
                                    if (showBrightnessIndicator) {
                                      setState(() {
                                        if (brightness > 0) {
                                          currentBrightness = brightness;
                                          brightness = 0;
                                        } else {
                                          brightness = currentBrightness;
                                        }
                                        _setBrightness(brightness);
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    brightness == 0
                                        ? Icons.brightness_low
                                        : brightness > 0 && brightness <= 0.5
                                            ? Icons.brightness_medium
                                            : brightness > 0.5 && brightness <= 0.7
                                                ? Icons.brightness_high
                                                : Icons.brightness_high,
                                    color: Colors.white,
                                  ),
                                )),
                            barRadius: const Radius.circular(8),
                            backgroundColor: Colors.grey.withValues(alpha: 0.1),
                            progressColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 300,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    _showInfoPanel();
                  },
                ),
                AnimatedOpacity(
                  opacity: showInfoPanel ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (showInfoPanel) {
                              setState(() {
                                if (brightness > 0) {
                                  currentBrightness = brightness;
                                  brightness = 0;
                                } else {
                                  brightness = currentBrightness;
                                }
                                _setBrightness(brightness);
                              });
                            }
                          },
                          icon: Icon(
                            brightness == 0
                                ? Icons.brightness_low
                                : brightness > 0 && brightness <= 0.5
                                    ? Icons.brightness_medium
                                    : brightness > 0.5 && brightness <= 0.7
                                        ? Icons.brightness_high
                                        : Icons.brightness_high,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          color: Colors.white,
                          onPressed: () {
                            seek(-3);
                          },
                          icon: const Icon(Icons.keyboard_double_arrow_left),
                        ),
                        IconButton(
                          onPressed: () {
                            if (showInfoPanel) {
                              kIsWeb
                                  ? playerState
                                      ? player.pause()
                                      : player.play()
                                  : playerState
                                      ? _chewieController.pause()
                                      : _chewieController.play();

                              setState(() {
                                playerState = !playerState;
                              });
                            }
                          },
                          color: Colors.white,
                          iconSize: 30,
                          icon: Icon(playerState ? Icons.pause : Icons.play_arrow),
                        ),
                        IconButton(
                          color: Colors.white,
                          onPressed: () {
                            seek(3);
                          },
                          icon: const Icon(Icons.keyboard_double_arrow_right),
                        ),
                        RotatedBox(
                          quarterTurns: 0,
                          child: IconButton(
                            onPressed: () {
                              if (showInfoPanel) {
                                setState(() {
                                  if (volume > 0) {
                                    currentVolume = volume;
                                    volume = 0;
                                  } else {
                                    volume = currentVolume;
                                  }
                                  _setVolume(volume);
                                });
                              }
                            },
                            icon: Icon(
                              volume == 0
                                  ? Icons.volume_off
                                  : volume > 0 && volume <= 0.5
                                      ? Icons.volume_down
                                      : volume > 0.5 && volume <= 0.7
                                          ? Icons.volume_up
                                          : Icons.volume_up,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                _showInfoPanel();
              },
              onVerticalDragUpdate: (details) {
                double sensitivity = 0.005;
                setState(() {
                  volume -= details.delta.dy * sensitivity;
                  volume = volume.clamp(0.0, 1.0);
                  _setVolume(volume);
                  _showVolumeIndicator();
                });
              },
              child: AnimatedOpacity(
                opacity: showVolumeIndicator ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: showVolumeIndicator
                        ? const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0x00000000),
                              Color(0x62000000),
                            ],
                          )
                        : null,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: (screenWidth / 20)),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: LinearPercentIndicator(
                            percent: volume,
                            lineHeight: 30,
                            width: 250,
                            leading: RotatedBox(
                              quarterTurns: -3,
                              child: IconButton(
                                onPressed: () {
                                  if (showVolumeIndicator) {
                                    setState(() {
                                      if (volume > 0) {
                                        currentVolume = volume;
                                        volume = 0;
                                      } else {
                                        volume = currentVolume;
                                      }
                                      _setVolume(volume);
                                    });
                                  }
                                },
                                icon: Icon(
                                  volume == 0
                                      ? Icons.volume_off
                                      : volume > 0 && volume <= 0.5
                                          ? Icons.volume_down
                                          : volume > 0.5 && volume <= 0.7
                                              ? Icons.volume_up
                                              : Icons.volume_up,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            barRadius: const Radius.circular(8),
                            backgroundColor: Colors.grey.withValues(alpha: 0.1),
                            progressColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Positioned DetailsOverlay() {
    return Positioned.fill(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: showInfoPanel ? 1.0 : 0,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xB6000000),
              Color(0x00000000),
              Color(0x00000000),
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 40, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _currentTime
                          .add(const Duration(hours: 1))
                          .toLocal()
                          .toString()
                          .split(' ')[1]
                          .split('.')[0],
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
