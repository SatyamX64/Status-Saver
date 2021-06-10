import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '/services/permissions_service.dart';
import 'home_screen.dart';

class PermissionScreen extends StatelessWidget {
  static const route = '/permission-screen';
  final PermissionsService _permissionsService = PermissionsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                'ʕ•ᴥ•ʔ',
                style: Theme.of(context)
                    .textTheme
                    .headline4,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final status = await _permissionsService
                    .requestPermission([Permission.storage]);
                if (status == PermissionStatus.granted) {
                  Navigator.pushReplacementNamed(context, HomeScreen.route);
                } else if (status == PermissionStatus.denied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please Accept Permission')));
                } else {
                  _permissionsService.openSettings();
                }
              },
              child: Text('Give Permission'),
            ),
          ],
        ),
      ),
    );
  }
}
