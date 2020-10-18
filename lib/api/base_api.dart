import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as DIO;
import 'package:flutter/foundation.dart';
import 'package:flutter_bebena_kit/exceptions/custom_exception.dart';
import 'package:http/http.dart';

/// Configuration for api request
class ConfigurationAPI {
  ConfigurationAPI({
    @required String baseUrl,
    String developmentBaseUrl,
    String apiPrefixPath = "api",
    this.isProduction = true,
    this.appVersion = "1.0"
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

abstract class BaseAPI {
  BaseAPI(this.configurationAPI) {}

  final ConfigurationAPI  configurationAPI;

  /// Concat base url with path
  String baseUrl(String path) => this.configurationAPI.apiUrl + path;

  /// Format [param] `Map<String, dynamic>` menjadi form __urlEncoded__
  /// 
  /// contoh dari:
  /// ```
  ///   var data = {
  ///     "data1": "value1",
  ///     "data2": "value2"
  ///   }
  /// ```
  /// menjadi:
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

  Map<String, String> get formEncodedHeader => {
    'Content-Type': 'application/x-www-form-urlencoded',
    'version': configurationAPI.appVersion
  };

    /// Simplified [http.Response] checking.
  /// 
  /// Jika status response == 200 maka parsing data dan check status
  /// jika kosong throw default [CustomException] 
  Map<String, dynamic> checkingResponse(Response response) {
    // if (!configuration.isProduction) print("JSON Response ${response.body}");
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
        throw CustomException("Token Expired");
      default: 
        throw CustomException(ERR_NETWORK);
    }
  }

  Future<Map<String, dynamic>> getFromApi(String path, { Map<String, String> header }) async {
    try {
      final response = await get(baseUrl(path), headers: header);
      return checkingResponse(response);
    } catch (e) {
      throw CustomException(configurationAPI.isProduction ? ERR_NETWORK : e.toString());
    }
  }

  Future<Map<String, dynamic>> postToApi(String path, {
    Map<String, String> postParameters,
    Map<String, String> headers
  }) async {
    String parameters = postParameters != null ? fromMapToFormUrlEncoded(postParameters) : null;
    if (headers == null) headers = formEncodedHeader;
    try {
      final response = await post(baseUrl(path), body: parameters, headers: headers);
      return checkingResponse(response);
    } catch(e) {
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
  Future<Map<String, dynamic>> postToApiUsingDio(String url, { Map<String, dynamic> postParameters, Map<String, String> headers }) async {
    DIO.Dio dio = DIO.Dio();

    DIO.FormData body = postParameters != null ? DIO.FormData.fromMap(postParameters) : null;

    try {
      var response = await dio.post(
        baseUrl(url),
        data: body,
        options: DIO.Options(
          method: "POST",
          headers: headers
        )
      );

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