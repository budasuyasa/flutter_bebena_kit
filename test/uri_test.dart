import 'package:flutter_bebena_kit/api/base_api.dart';
import 'package:flutter_test/flutter_test.dart';


final configuration = ConfigurationAPI(
  baseUrl: "aguswidhiyasa.com",
  apiPrefixPath: "api/v1"
);

final configuration2 = ConfigurationAPI(
  baseUrl: "aguswidhiyasa.com",
  developmentBaseUrl: "dev.aguswidhiyasa.com",
  apiPrefixPath: "/api/"
);

final configuration3 = ConfigurationAPI(
  baseUrl: "aguswidhiyasa.com",
  developmentBaseUrl: "dev.aguswidhiyasa.com",
  apiPrefixPath: "/api/",
  isProduction: false
);

class Api extends BaseAPI {
  Api() : super(configuration);
}

class Api2 extends BaseAPI {
  Api2(): super(configuration2);
}

class Api3 extends BaseAPI {
  Api3(): super(configuration3);
}

void main() {
  
  test("Uri Testing", () {
    var api = Api();
    String path = api.baseUri("menu").toString();

    expect(path, "http://aguswidhiyasa.com/api/v1/menu");
  });

  test("Uri Testing without suffix", () {
    var api = Api2();
    String path = api.baseUri("activity").toString();

    expect(path, "http://aguswidhiyasa.com/api/activity");
  });

  test("Development Uri Testing without suffix", () {
    var api = Api3();
    String path = api.baseUri("activity").toString();

    expect(path, "http://dev.aguswidhiyasa.com/api/activity");
  });
}