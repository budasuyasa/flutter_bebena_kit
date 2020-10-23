import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/bloc/bloc.dart';
import 'package:flutter_bebena_kit/widgets/empty_placeholder.dart';

typedef StreamBuilderBlocCallback<T> = Widget Function(BuildContext, T, BlocStatus, String);
typedef StreamBuilderBlocCustomError = Widget Function(String errorMessage);

/// Stream Builder wrapper for Bloc
/// 
/// because using normal stream builder to much same boiler plate
/// 
/// see [StreamBuilder]
/// 
/// see [Bloc]
/// 
/// [T] must have extends [BlocState]
class StreamBuilderBloc<T> extends StatelessWidget {
  StreamBuilderBloc({
    @required this.stream,
    @required this.builder,
    this.customError,
    this.disableLoading = false,
    this.disableErrorScreen = false,
    this.isInit = false
  });

  final Stream<BlocState<T>> stream;
  
  final StreamBuilderBlocCallback<T> builder;

  /// Create [customError] screen, when its not null
  /// it will override default error
  final StreamBuilderBlocCustomError customError;

  /// Disable loading when bloc status is [BlocStatus.loading],
  /// preventing to showing loading indicator,
  /// 
  /// suitable for Pagination list
  final bool disableLoading;

  /// Disable full error screen when status is [BlocStatus.error]
  final bool disableErrorScreen;

  /// Disable loading indicator on [BlocStatus.init]
  /// preventing to showing loading indicator
  /// 
  /// suitable for initial view data
  final bool isInit;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BlocState<T>>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<BlocState<T>> snap) {
        if (snap.hasError) {
          return EmptyPlaceholder(
            message: snap.error,
          );
        }

        if (snap.hasData) {
          if (disableLoading && snap.data == null) return Container();
          if (snap.data.status == BlocStatus.error && (!disableErrorScreen)) {
            if (customError == null) {
              return EmptyPlaceholder(message: snap.data.message);
            } else {
              return customError(snap.data.message ?? "Terjadi Kesalahan");
            }
          }

          if ((snap.data.status == BlocStatus.loading) && (!disableLoading)) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator())
            );
          }

          print(snap.data.status);

          if (snap.data == null) {
            return Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(child: CircularProgressIndicator())
            );
          } else {
            return builder(context, snap.data.data, snap.data.status, snap.data.message);
          }
        }

        if (isInit) {
          return builder(context, null, BlocStatus.init, "");
        } else {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Center(child: CircularProgressIndicator())
          );
        }
      },
    );
  }
}