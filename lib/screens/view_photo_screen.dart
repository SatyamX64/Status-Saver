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

  Future<void> _saveImage() async {
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
      final newFileName = '$savePath/IMAGE-$timestamp.jpg';
      await originalImageFile.copy(newFileName);
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
      File(widget.imgPath).deleteSync();
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
                      onPressed: _saveImage,
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
