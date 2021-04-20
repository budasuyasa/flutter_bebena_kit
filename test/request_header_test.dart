import 'package:flutter_bebena_kit/api/api_configuration.dart';
import 'package:flutter_bebena_kit/api/base_api.dart';
import 'package:flutter_test/flutter_test.dart';

final configuration = ConfigurationURL(
  baseURL: "aguswidhiyasa.com",
  apiSuffixPath: "api/v1"
);

class Api extends BaseAPI {
  Api() : super(
    configurationURL :configuration
  );
}

final configuration2 = ConfigurationURL(
  baseURL: "aguswidhiyasa.com",
  apiSuffixPath: "api/v1"
);

class Api2 extends BaseAPI {
  Api2() : super(
    configurationURL: configuration2,
    configurationAPI: ConfigurationAPI(
      isJsonBody: true,
      overrideExceptionMessage: true
    )
  );

  @override
  Map<String, String> requestHeader() {
    return {
      'Content-Type': 'application/json',
    };
  }
}

void main() {

  test("Testing headers default", () {
    var api = Api();

    var rh = api.requestHeader();

    expect(rh["Content-Type"], 'application/x-www-form-urlencoded');
  });

  test("Testing headers with content `application/json`", () {
    var api = Api2();

    var rh = api.requestHeader();

    expect(rh["Content-Type"], 'application/json');
  });
}