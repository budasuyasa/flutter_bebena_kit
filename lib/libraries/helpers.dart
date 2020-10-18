import 'package:flutter/material.dart';

class Helpers {
  Helpers._();

  static bool isDarkMode(BuildContext context) => Theme.of(context).brightness == Brightness.dark;
}