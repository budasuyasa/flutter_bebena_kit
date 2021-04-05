import 'dart:convert';

import 'package:dio/dio.dart' as DIO;
import 'package:flutter/foundation.dart';
import 'package:flutter_bebena_kit/exceptions/custom_exception.dart';
import 'package:http/http.dart';

typedef OnFileProgress = void Function(int, int);

enum DIOPostType { post, put, patch, delete }

/// Configuration object for Networking
class ConfigurationAPI {
  ConfigurationAPI({
    @required String baseUrl,
    String developmentBaseUrl,
    String apiPrefixPath      = "api",
    this.isProduction         = true,
    this.appVersion           = "1.0",
  }) {
    _baseUrl            = baseUrl;
    _developmentBaseUrl = developmentBaseUrl;
    _apiPrefixPath      = apiPrefixPath;
  }

  String _baseUrl;
  String _developmentBaseUrl;
  String _apiPrefixPath;
  bool isProduction;
  final String appVersion;
  
  /// Return `String` of [baseUrl] with [apiPrefixPath]
  String get apiUrl {
    String prefixPath = _apiPrefixPath.endsWith('/') ? _apiPrefixPath : _apiPrefixPath + '/';
    if (isProduction) {
      return _baseUrl.endsWith('/') ? _baseUrl + prefixPath : "$_baseUrl/$prefixPath";
    } else {
      if (_developmentBaseUrl == null) {
        return _baseUrl.endsWith('/') ? _baseUrl + prefixPath : "$_baseUrl/$prefixPath";
      } else {
        return _developmentBaseUrl.endsWith('/') ? _developmentBaseUrl + prefixPath : "$_developmentBaseUrl/$prefixPath";
      }
    }
  }

  /// Get prodcution or development URL
  String get baseUrl {
    if (isProduction) {
      return _baseUrl.endsWith("/") ? _baseUrl : "$_baseUrl/";
    } else {
      if (_developmentBaseUrl == null) {
        return _baseUrl.endsWith("/") ? _baseUrl : "$_baseUrl/";
      } else {
        return _developmentBaseUrl.endsWith("/") ? _developmentBaseUrl : "$_developmentBaseUrl/";
      }
    }
  }
}

/// Mixins untuk melakukan focre logout
mixin OnInvalidToken {
  void onLogout(int statusCode, String message) {}
}

mixin OnNetworkError {
  void onBadGateway() {}
}

abstract class BaseAPI {
  BaseAPI(this.configurationAPI);

  final ConfigurationAPI  configurationAPI;

  OnInvalidToken onInvalidToken;
  OnNetworkError onNetworkError;

  /// Concat base url with path
  @deprecated
  String baseUrl(String path) => this.configurationAPI.apiUrl + path;

  Uri baseUri(String path) => Uri.http(configurationAPI.apiUrl, path);

  /// Format [param] to be form encoded `String`
  /// 
  /// Example:
  /// ```
  ///   var data = {
  ///     "data1": "value1",
  ///     "data2": "value2"
  ///   }
  /// ```
  /// to:
  /// 
  /// `data1=value1&data2=value2`
  String fromMapToFormUrlEncoded(Map<String, String> param) {
    var parts = [];
    param.forEach((key, val) {
      parts.add(
          '${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(val)}');
    });

    return parts.join("&");
  }

  /// Additional header for POST based API request
  Map<String, String> get formEncodedHeader => {
    'Content-Type': 'application/x-www-form-urlencoded',
    'version': configurationAPI.appVersion
  };
  
  /// Checking [response] whenever its successfull or not. 
  /// It will throwing [CustomException] when HTTP status code not 200
  /// 
  /// When imlementing [OnInvalidToken] or [OnNetworkError] the result will be 
  /// overriden.
  /// 
  /// Sometimes we need [skipAuth] to fetch data without checking for invalid token
  Map<String, dynamic> checkingResponse(Response response, { bool skipAuth = false }) {
    // if (!configurationAPI.isProduction) print("JSON Response ${response.body}");
    
    switch (response.statusCode) {
      case 200:
        var _response = json.decode(response.body);
        if (_response['status'] == 'success') {
          return _response;
        } else {
          throw CustomException(_response['message']);
        }
        break;
      case 401:
        if (onInvalidToken != null && !skipAuth)
          onInvalidToken.onLogout(401, "Token Expired");
        
        throw CustomException(ERR_NETWORK);
        break;
      case 502:
        if (onNetworkError != null)
          onNetworkError.onBadGateway();
        
        throw CustomException(ERR_NETWORK);
        break;
      default: 
        throw CustomException(ERR_NETWORK);
    }
  }

