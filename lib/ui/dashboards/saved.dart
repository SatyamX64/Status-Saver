import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whatsapp_helper/screens/view_photo_screen.dart';
import 'package:whatsapp_helper/screens/view_video_screen.dart';
import 'dart:io';
import '../../constants.dart';

class SavedDashBoard extends StatelessWidget {
  SavedDashBoard({Key? key}) : super(key: key);
  final Directory _savedDir = Directory(savePath);
  Future<String?> _getThumbnail(videoPathUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoPathUrl, imageFormat: ImageFormat.PNG);

    final file = File(thumbnail ?? '');
    String filePath = file.path;
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory('${_savedDir.path}').existsSync()) {
      return Center(
        child: FittedBox(
          child: Text(
            "Nothing Saved Yet ʕノ•ᴥ•ʔノ",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      );
    } else {
      final imageList = _savedDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.jpg'))
          .toList(growable: false);
      final videoList = _savedDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.mp4'))
          .toList(growable: false);

      final savedContentList =
          List<String>.from((imageList + videoList).reversed);
      // Contains the Path of all the Saved Content

      if (savedContentList.length > 0) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          child: StaggeredGridView.countBuilder(
            itemCount: savedContentList.length,
            crossAxisCount: 4,
            itemBuilder: (context, index) {
              final contentPath = savedContentList[index];
              return Material(
                elevation: 8.0,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                child: InkWell(
                  onTap: contentPath.endsWith('.jpg')
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewPhotoScreen(
                                imgPath: contentPath,
                                isSaved: true,
                              ),
                            ),
                          );
                        }
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewVideoScreen(
                                videoFilePath: contentPath,
                                isSaved: true,
                              ),
                            ),
                          );
                        },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: contentPath.endsWith('.jpg')
                        ? Hero(
                            tag: contentPath,
                            child: Image.file(
                              File(contentPath),
                              fit: BoxFit.cover,
                            ),
                          )
                        : FutureBuilder(
                            future: _getThumbnail(contentPath),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return Stack(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints.expand(),
                                        child: Hero(
                                          tag: contentPath,
                                          child: Image.file(
                                            File(snapshot.data as String),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.videocam,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      "⚆ _ ⚆",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  );
                                }
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                  ),
                ),
              );
            },
            staggeredTileBuilder: (i) =>
                StaggeredTile.count(2, i.isEven ? 2 : 3),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
        );
      } else {
        return Center(
          child: FittedBox(
            child: Text(
              "Nothing Saved Yet ʕノ•ᴥ•ʔノ",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        );
      }
    }
  }
}
