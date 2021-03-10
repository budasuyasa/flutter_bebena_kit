import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/libraries/helpers.dart';

enum LabelType {
  headline1, headline2, headline3, headline4, headline5, headline6, caption,
  subtitle1, subtitle2, button, bodyText1, bodyText2,
  subtitle, secondarySubTitle, captionLower, captionLowerDefault,
  listTitle, listTitleSmall, overline
}

/// Penyerderhanaan Text dari flutter agar mudah dipanggil
///
/// Style mengikuti Material Design guidelines, dengan beberapa perbaikan style
class Label extends StatelessWidget {
  final String text;
  final EdgeInsets margin;
  final LabelType type;
  final double fontSize;
  final Color color;
  final double marginBottom;
  final FontWeight fontWeight;
  final textAlign;
  final bool withUnderline;
  final TextDecoration textDecoration;

  Label(this.text, {
    this.margin,
    this.type = LabelType.bodyText1,
    this.fontSize,
    this.color,
    this.marginBottom,
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.maxLine,
    this.withUnderline = false,
    this.textDecoration
  });

  final int maxLine;

  @override
  Widget build(BuildContext context) {
    TextStyle style;
    String textLabel = text;
    switch (type) {
      case LabelType.headline1:
        style = Theme.of(context).textTheme.headline1;
        break;
      case LabelType.headline2:
        style = Theme.of(context).textTheme.headline2;
        break;
      case LabelType.headline3:
        style = Theme.of(context).textTheme.headline3;
        break;
      case LabelType.headline4:
        style = Theme.of(context).textTheme.headline4;
        break;
      case LabelType.headline5:
        style = Theme.of(context).textTheme.headline5;
        break;
      case LabelType.headline6:
        style = Theme.of(context).textTheme.headline6.copyWith(
          color: Theme.of(context).accentColor
        );
        break;
      case LabelType.captionLower:
        bool darkMode = Helpers.isDarkMode(context);
        style = Theme.of(context).textTheme.caption.copyWith(color: (darkMode) ? Colors.grey.shade300 : Colors.grey.shade500);
        break;
      case LabelType.caption:
        bool darkMode = Helpers.isDarkMode(context);
        textLabel = text.toUpperCase();
        style = Theme.of(context).textTheme.caption.copyWith(color: (darkMode) ? Colors.grey.shade300 : Colors.grey.shade500);
        break;
      case LabelType.subtitle1:
        style = Theme.of(context).textTheme.subtitle1.copyWith(
          letterSpacing: 0.15
        );
        break;
      case LabelType.subtitle2:
        style = Theme.of(context).textTheme.subtitle2;
        break;
      case LabelType.button:
        style = Theme.of(context).textTheme.button.copyWith(
          letterSpacing: 1.25,
          color: Colors.white,
          fontWeight: FontWeight.bold
        );
        break;
      case LabelType.bodyText1:
        style = Theme.of(context).textTheme.bodyText1;
        break;
      case LabelType.bodyText2:
        style = Theme.of(context).textTheme.bodyText2;
        break;
      case LabelType.listTitle:
        style = Theme.of(context).textTheme.subtitle1.copyWith(color: Theme.of(context).accentColor, fontWeight: FontWeight.w500);
        break;
      case LabelType.listTitleSmall:
        style = Theme.of(context).textTheme.subtitle1.copyWith(
            color: Theme.of(context).accentColor, fontWeight: FontWeight.w500,
          fontSize: 14
        );
        break;
      case LabelType.overline:
        style = Theme.of(context).textTheme.overline;
        break;
      case LabelType.subtitle:
        style = Theme.of(context).textTheme.bodyText1.copyWith(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold
        );
        break;
      case LabelType.secondarySubTitle:
        style = Theme.of(context).textTheme.caption;
        break;
      case LabelType.captionLowerDefault:
        style = Theme.of(context).textTheme.caption;
        break;
      default:
        style = Theme.of(context).textTheme.bodyText1.copyWith(
          letterSpacing: 0.25
        );
        break;
    }

    if (fontSize != null) {
      style = style.copyWith(fontSize: fontSize);
    }

    if (color != null) {
      style = style.copyWith(color: color);
    }

    if (fontWeight != null)
      style = style.copyWith(fontWeight: fontWeight);

    if (withUnderline)
      style = style.copyWith(decoration: TextDecoration.underline);

    if (textDecoration != null)
      style = style.copyWith(decoration: textDecoration);

    EdgeInsets emargin = EdgeInsets.zero;
    if (marginBottom != null) {
      emargin = EdgeInsets.only(bottom: marginBottom);
    } else if (margin != null) {
      emargin = margin;
    }

    return Container(
      margin: emargin,
      child: Text(
        textLabel, 
        textAlign: textAlign, 
        maxLines: maxLine ?? null, 
        overflow: maxLine == null ? null : TextOverflow.ellipsis, 
        style: style
      ),
    );
  }
}