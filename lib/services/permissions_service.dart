import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Future<PermissionStatus> requestPermission(
      List<Permission> permissions) async {
    final Map<Permission, PermissionStatus> result =
        await permissions.request();
    for (final permission in result.keys) {
      if (result[permission] == PermissionStatus.granted) {
        continue;
      } else {
        return result[permission] ?? PermissionStatus.denied;
      }
    }
    return PermissionStatus.granted;
  }

  Future<bool> openSettings() {
    return openAppSettings();
  }
}
