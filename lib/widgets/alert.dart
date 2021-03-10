import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/widgets/label.dart';

enum AlertType { success, info, danger, warning }

class Alert extends StatelessWidget {

  Alert(this.message, {
    this.alertType  = AlertType.info,
    this.margin,
    this.compact = false
  });

  Alert.withIcon({
    IconData icon,
    String title     = "",
    this.alertType  = AlertType.info,
    this.message,
    this.margin,
    this.compact  = false
  }): _title = title, 
  _iconData = icon;

  Alert.withIconAndButton({
    IconData icon,
    String title     = "",
    this.alertType  = AlertType.info,
    this.message,
    this.margin,
    String buttonText,
    Function onButtonTap,
    this.compact = false
  }): _title = title,
  _iconData = icon,
  _buttonText = buttonText,
  _onButtonTap = onButtonTap;

  String _title;
  IconData _iconData;

  String _buttonText;
  Function _onButtonTap;

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

  final bool compact;
  
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

    EdgeInsets padding = EdgeInsets.all(16.0);
    double fontSize;
    if (compact) {
      padding = EdgeInsets.all(8.0);
      fontSize = 12;
    }

    Widget child = Label(message, color: textColor, fontSize: fontSize);

    Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_title != null && _title.isNotEmpty)
          Label(_title, color: darkenColor, type: LabelType.subtitle, marginBottom: 8.0),
        
        Label(message, color: textColor, fontSize: fontSize),

        if (_buttonText != null && _buttonText.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () => _onButtonTap(),
              child: Label(_buttonText.toUpperCase(), type: LabelType.button, color: darkenColor),
            ),
          )
      ],
    );

    if (_iconData != null) {
      child = Row(
        children: [
          Icon(_iconData, color: darkenColor),
          SizedBox(width: 16.0),
          Expanded(
            child: body
          )
        ]
      );
    } else {
      child = body;
    }

    return Container(
      padding: padding,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),
      child: child,
    );
  }
}