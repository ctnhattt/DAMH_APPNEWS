import 'package:flutter/material.dart';
import 'package:itnew/Models/Video.dart';
import 'package:video_player/video_player.dart';

class VideoTitle extends StatefulWidget {
  final Video video;
  const VideoTitle({
    super.key,
    required this.video,
  });

  @override
  State<VideoTitle> createState() => _VideoTitleState();
}

class _VideoTitleState extends State<VideoTitle> {
  late VideoPlayerController _videoPlayerController;

  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.videoUrl),
    )..initialize().then((_) {
        setState(() {
          // Đảm bảo rằng video đã được khởi tạo trước khi hiển thị
        });
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _pausePlayVideo() {
    setState(() {
      _isVideoPlaying = !_isVideoPlaying;
      if (_isVideoPlaying) {
        _videoPlayerController.play();
      } else {
        _videoPlayerController.pause();
      }
    });
  }

  // void _pausePlayVideo() {
  //   _isVideoPlaying ? _videoPlayerController.pause() : _videoPlayerController.play();

  //   setState(() {
  //     _isVideoPlaying = !_isVideoPlaying;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _videoPlayerController.value.isInitialized
          ? GestureDetector(
              onTap: _pausePlayVideo,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                  if (!_isVideoPlaying)
                    IconButton(
                      onPressed: _pausePlayVideo,
                      icon: Icon(Icons.play_arrow),
                      color:
                          Colors.white.withOpacity(_isVideoPlaying ? 0 : 0.5),
                      iconSize: 70,
                    ),
                ],
              ),
            )
          : null,
    );
  }
}
