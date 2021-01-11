import 'package:dio/dio.dart' as DIO;
import 'package:flutter_bebena_kit/api/base_api.dart';

class AuthAPI extends BaseAPI implements OnInvalidToken, OnNetworkError {
  AuthAPI(ConfigurationAPI config, { this.accessToken }) : super(config) {
    this.onInvalidToken = this;
    // this.onNetworkError = this;
  }

  String accessToken;

  OnInvalidToken onInvalidTokenDelegate;
  OnNetworkError onNetworkErrorDelegate;


  Map<String, String> _appendWithAuth(Map<String, String> map) {
    if (map == null) {
      return {
        'Authorization': "Bearer $accessToken",
        'version': configurationAPI.appVersion
      };
    } else {
      map['Authorization']  = "Bearer $accessToken";
      map['version']        = configurationAPI.appVersion;
      return map;
    }
  }

  @override
  Future<Map<String, dynamic>> getFromApi(String path, {Map<String, String> header}) async {
    return await super.getFromApi(path, header: _appendWithAuth(header));
  }

  @override
  Future<Map<String, dynamic>> postToApi(String path, {Map<String, String> postParameters, Map<String, String> headers}) async {
    headers = _appendWithAuth(headers);
    headers['Content-Type']   = "application/x-www-form-urlencoded";
    return await super.postToApi(path, postParameters: postParameters, headers: headers);
  }

  Future<Map<String, dynamic>> putToApi(String path, {
    Map<String, String> postParameters,
    Map<String, String> headers
  }) async {
    headers = _appendWithAuth(headers);
    headers['Content-Type']   = "application/x-www-form-urlencoded";

    return await super.postToApi(path, postParameters: postParameters, headers: headers);
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
  Future<Map<String, dynamic>> postToApiUsingDio(String url, {Map<String, dynamic> postParameters, Map<String, String> headers, OnFileProgress progress}) async {
    headers = _appendWithAuth(headers);
    headers[DIO.Headers.contentTypeHeader]   = 'multipart/form-data';

    return await super.postToApiUsingDio(
      url,
      postParameters: postParameters,
      headers: headers,
      progress: progress
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