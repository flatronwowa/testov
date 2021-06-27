import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:test_assignment/services/event_bus.dart';
import 'package:test_assignment/services/image_service.dart';
import 'package:test_assignment/services/paint_service.dart';
import 'package:test_assignment/services/permissions_service.dart';

/// View Model
class MainViewModel extends GetxController {
  final _imageService = Get.find<GalleryService>();
  final _paintService = Get.find<PaintService>();
  final _permissionsService = Get.find<PermissionsService>();
  final _eventBus = Get.find<EventBus>();

  /// Изображение для фона
  Uint8List image;

  /// Загружается ли изображение
  var isImageSaving = false;

  /// Отрисованные линии
  List<List<Offset>> get paintedLines {
    return _paintService.lines;
  }

  /// Делает png из виджета
  Future<Uint8List> _capturePng(GlobalKey key) async {
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData.buffer.asUint8List();
  }

  /// Проверяет разрешение на сторадж
  Future<void> checkStoragePermission() async {
    await _permissionsService.checkStorage();
  }

  /// Получает изображение из галлереи
  Future<void> getImageFromGallery() async {
    image = await _imageService.getImage();
  }

  /// Сохраняет изображение в галлерею
  Future<void> saveImageToGallery(GlobalKey key) async {
    isImageSaving = true;
    final img = await _capturePng(key);
    var result = await _imageService.saveImage(img);
    isImageSaving = false;
    if (result) {
      _eventBus.addMessage('Saved successful');
    } else
      _eventBus.addMessage('Error. Try later');
  }

  /// Отменяет действие рисования
  void undoPaintAction() {
    _paintService.undo();
  }

  /// Возвращает отмененное действие рисования
  void redoPaintAction() {
    _paintService.redo();
  }

  /// Отчищает холст для рисования
  void cleanPaintActions() {
    _paintService.clean();
  }

  /// Отчищаеть все поля для создания нового рисунка
  void startNewPainting() {
    _paintService.cleanAll();
  }

  /// Начанает рисовать
  void startPainting() {
    _paintService.startPainting();
  }

  /// Обновляет рисование
  void updatePainting(Offset point) {
    _paintService.updatePainting(point);
  }
}
