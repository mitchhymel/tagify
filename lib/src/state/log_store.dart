import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var logStore = new LogStore();

log(dynamic object) => logStore.log(object);
logError(dynamic object) => logStore.logError(object);

class LogLine {
  final DateTime time;
  final String line;
  final bool isError;
  LogLine(this.time, this.line, {this.isError = false});

  @override
  String toString() => '${time.toString()} :: $line';
}

class LogStore extends ChangeNotifier {

  bool _onlyShowErrors = false;
  bool get onlyShowErrors => _onlyShowErrors;
  set onlyShowErrors(bool other) {
    _onlyShowErrors = other;
    notifyListeners();
  }
  String _filter = '';
  String get filter => _filter;
  set filter(String other) {
    _filter = other;
    notifyListeners();
  }
  List<LogLine> _lines = [];
  List<LogLine> get lines {
    var filtered = _lines.where((x) => x.line.toLowerCase()
        .contains(_filter.toLowerCase())).toList();

    if (_onlyShowErrors) {
      return filtered.where((x) => x.isError).toList().reversed.toList();
    }

    return filtered.reversed.toList();
  }

  log(dynamic object, {bool isError=false}) {
    print(object.toString());
    _lines.add(new LogLine(DateTime.now(), object.toString(), isError: isError));
    notifyListeners();
  }

  logError(dynamic object) => log(object, isError: true);

  void clear() {
    _lines = [];
    notifyListeners();
  }

  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: lines.join('\n')));
  }

}