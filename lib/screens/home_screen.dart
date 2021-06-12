import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:status_saver/screens/chat_screen.dart';
import 'package:status_saver/screens/info_screen.dart';
import '/ui/dashboards/image.dart';
import '/ui/dashboards/saved.dart';
import '/ui/dashboards/video.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/home-screen';
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adaptiveTheme = AdaptiveTheme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Status Saver',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          actions: [
            IconButton(
                icon: adaptiveTheme.mode == AdaptiveThemeMode.dark
                    ? Icon(Icons.brightness_4)
                    : Icon(Icons.brightness_7),
                onPressed: () {
                  adaptiveTheme.mode == AdaptiveThemeMode.dark
                      ? adaptiveTheme.setLight()
                      : adaptiveTheme.setDark();
                }),
            IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  Navigator.pushNamed(context, InfoScreen.route);
                }),
          ],
          bottom: TabBar(tabs: [
            Container(
              padding: const EdgeInsets.all(12.0),
              child: const Text(
                'IMAGES',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              child: const Text(
                'VIDEOS',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              child: const Text(
                'SAVED',
              ),
            ),
          ]),
        ),
        body: TabBarView(
          children: [ImageDashBoard(), VideoDashBoard(), SavedDashBoard()],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.message,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.pushNamed(context, ChatScreen.route);
          },
        ),
      ),
    );
  }
}
