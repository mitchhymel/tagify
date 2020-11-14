import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var logStore = new LogStore();

log(dynamic object) => logStore.log(object);

class LogLine {
  final DateTime time;
  final String line;
  LogLine(this.time, this.line);

  @override
  String toString() => '${time.toString()} :: $line';
}

class LogStore extends ChangeNotifier {

  List<LogLine> _lines = [];
  List<LogLine> get lines => _lines;

  log(dynamic object) {
    _lines.add(new LogLine(DateTime.now(), object.toString()));
    notifyListeners();
  }

  void clear() {
    _lines = [];
    notifyListeners();
  }

  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: lines.join('\n')));
  }

}