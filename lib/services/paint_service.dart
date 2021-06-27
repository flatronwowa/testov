import 'package:flutter/cupertino.dart';

enum Action {
  Clean,
  Paint,
}

/// Сервис рисования
class PaintService {
  ///Лист для набора точек(линий)
  List<List<Offset>> lines = [];

  /// История отмененных рисунков
  List<List<Offset>> _cancellationHistory = [];

  /// Очищенные рисунки
  List<List<List<Offset>>> _cleaned = [];

  /// Действия
  List<Action> _actions = [];

  /// Отмененные действия
  List<Action> _redoActions = [];

  /// Очищает все поля
  void cleanAll() {
    _actions.clear();
    _redoActions.clear();
    _cancellationHistory.clear();
    _cleaned.clear();
    lines.clear();
  }

  /// Начанает рисовать
  void startPainting() {
    _actions.add(Action.Paint);
    lines.add([]);
    _cleanRedoneActions();
  }

  /// Обновляет рисование
  void updatePainting(Offset point) {
    lines.last.add(point);
  }

  /// Отменяет действие
  void undo() {
    if (_actions.isEmpty) return;
    if (_actions?.last == Action.Clean) {
      lines = lines + _cleaned.last;
      _cleaned.removeLast();
      _undoAction();
      return;
    }
    _undoAction();
    _cancellationHistory.add(lines.last);
    lines.removeLast();
  }

  /// Возвращает отмененное действие
  void redo() {
    if (_redoActions.isEmpty) return;
    _redoAction();
    if (_actions?.last == Action.Clean) {
      _redoClean();
      return;
    }
    lines.add(_cancellationHistory.last);
    _cancellationHistory.removeLast();
  }

  /// Очищает холст
  void clean() {
    if (lines.isNotEmpty) {
      _actions.add(Action.Clean);
      _cleaned.add([...lines]);
      lines.clear();
      _cleanRedoneActions();
    }
  }

  /// Возвращает очищенное обратно
  void _redoClean() {
    _cleaned.add([...lines]);
    lines.clear();
  }

  /// Отчищает историю вернувшихся действий
  void _cleanRedoneActions() {
    _cancellationHistory.clear();
    _redoActions.clear();
  }

  /// Отменить действие
  void _undoAction() {
    _redoActions.add(_actions.last);
    _actions.removeLast();
  }

  /// Возвращает действие
  void _redoAction() {
    _actions.add(_redoActions.last);
    _redoActions.removeLast();
  }
}
