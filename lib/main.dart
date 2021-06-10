import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:whatsapp_helper/screens/permission_screen.dart';
import 'package:whatsapp_helper/screens/error_screen.dart';
import 'package:whatsapp_helper/screens/home_screen.dart';
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
        primaryColor: Color(0xFF075E54),
        accentColor: Color(0xFF25D366),
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(
            headline6:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            headline4:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        appBarTheme: AppBarTheme(
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        tabBarTheme: TabBarTheme(
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
        primaryColor: Color(0xFF232D36),
        accentColor: Color(0xFF00B09C),
        scaffoldBackgroundColor: Color(0xFF101D25),
        iconTheme: IconThemeData(color: Colors.white),
        primaryIconTheme: IconThemeData(
          color: Color(0xFF9FA8AF),
        ),
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Color(0xFF9FA8AF), fontWeight: FontWeight.bold),
            headline4: TextStyle(
                color: Color(0xFF9FA8AF), fontWeight: FontWeight.bold)),
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF9FA8AF))),
        tabBarTheme: TabBarTheme(
          labelColor: Color(0xFF00B09C),
          unselectedLabelColor: Color(0xFF9FA8AF),
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
