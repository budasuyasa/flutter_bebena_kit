import 'package:flutter_bebena_kit/api/base_api.dart';
import 'package:flutter_test/flutter_test.dart';

final configuration = ConfigurationAPI(
  baseUrl: "aguswidhiyasa.com",
  apiPrefixPath: "api/v1"
);

class Api extends BaseAPI {
  Api() : super(configuration);
}

final configuration2 = ConfigurationAPI(
  baseUrl: "aguswidhiyasa.com",
  apiPrefixPath: "api/v1"
);

class Api2 extends BaseAPI {
  Api2() : super(configuration2);

  @override
  bool get isJsonBody => true;

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

  test("Checking if post parameters is json", () {
    var api = Api2();

    isNot(!api.isJsonBody);
  });
}