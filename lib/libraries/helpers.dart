import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers {
  Helpers._();

  static bool isDarkMode(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  /// Checking if the screen smaller than 320
  static bool isSmallScreen(BuildContext context) => MediaQuery.of(context).size.width <= 320;

  /// Navigate to the [nextScreen]
  static Future navigateTo(BuildContext context, WidgetBuilder nextScreen, { bool fullscreenDialog = false }) =>
    Navigator.of(context).push(MaterialPageRoute(builder: nextScreen, fullscreenDialog: fullscreenDialog));

  /// Change focus from [current] to [next] node
  static void changeFocus(BuildContext context, FocusNode current, FocusNode next) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static Future<void> openUrl(String url) async {
    print('URL: $url');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Cant Launch $url");
    }
  }
}