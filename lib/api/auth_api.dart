import 'package:dio/dio.dart' as DIO;
import 'package:flutter/foundation.dart';
import 'package:flutter_bebena_kit/api/api_configuration.dart';
import 'package:flutter_bebena_kit/api/base_api.dart';

class AuthAPI extends BaseAPI implements OnInvalidToken, OnNetworkError {
  AuthAPI({ 
    @required ConfigurationAPI configurationAPI, 
    @required ConfigurationURL configurationURL,
    this.accessToken 
  }) : super(
    configurationAPI: configurationAPI,
    configurationURL: configurationURL
  ) {
    this.onInvalidToken = this;
    this.onNetworkError = this;
  }

  String accessToken;

  OnInvalidToken onInvalidTokenDelegate;
  OnNetworkError onNetworkErrorDelegate;


  Map<String, String> _appendWithAuth(Map<String, String> map) {
    if (map == null) {
      return {
        'Authorization': "Bearer $accessToken",
        'version': configurationURL.appVersion
      };
    } else {
      map['Authorization']  = "Bearer $accessToken";
      map['version']        = configurationURL.appVersion;
      return map;
    }
  }

  @override
  Future<Map<String, dynamic>> getFromApi(
    String path, {
      Map<String, String> queryParameter,
      Map<String, String> header,
      bool skipAuth = false
    }
  ) async {
    return await super.getFromApi(
      path, 
      queryParameter: queryParameter,
      header: _appendWithAuth(header),
      skipAuth: skipAuth
    );
  }

  @override
  Future<Map<String, dynamic>> postToApi(String path, {
    Map<String, String> postParameters, 
    Map<String, String> headers,
    Map<String, String> queryParameters
  }) async {
    headers = _appendWithAuth(headers);
    headers['Content-Type']   = "application/x-www-form-urlencoded";
    return await super.postToApi(path, queryParameters: queryParameters, postParameters: postParameters, headers: headers);
  }

  Future<Map<String, dynamic>> putToApi(String path, {
    Map<String, String> postParameters,
    Map<String, String> headers
  }) async {
    headers = _appendWithAuth(headers);
    headers['Content-Type']   = "application/x-www-form-urlencoded";

    return await super.putToApi(path, postParameters: postParameters, headers: headers);
  }

  @override
  Future<Map<String, dynamic>> patchToApi(String path, {
    Map<String, String> postParameters,
    Map<String, String> customHeader
  }) async {
    customHeader = _appendWithAuth(customHeader);
    customHeader['Content-Type']   = "application/x-www-form-urlencoded";
    return await super.patchToApi(path, postParameters: postParameters, customHeader: customHeader);
  }

  @override
  Future<Map<String, dynamic>> deleteFromApi(String path, { Map<String, String> headers }) async {
    headers = _appendWithAuth(headers);
    return await super.deleteFromApi(path, headers: headers);
  }

  @override
  Future<Map<String, dynamic>> postToApiUsingDio(
    String url, {
      Map<String, dynamic> postParameters, 
      Map<String, String> headers, 
      OnFileProgress progress,
      DIOPostType type = DIOPostType.post
    }
  ) async {
    headers = _appendWithAuth(headers);
    headers[DIO.Headers.contentTypeHeader]   = 'multipart/form-data';

    return await super.postToApiUsingDio(
      url,
      postParameters: postParameters,
      headers: headers,
      progress: progress,
      type: type
    );
  }

  Future<Map<String, dynamic>> patchToApiUsingDio(
    String url, {
      Map<String, dynamic> postParameters, 
      Map<String, String> headers, 
      OnFileProgress progress,
    }
  ) async {
    headers = _appendWithAuth(headers);
    headers[DIO.Headers.contentTypeHeader]   = 'multipart/form-data';

    return await super.postToApiUsingDio(
      url,
      postParameters: postParameters,
      headers: headers,
      progress: progress,
      type: DIOPostType.patch
    );
  }

  @override
  void onLogout(int statusCode, String message) {
    onInvalidTokenDelegate.onLogout(statusCode, message);
  }

  @override
  void onBadGateway() {
    onNetworkErrorDelegate.onBadGateway();
  }
}