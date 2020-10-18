import 'package:flutter/material.dart';



class LabelStyle extends InheritedWidget {

  LabelStyle({
    Key key,
    @required this.fontFamily,
    @required Widget child
  });

  final String fontFamily;

  static LabelStyle of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LabelStyle>();
  }

  @override
  bool updateShouldNotify(LabelStyle old) {
    return old.fontFamily != fontFamily;
  }

}