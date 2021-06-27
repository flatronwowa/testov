import 'package:permission_handler/permission_handler.dart';

/// Сервис для разрешений
class PermissionsService {
  /// Проверка разрешений на сторедж
  Future<bool> checkStorage() async {
    return await _permissionCheck(Permission.storage, 'media_permission');
  }

  /// Чекер разрешений
  Future<bool> _permissionCheck(
      Permission permission, String errorString) async {
    final status = await permission.status;
    if (status != PermissionStatus.granted) {
      final result = await permission.request();
      if (!result.isGranted) return false;
      return true;
    } else {
      return true;
    }
  }
}
