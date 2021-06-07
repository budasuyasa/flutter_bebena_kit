import 'dart:convert';

import 'package:dio/dio.dart' as DIO;
import 'package:flutter_bebena_kit/api/api_configuration.dart';
import 'package:flutter_bebena_kit/exceptions/custom_exception.dart';
import 'package:http/http.dart';

import '../exceptions/custom_exception.dart';

typedef OnFileProgress = void Function(int, int);

enum DIOPostType { post, put, patch, delete }

/// Mixins untuk melakukan focre logout
mixin OnInvalidToken {
  void onLogout(int statusCode, String message) {}
}

mixin OnNetworkError {
  void onBadGateway() {}
}

abstract class BaseAPI {
  BaseAPI({
    this.configurationAPI = const ConfigurationAPI(),
    this.configurationURL
  });

  final ConfigurationAPI  configurationAPI;
  final ConfigurationURL  configurationURL;

  OnInvalidToken onInvalidToken;
  OnNetworkError onNetworkError;

  /// Concat base url with path
  @deprecated
  String baseUrl(String path) => this.configurationURL.apiUrl + path;

  Uri baseUri(String path, [ Map<String, dynamic> queryParameters ]) {
    String baseURL = (configurationURL.isProduction) 
      ? configurationURL.baseURL
      : configurationURL.developmentURL;

    String basePath = baseURL.replaceFirst("/", "");

    String apiSuffix = configurationURL.apiSuffixPath;

    // checking if first character contains `/`, when matched, remove it
    if (apiSuffix.substring(0, 1) == "/") {
      apiSuffix = apiSuffix.substring(1);
    }

    if (apiSuffix.substring(apiSuffix.length - 1, apiSuffix.length) == "/") {
      apiSuffix = apiSuffix.substring(0, apiSuffix.length - 1);
    }

    final uri = configurationURL.secureUrl ? Uri.https(
      basePath, 
      (apiSuffix + "/" + path),
      queryParameters
    ) : Uri.http(
      basePath, 
      (apiSuffix + "/" + path),
      queryParameters
    );

    return uri;
  } 

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
  /// 
  /// but when `isJsonBody` is `true`, the data will be return
  /// as formated json [String]
  String bodyParameters(Map<String, String> param) {
    if (configurationAPI.isJsonBody) {
      return jsonEncode(param);
    } else {
      var parts = [];
      param.forEach((key, val) {
        parts.add(
            '${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(val)}');
      });

      return parts.join("&");
    }
    
  }

  /// Additional header for POST based API request
  Map<String, String> get formEncodedHeader => {
    'Content-Type': 'application/x-www-form-urlencoded',
    'version': configurationURL.appVersion
  };

  Map<String, String> requestHeader() {
    return this.formEncodedHeader;
  }
  
  /// Checking [response] whenever its successfull or not. 
  /// It will throwing [CustomException] when HTTP status code not 200
  /// 
  /// When imlementing [OnInvalidToken] or [OnNetworkError] the result will be 
  /// overriden.
  /// 
  /// Sometimes we need [skipAuth] to fetch data without checking for invalid token
  Map<String, dynamic> checkingResponse(Response response, { bool skipAuth = false }) {
    // if (!configurationURL.isProduction) print("JSON Response ${response.body}");
    
    switch (response.statusCode) {
      case 200:
      case 400:
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

  void _throwResponse(String message, [ bool allowMessageFromServer = false]) {
    if (configurationAPI.overrideExceptionMessage) {
      throw CustomException(message);
    } else {
      if (allowMessageFromServer) {
        throw CustomException(message);
      } else {
        throw CustomException(configurationURL.isProduction ? configurationAPI.exceptionMessage : message);
      }
    }
  }

  /// Get data from API
  /// 
  /// The [path] for request URL will be appended with [ConfigurationAPI.apiUrl],
  /// so its not needed to adding base path.
  Future<Map<String, dynamic>> getFromApi(
    String path, 
    { 
      Map<String, String> queryParameter,
      Map<String, String> header,
      bool skipAuth = false,
      bool allowMessageFromServer = false
    }
  ) async {
    try {
      final response = await get(baseUri(path, queryParameter), headers: header);
      return checkingResponse(response, skipAuth: skipAuth);
    } catch (e) {
      _throwResponse(e.toString(), allowMessageFromServer);
      return null;
    }
  }

  /// POST data to API
  /// 
  /// The [path] for request URL will be appended with [ConfigurationAPI.apiUrl],
  /// so its not needed to adding base path.
  Future<Map<String, dynamic>> postToApi(String path, {
    Map<String, String> postParameters,
    Map<String, String> headers,
    Map<String, String> queryParameters,
    bool allowMessageFromServer = false
  }) async {
    String parameters = postParameters != null ? bodyParameters(postParameters) : null;
    if (headers == null) headers = requestHeader();
    try {
      final response = await post(baseUri(path, queryParameters), body: parameters, headers: headers);
      return checkingResponse(response);
    } catch(e) {
      _throwResponse(e.toString(), allowMessageFromServer);
      return null;
    }
  }

  /// PUT data to API
  /// 
  /// The [path] for request URL will be appended with [ConfigurationAPI.apiUrl],
  /// so its not needed to adding base path.
  Future<Map<String, dynamic>> putToApi(String path, {
    Map<String, String> postParameters,
    Map<String, String> headers,
    bool allowMessageFromServer = false
  }) async {
    String parameters = postParameters != null ? bodyParameters(postParameters) : null;
    if (headers == null) headers = requestHeader();
    try {
      final response = await put(baseUri(path), body: parameters, headers: headers);
      return checkingResponse(response);
    } catch(e) {
      _throwResponse(e.toString(), allowMessageFromServer);
      return null;
    }
  }

  /// Patch data on API
  /// 
  /// The [path] for request URL will be appended with [ConfigurationAPI.apiUrl],
  /// so its not needed to adding base path.
  Future<Map<String, dynamic>> patchToApi(String path, {
    Map<String, String> postParameters,
    Map<String, String> customHeader,
    bool allowMessageFromServer = false
  }) async {
    String parameters = postParameters != null ? bodyParameters(postParameters) : null;
    if (customHeader == null) customHeader = requestHeader();
    try {
      final response = await patch(baseUri(path), body: parameters, headers: customHeader);
      return checkingResponse(response);
    } catch(e) {
      _throwResponse(e.toString(), allowMessageFromServer);
      return null;
    }
  }

  /// Delete data from API
  /// 
  /// The [path] for request URL will be appended with [ConfigurationAPI.apiUrl],
  /// so its not needed to adding base path.
  Future<Map<String, dynamic>> deleteFromApi(
    String path, { 
        Map<String, String> headers,
        bool allowMessageFromServer = false
      }
    ) async {

    try {
      final response = await delete(
        baseUri(path),
        headers: headers
      );
      return checkingResponse(response);
    } catch (e) {
      _throwResponse(e.toString(), allowMessageFromServer);
      return null;
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
      DIOPostType type = DIOPostType.post,
      bool allowMessageFromServer = false
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
          response = await dio.put(
            baseUrl(url),
            data: body,
            options: DIO.Options(
              method: "PUT",
              headers: headers
            ),
            onSendProgress: progress
          );
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
      _throwResponse(e.toString(), allowMessageFromServer);
      return null;
    }
  }
}