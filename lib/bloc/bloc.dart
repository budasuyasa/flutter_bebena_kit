import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

enum BlocStatus {
  error,

  success,

  loading,

  init
}

/// Enum Status info for information
enum StatusInfo {
  error, warning, succes, loading, init, send
}

class Status {
  Status({
    this.statusInfo,
    this.message    = ""
  });
  final StatusInfo statusInfo;
  final String message;

  factory Status.init() => Status(
    statusInfo: StatusInfo.init,
    message: ""
  );

  Status copyWith({
    StatusInfo statusInfo,
    String message
  }) => Status(
    statusInfo: statusInfo ?? this.statusInfo,
    message: message ?? this.message
  );
}

abstract class BaseBloc<T> {
  void dispose();
}

/// Default block state agar mempermudah pemanggilan
class BlocState<T> {
  BlocState({
    this.status   = BlocStatus.init,
    this.message,
    this.data
  });

  final BlocStatus status;
  final T data;
  final String message;

  @override
  String toString() {
    return "$status - $message";
  }
}

typedef RenderBody<T> = Future<T> Function();

/// Base block/Parent bloc
class Bloc<T> extends BaseBloc {

  @mustCallSuper
  Bloc() { init(); }

  @protected
  StreamController _controller = StreamController<BlocState<T>>();
  Stream get stream => _controller.stream;
  StreamSink get sink => _controller.sink;

  /// Initialize status to [BlocStatus.init] so, status is not null when
  /// first initialized, avoiding NULL exception
  void init() => _controller.add(BlocState<T>(status: BlocStatus.init, data: null));

  /// Sink [data] when bloc completed
  set success(T data) => sink.add(BlocState<T>( status: BlocStatus.success, data: data ));

  /// Sink [message] to stream when fetching is loading
  set loading(String message) => sink.add(BlocState<T>( status: BlocStatus.loading, message: message ));

  /// Set loading with [data]
  set loadingData(T data) => sink.add(BlocState<T>( status: BlocStatus.loading, message: '', data: data ));

  void successWithMessage(T data, String message) => sink.add(BlocState<T>(status: BlocStatus.success, message: message, data: data));

  /// Show [errorMessage] when operational fail
  set error(String errorMessage) => sink.add(BlocState<T>( status: BlocStatus.error, message: errorMessage ));

  /// Get success [BlocState] data when success
  BlocState<T> getSuccess(T data) => BlocState<T>( status: BlocStatus.success, data: data );

  /// Get success [BlocState] data when error
  BlocState<T> getError(String errorMessage) => BlocState<T>( status: BlocStatus.error, message: errorMessage );

  void setStatusWithData(BlocStatus status, T data, [String message = ""]) => sink.add(BlocState<T>(status: status, message: message, data: data));

  /// Simplified body for code, for not much boiler plate
  /// 
  /// [body] is for function to required to run
  /// 
  /// example:
  /// ```
  /// runBloc(() async {
  ///   final response = await apiGoesHere();
  ///   return FormatingApiResponse.fromMap(response);
  /// });
  /// ```
  void runBloc(RenderBody<T> body) async {
    loading = "";
    try {
      final data = await body();
      success = data;
    } catch(e) {
      error = e.toString();
    }
  }


  @mustCallSuper
  @override
  void dispose() {
    _controller.close();
  }
}

/// Same as [Bloc] but with broadcast function
class BlocBroadcast<T> extends BaseBloc {

  @mustCallSuper
  BlocBroadcast() { init(); }

  BehaviorSubject<BlocState<T>> subject = BehaviorSubject<BlocState<T>>.seeded(BlocState<T>(status: BlocStatus.init, data: null));

  Stream get stream => subject.stream;


  // @protected
  // StreamController _controller = StreamController<BlocState<T>>.broadcast();
  // Stream get stream => _controller.stream;
  // StreamSink get sink => _controller.sink;

  void init() => subject.sink.add(BlocState<T>(status: BlocStatus.init, data: null));

  /// Set when [data] successfuly fetched
  set success(T data) => subject.sink.add(BlocState<T>( status: BlocStatus.success, data: data ));

  set loadingData(T data) => subject.sink.add(BlocState<T>( status: BlocStatus.loading, message: '', data: data ));

  /// Send [message] to stream when fetching is loading
  set loading(String message) => subject.sink.add(BlocState<T>( status: BlocStatus.loading, message: message ));

  /// Show [errorMessage] when operational fail
  set error(String errorMessage) => subject.sink.add(BlocState<T>( status: BlocStatus.error, message: errorMessage ));

  void errorWithData(T data, String errorMessage) => subject.sink.add(BlocState<T>( status: BlocStatus.error, message: errorMessage, data: data ));

  void setStatusWithData(BlocStatus status, T data) => subject.sink.add(BlocState<T>(status: status, message: "", data: data));

  /// Simplified body for code, for not much boiler plate
  /// 
  /// [body] is for function to required to run
  /// 
  /// example:
  /// ```
  /// runBloc(() async {
  ///   final response = await apiGoesHere();
  ///   return FormatingApiResponse.fromMap(response);
  /// });
  /// ```
  Future<void> runBloc(RenderBody<T> body) async {
    loading = "";
    try {
      final data = await body();
      success = data;
    } catch(e) {
      error = e.toString();
    }
  }


  @mustCallSuper
  @override
  void dispose() {
    subject.close();
  }
}