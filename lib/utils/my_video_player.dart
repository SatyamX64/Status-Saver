import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class MyVideoPlayer extends StatefulWidget {
  final String path;

  MyVideoPlayer({Key ?key, required this.path}) : super(key: key);

  @override
  _MyVideoPlayerState createState() => new _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late Future<void> _future;

  Future<void> initVideoPlayer() async {
    await _videoPlayerController.initialize();
    setState(() {
      print(_videoPlayerController.value.aspectRatio);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(File(widget.path));
    _future = initVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return Center(
            child: _videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  )
                :  CircularProgressIndicator(),
          );
        });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
