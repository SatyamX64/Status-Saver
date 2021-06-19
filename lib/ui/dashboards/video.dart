import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:status_saver/constants.dart';
import 'package:status_saver/screens/view_video_screen.dart';

class VideoDashBoard extends StatelessWidget {
  VideoDashBoard({Key? key}) : super(key: key);

  final Directory _videoDir = Directory(statusPath);
  Future<String?> _getThumbnail(String videoPathUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoPathUrl);

    final file = File(thumbnail ?? '');
    final String filePath = file.path;
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoDir.existsSync()) {
      return Center(
        child: FittedBox(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Install WhatsApp ",
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
      final videoList = _videoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.mp4'))
          .toList(growable: false);
      if (videoList.isNotEmpty) {
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
                                File(snapshot.data! as String),
                                fit: BoxFit.cover,
                              ),
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
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ),
              );
            },
            staggeredTileBuilder: (i) => const StaggeredTile.count(2, 3),
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
                    text: "No Videos Found ",
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
