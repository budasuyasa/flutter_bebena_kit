import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/libraries/custom_styles.dart';
import 'package:flutter_bebena_kit/widgets/label.dart';

class BottomButtonWrapper extends StatelessWidget {
  final Widget child;
  final String buttonTitle;
  final Function onButtonTap;
  final EdgeInsets padding;
  final bool isLoading;
  
  BottomButtonWrapper({
    @required this.child,
    this.buttonTitle,
    this.onButtonTap,
    this.padding,
    this.isLoading = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: padding,
              margin: const EdgeInsets.only(bottom: 60.0),
              child: child,
            ),
          ),

          BottomButton(
            title: buttonTitle,
            onPress: onButtonTap,
            isLoading: isLoading,
          )
        ],
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final String title;
  final Function onPress;
  final Color color;
  final bool isLoading;
  final bool disabled;

  /// The button with positioned element
  bool _withPositioned = true;

  BottomButton({
    this.title, 
    this.onPress, 
    this.isLoading = false, 
    this.color ,
    this.disabled = false
  });

  BottomButton.withoutPositioned({
    this.title, 
    this.onPress, 
    this.isLoading = false, 
    this.color,
    this.disabled = false
  }) : _withPositioned = false;

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    BoxDecoration decoration = BoxDecoration(
    );
    if (!isDarkMode) {
      decoration = decoration.copyWith(
        color: Colors.white,
        boxShadow: CustomStyles.mediumBoxShadow
      );
    } else {
      decoration = decoration.copyWith(
        color: Colors.grey.shade800
      );
    }

    Widget child = Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: decoration,
      child: SafeArea(
        top: false,
        child: (!isLoading) ? MaterialButton(
          onPressed: disabled ? null : () => onPress(),
          disabledColor: Colors.grey.shade300,
          color: Theme.of(context).accentColor,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Label(title == null ? "" : title.toUpperCase(), type: LabelType.button, color: Colors.white),
        ) : Center(child: CircularProgressIndicator()),
      ),
    );

    if (_withPositioned) {
      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: child
      );
    } else {
      return child;
    }
  }
}
