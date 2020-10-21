import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/widgets/label.dart';

enum AlertType { success, info, danger, warning }

class Alert extends StatelessWidget {

  Alert(this.message, {
    this.alertType  = AlertType.info,
    this.margin
  });

  final String message;
  final AlertType alertType;
  final EdgeInsets margin;
  
  @override
  Widget build(BuildContext context) {
    Color boxColor;
    Color textColor;
    switch (alertType) {
      case AlertType.success:
        boxColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;
      case AlertType.info:
        boxColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        break;
      case AlertType.danger:
        boxColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;
      case AlertType.warning:
        boxColor = Colors.yellow.shade50;
        textColor = Colors.yellow.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),
      child: Label(message, color: textColor),
    );
  }
}