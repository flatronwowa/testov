import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:test_assignment/components/painter.dart';
import 'package:test_assignment/helpers/dialog_helper.dart';
import 'package:test_assignment/services/event_bus.dart';
import 'package:test_assignment/services/main_view_model.dart';


/// Главный экрна
class MainView extends StatefulWidget {
  _MainViewSate createState() => _MainViewSate();
}

/// Главный экрна
class _MainViewSate extends State<MainView> {
  final _appController = Get.find<MainViewModel>();

  final _eventBus = Get.find<EventBus>();

  GlobalKey _globalKey = GlobalKey();

  /// Подписка на события
  StreamSubscription<String> _eventSubscription;

  @override
  void initState() {
    _eventSubscription = _eventBus.events.listen((event) {
      DialogHelper.showDialog(event);
    });
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    _eventSubscription.cancel();
  }

  /// Вызывется при Движении по экрану
  void _onPanUpdate(Offset position) {
    if (position ==
        _appController.paintedLines
            .last[_appController.paintedLines.last.length - 1]) return;
    setState(() {
      _appController.updatePainting(position);
    });
  }

  /// Начало движения по экрану
  void _onPanStart(Offset position) {
    _appController.startPainting();
    setState(() {
      _appController.updatePainting(position);
    });
  }

  /// Сохраняет изображение
  void _saveImage() async {
    if (_appController.isImageSaving) return;
    await _appController.saveImageToGallery(_globalKey);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: _appController.image == null
          ? Center(
              child: TextButton(
                onPressed: () async {
                  await _appController.getImageFromGallery();
                  setState(() {});
                },
                child: Text('Select image'),
              ),
            )
          : Stack(
              children: [
                GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) =>
                      _onPanUpdate(details.globalPosition),
                  onPanStart: (details) => _onPanStart(details.globalPosition),
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Image.memory(_appController.image,
                                  fit: BoxFit.cover)
                              .image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: Painter(_appController.paintedLines),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: TextButton(
                    onPressed: () async {
                      await _appController.getImageFromGallery();
                      setState(() {
                        _appController.startNewPainting();
                      });
                    },
                    child: Text('Select new image'),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 1),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _appController.undoPaintAction();
                          });
                        },
                        child: Text('Undo'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _appController.redoPaintAction();
                          });
                        },
                        child: Text('Redo'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _appController.cleanPaintActions();
                          });
                        },
                        child: Text('Clean'),
                      ),
                      TextButton(
                        onPressed: _saveImage,
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
