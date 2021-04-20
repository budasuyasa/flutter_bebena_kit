
import 'package:flutter/foundation.dart';

class ConfigurationURL {

  ConfigurationURL({
    @required this.baseURL,
    this.developmentURL,
    this.apiSuffixPath        = "api",
    this.isProduction         = true,
    this.appVersion           = "1.0",
    this.secureUrl            = false
  }): assert(!baseURL.contains("http"), "Http or https method not required");

  /// Base URL the client accessed
  final String baseURL;

  /// Development URL
  final String developmentURL;

  /// Adding URL subpath on end of url
  /// 
  /// example when its set to `api/v1`, the url will generated to
  /// `http://baseurl.com/api/v1`
  /// 
  /// The default value is `api`
  final String apiSuffixPath;

  /// When `true` indicate the URL will pointing to Production or vice-versa
  bool isProduction;

  /// Optional Application version (optional)
  /// 
  /// This is requested for spesific reason
  final String appVersion;

  /// When set to `true` indicate the url is secure (using https) or not
  final bool secureUrl;
  
  /// Get generated api URL from config pointing to Development or Production (baseURL)
  String get apiUrl {
    assert(!baseURL.contains("http"), "Http method is not required");

    // add http or https
    String httpPrefix = secureUrl ? "https://" : "http://";

    String prefixPath = apiSuffixPath.endsWith('/') ? apiSuffixPath : apiSuffixPath + '/';

    String url = "";
    if (isProduction) {
      url = baseURL.endsWith('/') ? baseURL + prefixPath : "$baseURL/$prefixPath";
    } else {
      if (developmentURL == null) {
        url = baseURL.endsWith('/') ? baseURL + prefixPath : "$baseURL/$prefixPath";
      } else {
        url = developmentURL.endsWith('/') ? developmentURL + prefixPath : "$developmentURL/$prefixPath";
      }
    }

    return httpPrefix + url;
  }

  /// Get base URL pointing to Development or Production server automaticaly
  String get baseUrl {
    assert(!baseURL.contains("http"), "Http method is not required");

    // add http or https
    String httpPrefix = secureUrl ? "https://" : "http://";

    String url = "";

    if (isProduction) {
      url = baseURL.endsWith("/") ? baseURL : "$baseURL/";
    } else {
      if (developmentURL == null) {
        url = baseURL.endsWith("/") ? baseURL : "$baseURL/";
      } else {
        url = developmentURL.endsWith("/") ? developmentURL : "$developmentURL/";
      }
    }

    return httpPrefix + url;
  }
}

const String ERR_NETWORK = "Terjadi Kesalahan Jaringan";

/// Configuration class for API
class ConfigurationAPI {

  const ConfigurationAPI({
    this.isJsonBody                 = false,
    this.overrideExceptionMessage   = false,
    this.exceptionMessage           = ERR_NETWORK
  });

  /// Indicate whenever the body is JSON or its FormUrlEncoded
  final bool isJsonBody;

  /// Because when response has error message 
  /// it will throw exception with default message "Terjadi Kesalahan Jaringan"
  /// 
  /// If this set to `true`, instead default message it will show message 
  /// from field `message` on Request reponse
  final bool overrideExceptionMessage;

  /// Custom error message, when response code other than 200
  final String exceptionMessage;
}