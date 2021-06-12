import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whatsapp_helper/constants.dart';
import 'package:whatsapp_helper/screens/view_video_screen.dart';

class VideoDashBoard extends StatelessWidget {
  VideoDashBoard({Key? key}) : super(key: key);

  final Directory _videoDir = Directory(statusPath);
  Future<String?> _getThumbnail(videoPathUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoPathUrl, imageFormat: ImageFormat.PNG);

    final file = File(thumbnail ?? '');
    String filePath = file.path;
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory('${_videoDir.path}').existsSync()) {
      return Center(
        child: FittedBox(
          child: Text(
            "Install WhatsApp ʕノ•ᴥ•ʔノ",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      );
    } else {
      final videoList = _videoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.mp4'))
          .toList(growable: false);
      if (videoList.length > 0) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          child: StaggeredGridView.countBuilder(
            itemCount: videoList.length,
            crossAxisCount: 4,
            itemBuilder: (context, index) {
              return Material(
                elevation: 8.0,
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewVideoScreen(
                          videoFilePath: videoList[index],
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: FutureBuilder(
                      future: _getThumbnail(videoList[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Hero(
                              tag: videoList[index],
                              child: Image.file(
                                File(snapshot.data as String),
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return Center(
                              child: Text(
                                "⚆ _ ⚆",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            );
                          }
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ),
              );
            },
            staggeredTileBuilder: (i) => StaggeredTile.count(2, 3),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
        );
      } else {
        return Center(
          child: FittedBox(
            child: Text(
              "No Videos Found ʕノ•ᴥ•ʔノ",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        );
      }
    }
  }
}
