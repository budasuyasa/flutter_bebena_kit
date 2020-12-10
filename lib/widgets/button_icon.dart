import 'package:flutter/material.dart';

class ButtonIcon extends StatelessWidget {

  final String title;
  final IconData icon;
  final Function onTap;
  final bool withoutText;
  final bool disableText;

  final Color color;
  final CrossAxisAlignment crossAxisAligment;

  ButtonIcon({
    @required this.title,
    @required this.icon,
    this.onTap,
    this.color,
    this.crossAxisAligment = CrossAxisAlignment.start,
    this.withoutText = false,
    this.disableText = false
  });

  @override
  Widget build(BuildContext context) {
    Color pColor = Theme.of(context).accentColor;
    if (color != null) {
      pColor = color;
    }

    if (disableText) {
      pColor = Colors.grey.shade500;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: crossAxisAligment,
          mainAxisAlignment: (crossAxisAligment == CrossAxisAlignment.end) ? MainAxisAlignment.end : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            (crossAxisAligment == CrossAxisAlignment.start) ? Icon(icon, size: 26, color: pColor)
                : Container(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: (!withoutText) ? Text(title.toUpperCase(), style: Theme.of(context).textTheme.button.copyWith(color: pColor)) : Container(),
            ),
            (crossAxisAligment == CrossAxisAlignment.end) ? Icon(icon, size: 26, color: pColor)
                : Container()
          ],
        ),
      ),
    );
  }
}
