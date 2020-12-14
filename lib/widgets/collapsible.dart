import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/flutter_bebena.dart';

class Collapsible extends StatefulWidget {
  Collapsible({
    @required this.title,
    this.titleBoxDecoration,
    this.content,
    this.expand = false
  });

  final Widget title;
  final Widget content;
  final bool expand;

  final Decoration titleBoxDecoration;

  @override
  _CollapsibleState createState() => _CollapsibleState();
}

class _CollapsibleState extends State<Collapsible> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _prepareAnimation();
    _runExpandCheck();
  }

  void _prepareAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn
    );
  }

  void _runExpandCheck() {
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void didUpdateWidget(covariant Collapsible oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () {
            setState(() { _isExpanded = !_isExpanded; });
            _runExpandCheck();
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 4.0),
            decoration: widget.titleBoxDecoration,
            child: widget.title
          ),
        ),
        SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: _animation,
          child: widget.content
        ),
      ],
    );
  }
}