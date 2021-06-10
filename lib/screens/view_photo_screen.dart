import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ViewPhotoScreen extends StatefulWidget {
  static const route = '/view-photo-screen';
  final String imgPath;
  const ViewPhotoScreen({
    Key? key,
    required this.imgPath,
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
    final myUri = Uri.parse(widget.imgPath);
    final originalImageFile = File.fromUri(myUri);
    late Uint8List bytes;
    await originalImageFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      _showToast(success: false);
      print('Exception Error while reading bytes from path:' +
          onError.toString());
      return;
    });
    await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));
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
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.black54],
                ),
              ),
              child: Row(
                children: [
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.download),
                    onPressed: _saveImage,
                  ),
                  IconButton(icon: Icon(Icons.share), onPressed: () {})
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
