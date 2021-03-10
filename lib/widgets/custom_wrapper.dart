import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/flutter_bebena.dart';

typedef FloatingBar = FloatingAppBar Function(ScrollController controller);

class CustomWrapper extends StatefulWidget {

  final Widget child;
  final Widget bottomWidget;
  final FloatingBar appBar;

  final EdgeInsetsGeometry padding;

  final Function onWrapperTap;

  CustomWrapper({
    Key key,
    this.child,
    this.bottomWidget,
    this.appBar,

    this.padding,
    this.onWrapperTap
  }): super(key: key);

  @override
  _CustomWrapperState createState() => _CustomWrapperState();
}

class _CustomWrapperState extends State<CustomWrapper> {

  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Stack(
        children: [

          Positioned.fill(child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: widget.padding ?? EdgeInsets.zero,
              child: widget.child,
            ),
          )),

          if (widget.appBar != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: widget.appBar(_scrollController),
            ),

          if (widget.bottomWidget != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: widget.bottomWidget
            )

        ],
      ),
    );
  }
}

// class CustomWrapper extends StatelessWidget {

//   final ScrollController scrollController;
//   final FlotingBar floatingAppBar;
//   final Widget bottomWidget;
//   final EdgeInsetsGeometry padding;
//   final Function onWrapperTap;

//   final Widget child;

//   CustomWrapper({
//     Key key, 
//     this.scrollController,
//     this.floatingAppBar, 
//     this.bottomWidget, 
//     this.padding = EdgeInsets.zero,
//     this.onWrapperTap,
//     this.child,
//   }) : assert((child != null), "Use either container or children"), 
//   super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [

//         Positioned.fill(
//           child: Container(
//             width: double.infinity,
//             child: SingleChildScrollView(child: child),
//           )
//         ),
//         // if (container == null)
//         //   SingleChildScrollView(
//         //         controller: scrollController,
//         //         child: children != null ? Container(
//         //           margin: const EdgeInsets.only(bottom: 80),
//         //           padding: padding,
//         //           child: Container(
//         //             child: Column(
//         //               crossAxisAlignment: CrossAxisAlignment.stretch,
//         //               children: children
//         //             ),
//         //           ),
//         //         ) : Container(),
//         //       ),

//         // if (children == null)
//         //   SingleChildScrollView(
//         //     controller: scrollController,
//         //     child: Padding(
//         //       padding: padding,
//         //       child: container
//         //     )
//         //   ),

//         // if (floatingAppBar != null)
//         //   Positioned(
//         //     top: 0,
//         //     left: 0,
//         //     right: 0,
//         //     child: floatingAppBar(scrollController)
//         //   ),
//         // if (bottomWidget != null)
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: bottomWidget
//           ),
//       ],
//     );

//     // return Container(
//     //   width: double.infinity,
//     //   height: MediaQuery.of(context).size.height,
//     //   child: Stack(
//     //     children: [
//     //       if (container == null)
//     //         SingleChildScrollView(
//     //           controller: this.scrollController ?? _scrollController,
//     //           child: children != null ? Container(
//     //             margin: const EdgeInsets.only(bottom: 80),
//     //             padding: padding,
//     //             child: Container(
//     //               child: Column(
//     //                 crossAxisAlignment: CrossAxisAlignment.stretch,
//     //                 children: children
//     //               ),
//     //             ),
//     //           ) : Container(),
//     //         ),

//     //       if (children == null)
//     //         SingleChildScrollView(
//     //           controller: this._scrollController ?? _scrollController,
//     //           child: Padding(
//     //             padding: padding,
//     //             child: container
//     //           )
//     //         ),

//     //       if (floatingAppBar != null)
//     //         floatingAppBar(this.scrollController ?? _scrollController),

//     //       if (bottomWidget != null)
//     //         Positioned(
//     //           bottom: 0,
//     //           left: 0,
//     //           right: 0,
//     //           child: bottomWidget
//     //         ),
//     //     ],
//     //   ),
//     // );
//   }
// }