import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:status_saver/constants.dart';
import 'package:status_saver/screens/view_photo_screen.dart';

class ImageDashBoard extends StatelessWidget {
  ImageDashBoard({Key? key}) : super(key: key);

  final Directory _photoDir = Directory(statusPath);
  @override
  Widget build(BuildContext context) {
    if (!_photoDir.existsSync()) {
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
      final imageList = _photoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.jpg'))
          .toList(growable: false);
      if (imageList.isNotEmpty) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          child: StaggeredGridView.countBuilder(
            itemCount: imageList.length,
            crossAxisCount: 4,
            itemBuilder: (context, index) {
              final imgPath = imageList[index];
              return Material(
                elevation: 8.0,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPhotoScreen(
                          imgPath: imgPath,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Hero(
                      tag: imgPath,
                      child: Image.file(
                        File(imgPath),
                        fit: BoxFit.cover,
                      ),
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
                    text: "No Image Found ",
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
