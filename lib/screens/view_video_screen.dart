import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_helper/constants.dart';
import '../utils/my_video_player.dart';

class ViewVideoScreen extends StatefulWidget {
  static const route = '/view-video-screen';
  final String videoFilePath;
  const ViewVideoScreen({
    Key? key,
    required this.videoFilePath,
  }) : super(key: key);
  @override
  _ViewVideoScreenState createState() => _ViewVideoScreenState();
}

class _ViewVideoScreenState extends State<ViewVideoScreen> {
  bool _isLoading = false;
  late FToast fToast;
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _showToast({required bool success}) {
    fToast.removeCustomToast();
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: success ? Color(0xFF25D366) : Colors.red,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: success
            ? [
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
            : [
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
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            bottom: 76,
            left: 0,
            right: 0,
          );
        });
  }

  _saveVideo() async {
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
      final newFileName = savePath + '/VIDEO-$timestamp.mp4';
      await originalVideoFile.copy(newFileName);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showToast(success: false);
      print('Exception Error while saving video' + e.toString());
      return;
    }
    setState(() {
      _isLoading = false;
    });
    _showToast(success: true);
    return;
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
              decoration: BoxDecoration(
                color: Colors.black54,
              ),
              child: Row(
                children: [
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.download),
                    onPressed: _saveVideo,
                  ),
                  IconButton(
                      icon: Icon(Icons.share),
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
