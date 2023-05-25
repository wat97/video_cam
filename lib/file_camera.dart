import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FileCamera extends StatefulWidget {
  XFile argsFile;
  FileCamera({
    super.key,
    required this.argsFile,
  });

  @override
  State<FileCamera> createState() => _FileCameraState();
}

class _FileCameraState extends State<FileCamera> {
  Size? size;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      setState(() {
        size = MediaQuery.of(context).size;

        _controller = VideoPlayerController.file(File(widget.argsFile.path));
        _initializeVideoPlayerFuture = _controller.initialize();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (size == null) return Container();
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: size != null ? size!.height * 0.1 : 90,
              color: Colors.blue,
              child: const Center(
                child: Text(
                  "Preview Camera",
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            contentPage(),
          ],
        ),
      ),
    );
  }

  Widget contentPage() {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: size!.height * 0.5,
            child: VideoPlayer(_controller),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: GestureDetector(
                  onTap: () async {
                    _controller.play();
                  },
                  child: Icon(
                    Icons.play_arrow,
                    size: size!.width * 0.2,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: GestureDetector(
                  onTap: () async {
                    _controller.pause();
                  },
                  child: Icon(
                    Icons.pause,
                    size: size!.width * 0.2,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: GestureDetector(
                  onTap: () async {},
                  child: Icon(
                    Icons.stop,
                    size: size!.width * 0.2,
                  ),
                ),
              ),
            ],
          )
          // VideoPlayer(_controller),
        ],
      ),
    );
  }
}
