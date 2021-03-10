import 'package:flutter/material.dart';

class FlexibleRow extends StatelessWidget {

  final Widget left;
  final Widget right;
  final int leftFlex;
  final int rightFlex;

  const FlexibleRow({
    Key key, 
    this.left, 
    this.right, 
    this.leftFlex   = 1, 
    this.rightFlex  = 1
  }) : assert(left != null, "Left Row cant be empty"), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: leftFlex,
          child: left
        ),

        SizedBox(width: 16.0),

        if (right != null)
          Expanded(
            flex: rightFlex,
            child: right
          )
      ],
    );
  }
}