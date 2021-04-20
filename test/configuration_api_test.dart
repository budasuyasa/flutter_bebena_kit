import 'package:flutter_bebena_kit/api/api_configuration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Testing Configutation API production", () {
    var configuration = ConfigurationURL(
      baseURL: "aguswidhiyasa.com",
    );

    expect("http://aguswidhiyasa.com/api/", configuration.apiUrl);
    expect("http://aguswidhiyasa.com/", configuration.baseUrl);
  });

  test("Testing configuration with trailing /", () {
    var configuration = ConfigurationURL(
      baseURL: "aguswidhiyasa.com/"
    );

    expect("http://aguswidhiyasa.com/api/", configuration.apiUrl);
    expect("http://aguswidhiyasa.com/", configuration.baseUrl);
  });

  test("Testing configuration api development null", () {
    var configuration = ConfigurationURL(
      baseURL: "aguswidhiyasa.com",
      isProduction: false
    );

    expect("http://aguswidhiyasa.com/api/", configuration.apiUrl);
    expect("http://aguswidhiyasa.com/", configuration.baseUrl);
  });

  test("Testing configuration api Prefix", () {
    var configuration = ConfigurationURL(
      baseURL: "aguswidhiyasa.com",
      apiSuffixPath: "api/v1"
    );

    expect("http://aguswidhiyasa.com/api/v1/", configuration.apiUrl);
  });

  test("Testing configuration api development", () {
    var configuration = ConfigurationURL(
      baseURL: "aguswidhiyasa.com",
      developmentURL: "dev.aguswidhiyasa.com",
      isProduction: false
    );

    expect("http://dev.aguswidhiyasa.com/api/", configuration.apiUrl);
    expect("http://dev.aguswidhiyasa.com/", configuration.baseUrl);
  });
}