  /// Get data from API
  /// 
  /// The [path] for request URL will be appended with [ConfigurationAPI.apiUrl],
  /// so its not needed to adding base path.
  Future<Map<String, dynamic>> getFromApi(
    String path, 
    { 
      Map<String, String> header,
      bool skipAuth = false
    }
  ) async {
    try {
      final response = await get(baseUri(path), headers: header);
      return checkingResponse(response, skipAuth: skipAuth);
    } catch (e) {
      throw CustomException(configurationAPI.isProduction ? ERR_NETWORK : e.toString());
    }
  }

  /// POST data to API
  /// 
  /// The [path] for request URL will be appended with [ConfigurationAPI.apiUrl],
  /// so its not needed to adding base path.
  Future<Map<String, dynamic>> postToApi(String path, {
    Map<String, String> postParameters,
    Map<String, String> headers
  }) async {
    String parameters = postParameters != null ? fromMapToFormUrlEncoded(postParameters) : null;
    if (headers == null) headers = formEncodedHeader;
    try {
      final response = await post(baseUri(path), body: parameters, headers: headers);
      return checkingResponse(response);
    } catch(e) {
      throw CustomException(configurationAPI.isProduction ? ERR_NETWORK : e.toString());
    }
  }

  /// PUT data to API
  /// 
  /// The [path] for request URL will be appended with [ConfigurationAPI.apiUrl],
  /// so its not needed to adding base path.
  Future<Map<String, dynamic>> putToApi(String path, {
    Map<String, String> postParameters,
    Map<String, String> headers
  }) async {
    String parameters = postParameters != null ? fromMapToFormUrlEncoded(postParameters) : null;
    if (headers == null) headers = formEncodedHeader;
    try {
      final response = await put(baseUri(path), body: parameters, headers: headers);
      return checkingResponse(response);
    } catch(e) {
      throw CustomException(configurationAPI.isProduction ? ERR_NETWORK : e.toString());
    }
  }

  /// Patch data on API
  /// 
  /// The [path] for request URL will be appended with [ConfigurationAPI.apiUrl],
  /// so its not needed to adding base path.
  Future<Map<String, dynamic>> patchToApi(String path, {
    Map<String, String> postParameters,
    Map<String, String> customHeader
  }) async {
    String parameters = postParameters != null ? fromMapToFormUrlEncoded(postParameters) : null;
    if (customHeader == null) customHeader = formEncodedHeader;
    try {
      final response = await patch(baseUri(path), body: parameters, headers: customHeader);
      return checkingResponse(response);
    } catch(e) {
      throw CustomException(configurationAPI.isProduction ? ERR_NETWORK : e.toString());
    }
  }

  /// Delete data from API
  /// 
  /// The [path] for request URL will be appended with [ConfigurationAPI.apiUrl],
  /// so its not needed to adding base path.
  Future<Map<String, dynamic>> deleteFromApi(String path, { Map<String, String> headers }) async {

    try {
      final response = await delete(
        baseUri(path),
        headers: headers
      );
      return checkingResponse(response);
    } catch (e) {
      throw CustomException(configurationAPI.isProduction ? ERR_NETWORK : e.toString());
    }
  }


  /// Custom post to api using [httpDio.Dio]
  /// 
  /// path [url] will be concated to [URLs.BASE_API]
  /// 
  /// [postParameters] is using for parameter to send to server
  /// 
  /// Example:
  /// ```
  /// await postToApiUsingDio('path1', {
  ///     "param1": "value1",
  ///     "param2": "value2"
  /// });
  /// ```
  /// 
  /// See Also:
  ///   * [AuthApi.postToApi]
  Future<Map<String, dynamic>> postToApiUsingDio(
    String url, { 
      Map<String, dynamic> postParameters, 
      Map<String, String> headers, 
      OnFileProgress progress,
      DIOPostType type = DIOPostType.post
    }
  ) async {

    DIO.Dio dio = DIO.Dio();

    DIO.FormData body = postParameters != null ? DIO.FormData.fromMap(postParameters) : null;

    try {
      var response;
      switch (type) {
        case DIOPostType.post:
          response = await dio.post(
            baseUrl(url),
            data: body,
            options: DIO.Options(
              method: "POST",
              headers: headers
            ),
            onSendProgress: progress
          );
          break;
        case DIOPostType.put:
          throw Exception("Not Implemented");
          break;
        case DIOPostType.patch:
          response = await dio.patch(
            baseUrl(url),
            data: body,
            options: DIO.Options(
              method: "POST",
              headers: headers
            ),
            onSendProgress: progress
          );
          break;
        case DIOPostType.delete:
          throw Exception("Not Implemented");
          break;
      }

      var _response = response.data;
      if (_response['status'] == 'success') {
        return _response;
      } else {
        throw CustomException(_response['message']);
      }
    } catch (e) {
      throw CustomException(configurationAPI.isProduction ? ERR_NETWORK : e.toString());
    }
  }
}

const String ERR_NETWORK = "Terjadi Kesalahan Jaringan";