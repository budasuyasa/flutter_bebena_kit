/// @author: Agus Widhiyasa
import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/libraries/helpers.dart';
import 'button_icon.dart';
import 'label.dart';

typedef OnSaveWizardState = void Function(Map<String, dynamic> state);
typedef OnPageChange = void Function();

/// Custom step wizard,
/// 
/// [controller] digunakan untuk listener jika ada perubahan page
/// 
/// [widgets] Widget harus bertipe [CustomWizardContainer]
/// 
/// [itemCount] jumlah wizard yang akan ditampilkan, karena
/// untuk menthitung item itu expensive task dalam List
/// 
class CustomWizard extends StatefulWidget {
  final CustomWizardController controller;
  final List<Widget> widgets;
  final List<String> titles;
  final int itemCount;

  CustomWizard({
    @required this.widgets,
    this.itemCount = 0,
    this.controller,
    this.titles
  });

  @override
  _CustomWizardState createState() => _CustomWizardState();
}

class _CustomWizardState extends State<CustomWizard> {

  bool _isLoaded  = false;
  int _step       = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      /// Adding listener for next or previous action
      widget.controller.addListener(() {
        setState(() {
          _step = widget.controller.index;
        });
      });
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkmode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          widget.widgets[_step],

          Container(
            width: double.infinity,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: (darkmode) ? null : Border(
                bottom: BorderSide(color: Colors.grey.shade100, width: 1)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 12.0),
                Label("Langkah ${_step + 1} dari ${widget.itemCount}", 
                  type: LabelType.caption,
                  color: Colors.grey.shade500,
                ),
                SizedBox(height: 4.0),
                (widget.titles[_step] != null) ?
                Label(widget.titles[_step].toUpperCase(),
                  type: LabelType.subtitle2,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ) : Container(),
              ],
            ),
          ),
        ],
      )
    );
  }
}

class CustomWizardContainer extends StatelessWidget {
  final Function onNext;
  final Function onPrev;
  final Widget child;
  final String nextText;
  final String prevText;
  final bool disableNext;

  final FloatingActionButton floatingActionButton;

  /// Create custom padding, 
  /// 
  /// __IMPORTANT!__ top and bottom padding must have minimum height recpectedly __52__ and __68__  because it will overlap with
  /// bottom button and top title
  final EdgeInsetsGeometry padding;

  CustomWizardContainer({
    @required this.child,
    this.onNext,
    this.onPrev,
    this.disableNext = false,
    this.nextText = "SELANJUTNYA",
    this.prevText = "SEBELUMNYA",
    this.padding = const EdgeInsets.only(top: 68, left: 16, right: 16, bottom: 68),
    this.floatingActionButton
  });

  @override
  Widget build(BuildContext context) {
    bool darkmode = Theme.of(context).brightness == Brightness.dark;
    bool largeScreen = !Helpers.isSmallScreen(context);

    return Container(
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: SingleChildScrollView(
            child: Container(
              padding: padding,
              child: child,
            ),
          )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: (darkmode) ? null : Border(
                    top: BorderSide(color: Colors.grey.shade100)
                )
              ),
              width: double.infinity,
              child: SafeArea(
                child: Row(
                  children: <Widget>[
                    (onPrev != null) ? Expanded(
                      flex: 1,
                      child: ButtonIcon(
                        title: prevText, 
                        icon: Icons.chevron_left,
                        onTap: onPrev,
                        withoutText: !largeScreen,
                      ),
                    ) : Container(),
                    SizedBox(width: 16.0),
                    (onNext != null) ? Expanded(
                      flex: largeScreen ? 1 : 2,
                      child: ButtonIcon(
                        crossAxisAligment: CrossAxisAlignment.end,
                        title: nextText,
                        disableText: disableNext,
                        icon: Icons.chevron_right,
                        onTap: onNext,
                      ),
                    ) : Container()
                  ],
                ),
              ),
            ),
          ),

          if (floatingActionButton != null)
            Positioned(
              bottom: 80,
              right: 16,
              child: SafeArea(
                top: false,
                child: floatingActionButton,
              )
            )
        ],
      ),
    );
  }
}

class CustomWizardController extends ValueNotifier<int> {

  CustomWizardController({
    int value = 0,
  }) : super(value);

  int get index => value;

  set(int index) {
    value = index;
  }

  void prev() {
    var val = value - 1;
    set(val);
  }

  void next() {
    var val = value + 1;
    set(val);
  }
}