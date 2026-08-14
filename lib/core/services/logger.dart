import 'package:flutter/foundation.dart';

abstract class Logger {
  void d(String message);
  void i(String message);
  void w(String message);
  void e(String message, [Object? error, StackTrace? stackTrace]);
}

class ConsoleLogger implements Logger {
  @override
  void d(String message) => debugPrint('[D] $message');

  @override
  void i(String message) => debugPrint('[I] $message');

  @override
  void w(String message) => debugPrint('[W] $message');

  @override
  void e(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('[E] $message ${error ?? ''}');
    if (stackTrace != null) debugPrint(stackTrace.toString());
  }
}
