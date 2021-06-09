import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Future<PermissionStatus> requestPermission(
      List<Permission> permissions) async {
    Map result = await permissions.request();
    for (var permission in result.keys) {
      if (result[permission] == PermissionStatus.granted)
        continue;
      else
        return result[permission];
    }
    return PermissionStatus.granted;
  }

  openSettings() {
    openAppSettings();
  }
}
