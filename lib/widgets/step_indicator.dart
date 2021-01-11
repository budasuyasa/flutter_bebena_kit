import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/libraries/custom_styles.dart';
import 'package:flutter_bebena_kit/widgets/label.dart';

class StepIndicator extends StatelessWidget {
  StepIndicator({
    this.stepNumber,
    this.title,
    this.subTitle,
    this.enabled = true,
    this.backgroundColor,
    this.icon = Icons.check
  });

  final int stepNumber;
  final String title;
  final String subTitle;
  final bool enabled;
  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    Color bgColor = backgroundColor ?? Theme.of(context).accentColor;
    if (!enabled) {
      bgColor = Colors.grey;
    }
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: CustomStyles.borderRadius(withBorderRadius: 10)
            ),
            child: Icon(icon, size: 16, color: Colors.white,),
            // child: Label(stepNumber.toString(), textAlign: TextAlign.center, color: Colors.white)
          ),

          SizedBox(width: 16.0),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(title, color: enabled ? Theme.of(context).accentColor : Colors.grey),
                if (subTitle != null)
                  Label(subTitle, color: enabled ? Colors.grey : Colors.grey.shade300)
              ],
            ),
          )
        ],
      ),
    );
  }
}