import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/flutter_bebena.dart';
import 'package:photo_view/photo_view.dart';

class Preview extends StatelessWidget {
  Preview({
    @required this.title,
    @required this.url
  });

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title),
      body: PhotoView(
        imageProvider: NetworkImage(url),
      ),
    );
  }
}