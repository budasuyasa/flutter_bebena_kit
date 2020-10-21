import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bebena_kit/libraries/helpers.dart';
import 'package:flutter_bebena_kit/widgets/label.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(this.title, {
    this.bottom,
    this.backgroundColor,
    this.leadingImage,
    this.elevation = 2
  });

  final String title;
  final PreferredSizeWidget bottom;
  final Color backgroundColor;
  final String leadingImage;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;
    if (leadingImage != null) {
      titleWidget = Row(
        children: [
          Image.asset(leadingImage, width: 20, height: 20, fit: BoxFit.contain),
          SizedBox(width: 16.0),
          Label(title, type: LabelType.headline6)
        ],
      );
    } else {
      titleWidget = Label(title, type: LabelType.headline6);
    }

    return AppBar(
      iconTheme: IconThemeData(
        color: Theme.of(context).accentColor
      ),
      title: titleWidget,
      backgroundColor: backgroundColor ?? Theme.of(context).backgroundColor,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom == null ? kToolbarHeight : (kToolbarHeight * 2));
}

/// Custom Aniamated App Bar
/// 
/// When item is scrolled the appbar will appear
class FloatingAppBar extends StatefulWidget {
  final ScrollController scrollController;
  final Widget title;

  FloatingAppBar({
    this.scrollController,
    this.title
  }) : assert(scrollController != null, "Scroll Controller tidak boleh kosong!");

  @override
  _FloatingAppBarState createState() => _FloatingAppBarState();
}

class _FloatingAppBarState extends State<FloatingAppBar> {
  @override
  Widget build(BuildContext context) {
    bool darkMode = Helpers.isDarkMode(context);
    double appbarHeight = 56 + MediaQuery.of(context).padding.top;
    return AnimatedBuilder(
      animation: widget.scrollController,
      builder: (BuildContext context, Widget child) {
        Color bgColor = Theme.of(context).backgroundColor.withOpacity(0);

        double _opacity = 0.0;

        if (widget.scrollController.offset > 0) {
          // Jika scroll melebihi 56 maka biarkan saja putih
          // kalau kurang dari 56, maka hitung opacity
          if (widget.scrollController.offset > 56) {
            bgColor = Theme.of(context).backgroundColor;
            _opacity = 1;
          } else {
            var opacity = widget.scrollController.offset / 56;
            bgColor = Theme.of(context).backgroundColor.withOpacity(opacity);
            _opacity = opacity;
            if (!darkMode) {
              // double actionColorOffset = 255 / widget.scrollController.offset;
              // int iActionColorOffset = actionColorOffset.toInt();
            }
          }
        }

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: darkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: Container(
              decoration: BoxDecoration(
                  color: bgColor
              ),
              child: Container(
                  height: appbarHeight,
                  width: double.infinity,
                  child: SafeArea(
                    bottom: false,
                    child: NavigationToolbar(
                      leading: BackButton(
                        color: Theme.of(context).accentColor,
                      ),
                      middle: Container(
                        child: DefaultTextStyle(
                          style: Theme.of(context).textTheme.headline6,
                          child: AnimatedOpacity(opacity: _opacity, duration: Duration(milliseconds: 1), child: widget.title,),
                        ),
                      )
                    ),
                  )
              )
          ),
        );
      },
    );
  }
}