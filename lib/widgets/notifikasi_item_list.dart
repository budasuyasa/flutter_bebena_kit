import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/libraries/extensions.dart';
import 'package:flutter_bebena_kit/widgets/label.dart';

class NotificationItemList extends StatelessWidget {
  final String type;
  final String title;
  final String subTitle;
  final DateTime date;
  final Function onPress;

  NotificationItemList(
      {Key key,
      this.type,
      @required this.title,
      @required this.subTitle,
      @required this.date,
      this.onPress});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    String text = "";
    if (diff == 1) {
      text = "kemarin";
    } else if (diff > 1) {
      text = date.toDate(format: 'dd MMMM');
    } else if (diff == 0) {
      text = date.toDate(format: 'HH:mm');
    }

    return Container(
      child: InkWell(
        onTap: onPress,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Label(title, type: LabelType.subtitle2, color: Theme.of(context).accentColor),
                          ),
                          SizedBox(width: 16.0),
                          Text(text,
                              style: TextStyle(fontSize: 12, color: (isDarkMode) ? Colors.grey.shade300 : Color(0x99000000))),
                        ],
                      ),
                      SizedBox(height: 12.0),
                      Label(subTitle, type: LabelType.subtitle2, color: Colors.grey.shade700,),
//                      Text(subTitle ?? "", style: TextStyle(color: (isDarkMode) ? Warna.asbestos : Color(0x99000000))),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}