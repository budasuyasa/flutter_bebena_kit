import 'package:flutter/material.dart';

/// Class of most used theme data
class CustomStyles {
  CustomStyles._();

  static List<BoxShadow> get regularBoxShadow => [
    BoxShadow(color: Colors.black.withOpacity(0.04), offset: Offset(0, 4), blurRadius: 8, spreadRadius: 0),
    BoxShadow(color: Colors.black.withOpacity(0.04), offset: Offset.zero, blurRadius: 2, spreadRadius: 0),
    BoxShadow(color: Colors.black.withOpacity(0.04), offset: Offset.zero, blurRadius: 1, spreadRadius: 0)
  ];

  static List<BoxShadow> get mediumBoxShadow => [
    BoxShadow(color: Colors.black.withOpacity(0.04), offset: Offset(10, 0), blurRadius: 20, spreadRadius: 0),
    BoxShadow(color: Colors.black.withOpacity(0.04), offset: Offset(2, 0), blurRadius: 6, spreadRadius: 0),
    BoxShadow(color: Colors.black.withOpacity(0.04), offset: Offset.zero, blurRadius: 1, spreadRadius: 0)
  ];
}