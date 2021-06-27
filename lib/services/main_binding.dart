import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:test_assignment/services/event_bus.dart';
import 'package:test_assignment/services/image_service.dart';
import 'package:test_assignment/services/main_view_model.dart';
import 'package:test_assignment/services/paint_service.dart';
import 'package:test_assignment/services/permissions_service.dart';

/// Привязки
class MainBinding implements Bindings {
  @override
  void dependencies() {
    /// Сервис рисования
    Get.put(PaintService());

    /// Сервис разрешений
    Get.put(PermissionsService());

    /// Сервис галереи
    Get.put(GalleryService());

    /// Шина событий
    Get.put(EventBus());

    /// View Model
    Get.put(MainViewModel());
  }
}
