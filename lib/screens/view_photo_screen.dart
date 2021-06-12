import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/constants.dart';

class ViewPhotoScreen extends StatefulWidget {
  static const route = '/view-photo-screen';
  final String imgPath;
  final bool isSaved;
  const ViewPhotoScreen({
    Key? key,
    required this.imgPath,
    this.isSaved = false,
  }) : super(key: key);

  @override
  _ViewPhotoScreenState createState() => _ViewPhotoScreenState();
}

class _ViewPhotoScreenState extends State<ViewPhotoScreen> {
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

  _saveImage() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final myUri = Uri.parse(widget.imgPath);
      final originalImageFile = File.fromUri(myUri);
      if (!Directory(savePath).existsSync()) {
        Directory(savePath).createSync(recursive: true);
      }
      final timestamp = DateTime.now().toString();
      final newFileName = savePath + '/IMAGE-$timestamp.jpg';
      await originalImageFile.copy(newFileName);
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
          Center(
            child: Hero(
              tag: widget.imgPath,
              child: Image.file(
                File(widget.imgPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                  Visibility(
                    visible: !widget.isSaved,
                    child: IconButton(
                      icon: Icon(Icons.download),
                      onPressed: _saveImage,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () async {
                        try {
                          await Share.shareFiles([widget.imgPath], text: '');
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
