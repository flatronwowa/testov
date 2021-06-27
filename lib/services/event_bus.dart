import 'package:rxdart/rxdart.dart';

/// Шина событий
class EventBus {
  final _subject = BehaviorSubject<String>();

  /// Добавить сообщение
  void addMessage(String error) {
    _subject.add(error);
  }

  /// Событие
  Stream<String> get events {
    return _subject.stream;
  }
}
