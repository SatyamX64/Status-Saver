import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
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
        drawer: Drawer(),
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
            FlutterOpenWhatsapp.sendSingleMessage("+918179015345", "Hello");
          },
        ),
      ),
    );
  }
}
