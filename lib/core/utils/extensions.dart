import 'package:flutter/material.dart';

extension NavExtension on BuildContext {
   Future<T?> push<T>(Widget page) {
    return Navigator.push<T>(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void pop<T extends Object?>([T? result, ]) {
    Navigator.pop(this, result);
  }

  Future<T?> pushReplacement<T, TO>(Widget page) {
    return Navigator.pushReplacement<T, TO>(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

}