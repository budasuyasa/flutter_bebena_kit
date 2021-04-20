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
    this.secureUrl            = false
  }): assert(!baseUrl.contains("http") || !baseUrl.contains("https"), "Tidak perlu http/https") {
    _baseUrl            = baseUrl;
    _developmentBaseUrl = developmentBaseUrl;
    _apiPrefixPath      = apiPrefixPath;
  }

  String _baseUrl;
  String _developmentBaseUrl;
  String _apiPrefixPath;
  bool isProduction;
  final String appVersion;
  final bool secureUrl;
  
  /// Return `String` of [baseUrl] with [apiPrefixPath]
  String get apiUrl {
    assert(!_baseUrl.contains("http"), "Http method is not required");

    // add http or https
    String httpPrefix = secureUrl ? "https://" : "http://";

    String prefixPath = _apiPrefixPath.endsWith('/') ? _apiPrefixPath : _apiPrefixPath + '/';

    String url = "";
    if (isProduction) {
      url = _baseUrl.endsWith('/') ? _baseUrl + prefixPath : "$_baseUrl/$prefixPath";
    } else {
      if (_developmentBaseUrl == null) {
        url = _baseUrl.endsWith('/') ? _baseUrl + prefixPath : "$_baseUrl/$prefixPath";
      } else {
        url = _developmentBaseUrl.endsWith('/') ? _developmentBaseUrl + prefixPath : "$_developmentBaseUrl/$prefixPath";
      }
    }

    return httpPrefix + url;
  }

  /// Get prodcution or development URL
  String get baseUrl {
    assert(!_baseUrl.contains("http"), "Http method is not required");

    // add http or https
    String httpPrefix = secureUrl ? "https://" : "http://";

    String url = "";

    if (isProduction) {
      url = _baseUrl.endsWith("/") ? _baseUrl : "$_baseUrl/";
    } else {
      if (_developmentBaseUrl == null) {
        url = _baseUrl.endsWith("/") ? _baseUrl : "$_baseUrl/";
      } else {
        url = _developmentBaseUrl.endsWith("/") ? _developmentBaseUrl : "$_developmentBaseUrl/";
      }
    }

    return httpPrefix + url;
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

  /// Indicate whenever the body is JSON or its FormUrlEncoded
  bool isJsonBody = false;

  /// Concat base url with path
  @deprecated
  String baseUrl(String path) => this.configurationAPI.apiUrl + path;

  Uri baseUri(String path, [ Map<String, dynamic> queryParameters ]) {
    String baseURL = (configurationAPI.isProduction) 
      ? configurationAPI._baseUrl
      : configurationAPI._developmentBaseUrl;

    String basePath = baseURL.replaceFirst("/", "");

    String apiSuffix = configurationAPI._apiPrefixPath;

    // checking if first character contains `/`, when matched, remove it
    if (apiSuffix.substring(0, 1) == "/") {
      apiSuffix = apiSuffix.substring(1);
    }

    if (apiSuffix.substring(apiSuffix.length - 1, apiSuffix.length) == "/") {
      apiSuffix = apiSuffix.substring(0, apiSuffix.length - 1);
    }

    // String apiPrefix = configurationAPI._apiPrefixPath.replaceFirst("/", "");
    //   // ? configurationAPI._apiPrefixPath
    //   // : configurationAPI._apiPrefixPath + '/';

    final uri = configurationAPI.secureUrl ? Uri.https(
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
    if (isJsonBody) {
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
    'version': configurationAPI.appVersion
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
    // if (!configurationAPI.isProduction) print("JSON Response ${response.body}");
    
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

  /// Get data from API
  /// 
  /// The [path] for request URL will be appended with [ConfigurationAPI.apiUrl],
  /// so its not needed to adding base path.
  Future<Map<String, dynamic>> getFromApi(
    String path, 
    { 
      Map<String, String> queryParameter,
      Map<String, String> header,
      bool skipAuth = false
    }
  ) async {
    try {
      final response = await get(baseUri(path, queryParameter), headers: header);
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
    Map<String, String> headers,
    Map<String, String> queryParameters
  }) async {
    String parameters = postParameters != null ? bodyParameters(postParameters) : null;
    if (headers == null) headers = requestHeader();
    try {
      final response = await post(baseUri(path, queryParameters), body: parameters, headers: headers);
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
    String parameters = postParameters != null ? bodyParameters(postParameters) : null;
    if (headers == null) headers = requestHeader();
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
    String parameters = postParameters != null ? bodyParameters(postParameters) : null;
    if (customHeader == null) customHeader = requestHeader();
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