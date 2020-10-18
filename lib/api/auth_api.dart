import 'package:dio/dio.dart' as DIO;
import 'package:flutter_bebena_kit/api/base_api.dart';
import 'package:flutter_bebena_kit/exceptions/custom_exception.dart';
import 'package:http/http.dart';

class AuthAPI extends BaseAPI {
  AuthAPI(ConfigurationAPI configurationAPI, this.accessToken) : super(configurationAPI);

  final String accessToken;

  OnInvalidToken onInvalidTokenDelegate;

  Map<String, String> _appendWithAuth(Map<String, String> map) {
    map['Authorization']  = "Bearer $accessToken";
    map['version']        = configurationAPI.appVersion;
    return map;
  }

  @override
  Future<Map<String, dynamic>> getFromApi(String path, {Map<String, String> header}) async {
    try {
      final response = await get(
        baseUrl(path),
        headers: _appendWithAuth(header)
      );
      return checkingResponse(response);
    } catch(e) {
      throw CustomException(configurationAPI.isProduction ? ERR_NETWORK : e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> postToApi(String path, {Map<String, String> postParameters, Map<String, String> headers}) async {
    headers = _appendWithAuth(headers);
    headers['Content-Type']   = "application/x-www-form-urlencoded";

    String body = (postParameters != null) ? fromMapToFormUrlEncoded(postParameters) : null;

    try {
      final response = await post(
        baseUrl(path),
        body: body,
        headers: headers
      );
      return checkingResponse(response);
    } catch (e) {
      throw CustomException(configurationAPI.isProduction ? ERR_NETWORK : e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> postToApiUsingDio(String url, {Map<String, dynamic> postParameters, Map<String, String> headers}) async {
    headers = _appendWithAuth(headers);
    headers['Content-Type']   = "application/x-www-form-urlencoded";

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

  @override
  Map<String, dynamic> checkingResponse(Response response) {
    if (onInvalidTokenDelegate != null) {
      if (response.statusCode == 401) {
        onInvalidTokenDelegate.onLogout(response.statusCode, "Logout");
        return null;
      } else {
        return super.checkingResponse(response);
      }
    } else {
      return super.checkingResponse(response);
    }
  }
}