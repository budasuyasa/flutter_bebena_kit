import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/resources/images.dart';
import 'package:flutter_bebena_kit/widgets/label.dart';

typedef OnActionTap = void Function();

class EmptyPlaceholder extends StatelessWidget {
  EmptyPlaceholder({
    this.title = "Terjadi Kesalahan",
    @required this.message,
    this.image  = Images.sad,
    this.actionText,
    this.onActionTap,
    this.withCentered = true
  });

  final String title;
  final String message;
  /// Icon to display when empty
  final String image;
  final String actionText;
  final OnActionTap onActionTap;

  /// Set placeholder with center depending of height
  final bool withCentered;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: (withCentered) ? MediaQuery.of(context).size.height : null,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) 
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Image.asset(image, width: 60, height: 60, fit: BoxFit.contain)
              ),
            Label(title, type: LabelType.subtitle1, fontWeight: FontWeight.bold),
            SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2),
            if (actionText != null && onActionTap != null)
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: FlatButton(
                  onPressed: onActionTap,
                  color: Theme.of(context).accentColor,
                  child: Text(actionText, style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)),
                )
              )
          ]
        ),
      ),
    );
  }
}