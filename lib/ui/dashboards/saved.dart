import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:status_saver/screens/view_photo_screen.dart';
import 'package:status_saver/screens/view_video_screen.dart';
import '../../constants.dart';

class SavedDashBoard extends StatefulWidget {
  const SavedDashBoard({Key? key}) : super(key: key);

  @override
  _SavedDashBoardState createState() => _SavedDashBoardState();
}

class _SavedDashBoardState extends State<SavedDashBoard> {
  final Directory _savedDir = Directory(savePath);

  Future<String?> _getThumbnail(String videoPathUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(video: videoPathUrl);

    final file = File(thumbnail ?? '');
    final String filePath = file.path;
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    if (!_savedDir.existsSync()) {
      return Center(
        child: FittedBox(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Nothing Saved Yet ",
                  style: Theme.of(context).textTheme.headline6,
                ),
                TextSpan(
                  text: "ʕノ•ᴥ•ʔノ",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontFamily: ''),
                ),
              ],
            ),
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

      if (savedContentList.isNotEmpty) {
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
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  File(contentPath).deleteSync();
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(16),
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(4)),
                                height: 80,
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  onTap: contentPath.endsWith('.jpg')
                      ? () async {
                          final isDeleted = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewPhotoScreen(
                                imgPath: contentPath,
                                isSaved: true,
                              ),
                            ),
                          );
                          if (isDeleted != null && isDeleted == true) {
                            setState(() {});
                          }
                        }
                      : () async {
                          final isDeleted = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewVideoScreen(
                                videoFilePath: contentPath,
                                isSaved: true,
                              ),
                            ),
                          );
                          if (isDeleted != null && isDeleted == true) {
                            setState(() {});
                          }
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
                                        constraints: const BoxConstraints.expand(),
                                        child: Hero(
                                          tag: contentPath,
                                          child: Image.file(
                                            File(snapshot.data! as String),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(fontFamily: ''),
                                    ),
                                  );
                                }
                              } else {
                                return const Center(
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
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Nothing Saved Yet ",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  TextSpan(
                    text: "ʕノ•ᴥ•ʔノ",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontFamily: ''),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }
}
