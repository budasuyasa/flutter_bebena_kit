import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/libraries/custom_styles.dart';
import 'package:flutter_bebena_kit/widgets/label.dart';

typedef OnFileSelected = void Function(FilePickerResult);

/// Simple wrapper for image picker
class CustomFilePicker extends StatefulWidget {

  CustomFilePicker({
    this.title,
    this.onFileSelected,
    this.errorMessage
  });

  final String title;
  final OnFileSelected onFileSelected;

  /// display [errorMessage]
  final String errorMessage;

  @override
  _CustomFilePickerState createState() => _CustomFilePickerState();
}

class _CustomFilePickerState extends State<CustomFilePicker> {

  String _filename = "";

  void _getFile(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      // type: FileType.any,
      allowMultiple: false,
      withData: true,
      // allowedExtensions: ["jpg", "png", "doc", "docx", "pdf"]
    );

    if (result != null) {
      if (widget.onFileSelected != null) {
        widget.onFileSelected(result);
      }
      setState(() {
        _filename = result.names.last;
      });
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: (widget.errorMessage != null && widget.errorMessage.isNotEmpty) ? Colors.red : Colors.grey),
        borderRadius: CustomStyles.borderRadius(withBorderRadius: 4)
      ),
      child: GestureDetector(
        onTap: () => _getFile(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Label(widget.title ?? "Pilih File", color: Theme.of(context).accentColor),
            SizedBox(height: 16.0),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: CustomStyles.borderRadius(withBorderRadius: 6)
                  ),
                  child: Label("Pilih File", color: Colors.white),
                ),
                SizedBox(width: 16.0),
                Expanded(child: Label(_filename.isEmpty ? "Belum ada file yang dipilih" : _filename))
              ],
            ),
            if (widget.errorMessage != null && widget.errorMessage.isNotEmpty) 
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Label(widget.errorMessage, color: Colors.red, fontSize: 12,),
              )
          ],
        ),
      ),
    );
  }
}