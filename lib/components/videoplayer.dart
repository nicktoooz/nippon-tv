import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  final String url;

  const VideoPlayer({super.key, required this.url});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  //Chewie [Mobile]
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  //Web Media Kit
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();

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
    }).catchError((err) {
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? Video(controller: controller) : Chewie(controller: _chewieController);
  }
}
