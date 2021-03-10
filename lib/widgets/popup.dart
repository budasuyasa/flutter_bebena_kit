import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/flutter_bebena.dart';

enum PopupType {  
  error, warning, success, info
}

class Popup {

  Popup._internal();

  static final Popup instance = Popup._internal();

  bool _isShowing = false;

  void show({
    @required BuildContext  context,
    @required String        message,
    @required PopupType     popupType,
    Duration                duration = const Duration(seconds: 3, milliseconds: 600)
  }) async {
    if (_isShowing) return;

    _isShowing = true;

    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: (MediaQuery.of(context).padding.top + 56 + 16),
        left: 16,
        right: 16,
        child: _PopUp(message: message, type: popupType),
      ),
    );

    overlayState.insert(overlayEntry);

    await Future.delayed(duration);

    overlayEntry.remove();

    _isShowing = false;
  }
}

class _PopUp extends StatefulWidget {
  final String message;
  final PopupType type;

  _PopUp({
    Key key,
    @required this.message,
    @required this.type
  }) : super(key: key);

  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<_PopUp>
  with SingleTickerProviderStateMixin {

  bool _loaded = false;

  AnimationController _animationController;
  Animation _opacity;
  // TODO: Used Next when needed
  // Animation _position;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_loaded) {
      _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
      // TODO: Used Next when needed
      // _position = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 16)).animate(CurvedAnimation(
      //   parent: _animationController,
      //   curve: Interval(0, 0.5, curve: Curves.bounceInOut)
      // ));
      _opacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 1, curve: Curves.bounceInOut)
      ));
      _runAnimation();
      _loaded = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    super.dispose();
  }

  void _runAnimation() async {
    _animationController.forward();
    await Future.delayed(Duration(seconds: 3));
    _animationController.reverse();
  }

  void start() {
    _runAnimation();
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = Theme.of(context).brightness == Brightness.dark;

    Color foregroundColor = Colors.grey;
    Color backgroundColor = Colors.white;

    switch (widget.type) {
      case PopupType.error:
        backgroundColor = Colors.red.shade50;
        foregroundColor = Colors.red.shade700;
        break;
      case PopupType.warning:
        backgroundColor = Colors.yellow.shade50;
        foregroundColor = Colors.yellow.shade700;
        break;
      case PopupType.success:
        backgroundColor = Colors.green.shade50;
        foregroundColor = Colors.green.shade700;
        break;
      case PopupType.info:
        backgroundColor = Colors.blue.shade50;
        foregroundColor = Colors.blue.shade700;
        break;
    }

    return FadeTransition(
      opacity: _opacity,
      child: Material(
        color: Colors.transparent,
        child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          boxShadow: (darkMode) ? null : [
            BoxShadow(color: Colors.grey, blurRadius: 2.0,)
          ]
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.info, color: foregroundColor),
            SizedBox(width: 8.0),
            Expanded(child: Label(widget.message, color: foregroundColor))
          ],
        )
      ),
        ),
    );
  }
}