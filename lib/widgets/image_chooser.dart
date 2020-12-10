import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'label.dart';

typedef OnImageSelectedCallback(File file);

/// Widget untuk mengambil gambar dan menampilkan preview
///
///
/// [title] Judul
///
///
/// [cameraOnly] Paksa untuk mengambil gambar hanya dari camera
/// tanpa ada dialog untuk pemilihan
///
///
/// [enabled] apakah input bisa di edit atau tidak, jika true
/// maka hanya menampilkan preview
///
class ImageChooser extends StatefulWidget {
  final String title;
  final OnImageSelectedCallback onImageSelected;
  final String imageURL;
  final String errorMessage;
  final bool cameraOnly;
  final bool enabled;
  final File file;

  ImageChooser({Key key,
    @required this.title,
    this.onImageSelected,
    this.imageURL,
    this.errorMessage,
    this.cameraOnly = false,
    this.enabled = true,
    this.file
  }) : super(key: key);

  @override
  _ImageChooser createState() => _ImageChooser();
}

class _ImageChooser extends State<ImageChooser> {

  File _selectedImage;


  ImagePicker _imagePicker;

  @override
  void initState() {
    _imagePicker = ImagePicker();
    super.initState();
  }

  void _imageBottomSheetIOS(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("Pilih Gambar"),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Kamera"),
            onPressed: () {
              Navigator.pop(context);
              _getFromCamera();
            },
          ),
          (!widget.cameraOnly) ?
          CupertinoActionSheetAction(
            child: Text("Galeri"),
            onPressed: () {
              Navigator.pop(context);
              _getFromGalery();
            },
          ): Container()
        ], 
        cancelButton: CupertinoActionSheetAction(
          child: Text("Batal"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      )
    );
  }

  void _imageBottomSheetAndroid(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: Theme.of(context).backgroundColor,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Pilih Gambar" ,style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).primaryColor
              )),
              SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () { 
                        _getFromCamera(); 
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 80.0,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.camera_alt, size: 42),
                            SizedBox(height: 8.0),
                            Label("Kamera")
                          ],
                        ),
                      ),
                    ),
                    /// ---
                    SizedBox(width: 16.0),
                    /// ---
                    (!widget.cameraOnly) ?
                    GestureDetector(
                      onTap: () { 
                        _getFromGalery();
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 72.0,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.photo, size: 42),
                            SizedBox(height: 8.0),
                            Label("Galeri")
                          ],
                        ),
                      ),
                    ) : Container(),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("BATAL", style: TextStyle(color: Theme.of(context).primaryColor)),
              )
            ],
          ),
        ),
      )
    );
  }

  void _getFromGalery() async {
    var image = await _imagePicker.getImage(
      source: ImageSource.gallery,
      maxWidth: 600.0
    );
    File _image = File(image.path);
    widget.onImageSelected(_image);
    setState(() {
      _selectedImage = _image;
    });
  }

  void _getFromCamera() async {
    var image = await _imagePicker.getImage(
      source: ImageSource.camera,
      maxWidth: 600.0
    );
    File _image = File(image.path);
    widget.onImageSelected(_image);
    setState(() {
      _selectedImage = _image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Label(widget.title.toUpperCase(), type: LabelType.subtitle, fontWeight: FontWeight.bold),
        SizedBox(height: 8.0),
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              border: Border.all(color: Colors.grey.shade500)),
          child: Center(
            child: InkWell(
              onTap: () {
                if (widget.enabled) {
                  if (widget.cameraOnly) {
                    // Directly open camera instead
                    _getFromCamera();
                  } else {
                    // if (Platform.isIOS) {
                    //   _imageBottomSheetIOS(context);
                    // } else if (Platform.isAndroid) {
                      _imageBottomSheetAndroid(context);
                    // }
                  }
                }
              },
              child: _renderImage()
            )
          ),
        ),
        (widget.errorMessage != null) ? Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(widget.errorMessage, style: TextStyle(color: Colors.red),)
        ) : Container()
      ],
    );
  }

  Widget _renderImage() {
    if (widget.imageURL == null && _selectedImage == null && widget.file == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.camera_alt, color: Colors.grey.shade500),
          SizedBox(height: 16.0),
          Text("Tekan disini untuk menambahkan ${widget.title}",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Colors.grey.shade500))
        ],
      );
    } else if ((widget.imageURL == null || _selectedImage != null) && widget.file == null) {
      return _Image(_selectedImage, onTap: () => setState(() { _selectedImage = null; }));
    } else if (widget.imageURL != null && _selectedImage == null) {
      return Stack(
        children: <Widget>[
          Center(child: Image.network(widget.imageURL, fit: BoxFit.contain)),
        ],
      );
    } else if (_selectedImage == null && widget.file != null) {
      return _Image(
        widget.file,
        onTap: () => setState(() { _selectedImage = null; }),
      );
    } else if (_selectedImage != null && widget.file != null) {
      return _Image(
        _selectedImage,
        onTap: () => setState(() { _selectedImage = null; }),
      );
    } else {
      return Container();
    }
  }
}

class _Image extends StatelessWidget {
  final File file;
  final Function onTap;

  _Image(this.file, {
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(child: Image.file(file, fit: BoxFit.contain)),
        Positioned(
          top: 16.0,
          right: 16.0,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
                width: 28,
                height: 28,
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(120),
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: Icon(Icons.close, color: Colors.grey.shade500)),
          ),
        )
      ],
    );
  }
}