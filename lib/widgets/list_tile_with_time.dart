import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/libraries/extensions.dart';
import 'package:flutter_bebena_kit/widgets/widgets.dart';

import 'label.dart';

typedef OnItemTap = void Function();

class ListTileWithTime extends StatelessWidget {
  ListTileWithTime({
    this.title,
    this.subtitle,
    this.time,
    this.padding,
    this.margin,
    this.leading,
    this.onTap
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final DateTime time;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        margin: margin,
        padding: padding ?? EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null)
              Container(margin: const EdgeInsets.only(right: 16.0), child: leading),


            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(title, fontWeight: FontWeight.bold),
                  Label(subtitle)
                ]
              ),
            ),

            Label(time.toDateDifferenceInformation(), color: Colors.grey)
          ],
        ),
      ),
    );
  }
}