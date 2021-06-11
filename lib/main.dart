import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:whatsapp_helper/constants.dart';
import 'package:whatsapp_helper/screens/permission_screen.dart';
import 'package:whatsapp_helper/screens/error_screen.dart';
import 'package:whatsapp_helper/screens/home_screen.dart';
import 'package:whatsapp_helper/screens/chat_screen.dart';
import 'package:whatsapp_helper/services/permissions_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(
    MyApp(
      savedThemeMode: savedThemeMode,
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.savedThemeMode}) : super(key: key);

  final PermissionsService _permissionsService = PermissionsService();
  final savedThemeMode;
  late final Future<PermissionStatus> _requestPermission =
      _permissionsService.requestPermission([Permission.storage]);
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Helvetica',
        primaryColor: ColorPalette.lightPrimary,
        accentColor: ColorPalette.lightAccent,
        scaffoldBackgroundColor: ColorPalette.lightBackground,
        iconTheme:
            IconThemeData(color: ColorPalette.lightBackground), // For FAB
        primaryIconTheme: IconThemeData(
          color: ColorPalette.lightActive,
        ),
        textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: ColorPalette.lightAccent,
            cursorColor: ColorPalette.lightInactive),
        textTheme: TextTheme(
          headline6: TextStyle(
              color: ColorPalette.lightInactive, fontWeight: FontWeight.bold),
          headline4: TextStyle(
              color: ColorPalette.lightInactive, fontWeight: FontWeight.bold),
        ),
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold, color: ColorPalette.lightActive)),
        tabBarTheme: TabBarTheme(
          labelColor: ColorPalette.lightActive,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Helvetica',
        primaryColor: ColorPalette.darkPrimary,
        accentColor: ColorPalette.darkAccent,
        scaffoldBackgroundColor: ColorPalette.darkBackground,
        iconTheme: IconThemeData(color: ColorPalette.darkBackground), // For FAB
        primaryIconTheme: IconThemeData(
          color: ColorPalette.darkActive,
        ),
        textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: ColorPalette.darkAccent,
            cursorColor: ColorPalette.darkActive),
        textTheme: TextTheme(
            headline6: TextStyle(
                color: ColorPalette.darkInactive, fontWeight: FontWeight.bold),
            headline4: TextStyle(
                color: ColorPalette.darkInactive, fontWeight: FontWeight.bold)),
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold, color: ColorPalette.darkActive)),
        tabBarTheme: TabBarTheme(
          labelColor: ColorPalette.darkActive,
          unselectedLabelColor: ColorPalette.darkInactive,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Status Saver',
        theme: theme,
        darkTheme: darkTheme,
        routes: {
          ErrorScreen.route: (ctx) => ErrorScreen(),
          PermissionScreen.route: (ctx) => PermissionScreen(),
          HomeScreen.route: (ctx) => HomeScreen(),
          ChatScreen.route: (ctx) => ChatScreen(),
        },
        home: FutureBuilder(
          future: _requestPermission,
          builder: (context, status) {
            if (status.connectionState == ConnectionState.done) {
              if (status.hasData) {
                if (status.data == PermissionStatus.granted) {
                  return HomeScreen();
                } else {
                  return PermissionScreen();
                }
              } else {
                return const ErrorScreen();
              }
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
