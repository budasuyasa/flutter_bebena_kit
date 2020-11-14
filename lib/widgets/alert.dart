import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/widgets/label.dart';

enum AlertType { success, info, danger, warning }

class Alert extends StatelessWidget {

  Alert(this.message, {
    this.alertType  = AlertType.info,
    this.margin
  });

  Alert.withIcon({
    IconData icon,
    String title     = "",
    this.alertType  = AlertType.info,
    this.message,
    this.margin
  }): _title = title, 
  _iconData = icon;

  String _title;
  String _message;
  IconData _iconData;

  final String message;

  /// Type alert will be displayed, 
  /// 
  /// Alert Types:
  ///   - [AlertType.info] (Default) blue background, 
  ///   - [AlertType.success] For alert success with green background
  ///   - [AlertType.danger] For danger alert with red background
  ///   - [AlertType.warning] Warning with yellow background
  final AlertType alertType;
  final EdgeInsets margin;
  
  @override
  Widget build(BuildContext context) {
    Color boxColor;
    Color textColor;
    Color darkenColor;
    switch (alertType) {
      case AlertType.success:
        boxColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        darkenColor = Colors.green.shade900;
        break;
      case AlertType.info:
        boxColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        darkenColor = Colors.blue.shade900;
        break;
      case AlertType.danger:
        boxColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        darkenColor = Colors.red.shade900;
        break;
      case AlertType.warning:
        boxColor = Colors.yellow.shade50;
        textColor = Colors.yellow.shade700;
        darkenColor = Colors.yellow.shade900;
        break;
    }

    Widget child = Label(message, color: textColor);

    if (_iconData != null) {
      child = Row(
        children: [
          Icon(_iconData, color: darkenColor),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_title != null && _title.isNotEmpty)
                  Label(_title, color: darkenColor, type: LabelType.subtitle, marginBottom: 8.0),
                Label(message, color: textColor),
              ],
            ),
          )
        ]
      );
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),
      child: child,
    );
  }
}