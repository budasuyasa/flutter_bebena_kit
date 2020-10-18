import 'package:flutter/material.dart';

typedef OnActionTap = void Function();

class EmptyPlaceholder extends StatelessWidget {
  EmptyPlaceholder({
    this.title = "Terjadi Kesalahan",
    @required this.message,
    this.image,
    this.actionText,
    this.onActionTap
  });

  final String title;
  final String message;
  /// Icon to display when empty
  final String image;
  final String actionText;
  final OnActionTap onActionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) 
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Image.asset(image, width: 60, height: 60, fit: BoxFit.contain)
              ),
            Text(title, style: Theme.of(context).textTheme.subtitle1),
            SizedBox(height: 8),
            Text(message, style: Theme.of(context).textTheme.bodyText1),
            if (actionText != null)
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