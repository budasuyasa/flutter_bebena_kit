import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/flutter_bebena.dart';

class Dialogs {
  Dialogs._();

  static void simpleAlertDialog(BuildContext context, String title, String message, { Function onClose }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Label(title, type: LabelType.headline6),
        content: Label(message),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onClose != null) onClose();
            },
            child: Label("TUTUP", type: LabelType.button, color: Theme.of(context).accentColor)
          )
        ],
      ),
    );
  }
}

class LoadingDialog {
  final BuildContext context;
  
  LoadingDialog(this.context);

  bool isDialodOpened = false;

  void show() {
    showDialog(
      context: context,
      builder: (context) => _LoadingDialog()
    );
    isDialodOpened = true;
  }

  void dismiss() {
    // checking if dialog opened or not, to prevent
    // dismissing current Navigator stack
    if (isDialodOpened) {
      Navigator.of(context).pop();
      isDialodOpened = false;
    }
  }
}

class _LoadingDialog extends StatelessWidget {
  _LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0.0,
      child: Container(
        width: 120.0,
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 16.0),
          Label("Harap Tunggu"),
        ]),
      ),
    );
  }
}