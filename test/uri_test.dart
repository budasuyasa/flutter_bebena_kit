import 'package:flutter_bebena_kit/api/api_configuration.dart';
import 'package:flutter_bebena_kit/api/base_api.dart';
import 'package:flutter_test/flutter_test.dart';


final configuration = ConfigurationURL(
  baseURL: "aguswidhiyasa.com",
  apiSuffixPath: "api/v1"
);

final configuration2 = ConfigurationURL(
  baseURL: "aguswidhiyasa.com",
  developmentURL: "dev.aguswidhiyasa.com",
  apiSuffixPath: "/api/"
);

final configuration3 = ConfigurationURL(
  baseURL: "aguswidhiyasa.com",
  developmentURL: "dev.aguswidhiyasa.com",
  apiSuffixPath: "/api/",
  isProduction: false
);

class Api extends BaseAPI {
  Api() : super(
    configurationURL: configuration
  );
}

class Api2 extends BaseAPI {
  Api2(): super(
    configurationURL: configuration2
  );
}

class Api3 extends BaseAPI {
  Api3(): super(
    configurationURL: configuration3
  );
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