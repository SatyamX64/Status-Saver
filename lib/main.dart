import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:whatsapp_helper/screens/permission_screen.dart';
import 'package:whatsapp_helper/screens/error_screen.dart';
import 'package:whatsapp_helper/screens/home_screen.dart';
import 'package:whatsapp_helper/services/permissions_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final PermissionsService _permissionsService = PermissionsService();
  late final Future<PermissionStatus> _requestPermission =
      _permissionsService.requestPermission([Permission.storage]);
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Whatsapp Helper',
        theme: theme,
        darkTheme: darkTheme,
        routes: {
          ErrorScreen.route: (ctx) => ErrorScreen(),
          PermissionScreen.route: (ctx) => PermissionScreen(),
          HomeScreen.route: (ctx) => HomeScreen(),
        },
        home: DefaultTabController(
          length: 2,
          child: FutureBuilder(
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
      ),
    );
  }
}
