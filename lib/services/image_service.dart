import 'dart:async';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:test_assignment/services/permissions_service.dart';

/// Сервис галлереи изображений
class GalleryService {
  final _permissionsService = Get.find<PermissionsService>();

  /// Имя файла
  String _fileName;

  /// Получить изображение
  Future<Uint8List> getImage() async {
    if (!(await _permissionsService.checkStorage())) return null;
    final _pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (_pickedFile == null) return null;
    _fileName = basenameWithoutExtension(_pickedFile.path);
    return await _pickedFile.readAsBytes();
  }

  /// Сохранить  изображение
  Future<bool> saveImage(Uint8List bytesList) async {
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(bytesList),
      quality: 100,
      name: 'test_assignment_$_fileName',
    );
    return result['isSuccess'];
  }
}
