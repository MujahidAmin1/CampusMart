
import 'package:flutter/material.dart';

TextStyle kTextStyle(
    {double size = 15, bool isBold = false, Color color = Colors.black}) {
  return TextStyle(
    fontSize: size,
    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    color: color,
  );
}
