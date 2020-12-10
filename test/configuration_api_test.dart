import 'package:flutter_bebena_kit/api/base_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Testing Configutation API production", () {
    var configuration = ConfigurationAPI(
      baseUrl: "http://aguswidhiyasa.com",
    );

    expect("http://aguswidhiyasa.com/api/", configuration.apiUrl);
    expect("http://aguswidhiyasa.com/", configuration.baseUrl);
  });

  test("Testing configuration with trailing /", () {
    var configuration = ConfigurationAPI(
      baseUrl: "http://aguswidhiyasa.com/"
    );

    expect("http://aguswidhiyasa.com/api/", configuration.apiUrl);
    expect("http://aguswidhiyasa.com/", configuration.baseUrl);
  });

  test("Testing configuration api development null", () {
    var configuration = ConfigurationAPI(
      baseUrl: "http://aguswidhiyasa.com",
      isProduction: false
    );

    expect("http://aguswidhiyasa.com/api/", configuration.apiUrl);
    expect("http://aguswidhiyasa.com/", configuration.baseUrl);
  });

  test("Testing configuration api development", () {
    var configuration = ConfigurationAPI(
      baseUrl: "http://aguswidhiyasa.com",
      developmentBaseUrl: "http://dev.aguswidhiyasa.com",
      isProduction: false
    );

    expect("http://dev.aguswidhiyasa.com/api/", configuration.apiUrl);
    expect("http://dev.aguswidhiyasa.com/", configuration.baseUrl);
  });
}