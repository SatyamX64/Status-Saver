import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/constants.dart';
import '../utils/my_video_player.dart';

class ViewVideoScreen extends StatefulWidget {
  static const route = '/view-video-screen';
  final String videoFilePath;
  final bool isSaved;
  const ViewVideoScreen({
    Key? key,
    required this.videoFilePath,
    this.isSaved = false,
  }) : super(key: key);
  @override
  _ViewVideoScreenState createState() => _ViewVideoScreenState();
}

class _ViewVideoScreenState extends State<ViewVideoScreen> {
  bool _isLoading = false;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  void _showToast({required bool success}) {
    fToast.removeCustomToast();
    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: success ? const Color(0xFF25D366) : Colors.red,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: success
            ? const [
                Icon(Icons.check),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  "Done",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]
            : const [
                Icon(Icons.error_outline),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  "Failed",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
      ),
    );

    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            bottom: 76,
            left: 0,
            right: 0,
            child: child,
          );
        });
  }

  Future<void> _saveVideo() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final originalVideoFile = File(widget.videoFilePath);
      if (!Directory(savePath).existsSync()) {
        Directory(savePath).createSync(recursive: true);
      }
      final timestamp = DateTime.now().toString();
      final newFileName = '$savePath/VIDEO-$timestamp.mp4';
      await originalVideoFile.copy(newFileName);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showToast(success: false);
      return;
    }
    setState(() {
      _isLoading = false;
    });
    _showToast(success: true);
    return;
  }

  void _deleteImage() {
    try {
      File(widget.videoFilePath).deleteSync();
    } catch (e) {
      _showToast(success: false);
      return;
    }
    Navigator.of(context).pop(
        true); // returns true if image is deleted, saved Screen rebuilds in this case
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MyVideoPlayer(path: widget.videoFilePath),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.black54,
              ),
              child: Row(
                children: [
                  const Spacer(),
                  Visibility(
                    visible: !widget.isSaved,
                    child: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: _saveVideo,
                    ),
                  ),
                  Visibility(
                    visible: widget.isSaved,
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _deleteImage,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () async {
                        try {
                          await Share.shareFiles([widget.videoFilePath],
                              text: '');
                        } catch (e) {
                          _showToast(success: false);
                        }
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
