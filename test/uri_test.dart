import 'package:flutter_bebena_kit/api/base_api.dart';
import 'package:flutter_test/flutter_test.dart';


final configuration = ConfigurationAPI(
  baseUrl: "aguswidhiyasa.com",
  apiPrefixPath: "api/v1"
);

class Api extends BaseAPI {
  Api() : super(configuration);
}

void main() {
  
  test("Uri Testing", () {
    var api = Api();
    String path = api.baseUri("menu").toString();

    expect(path, "http://aguswidhiyasa.com/api/v1/menu");
  });
}