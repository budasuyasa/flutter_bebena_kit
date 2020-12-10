import 'package:flutter_bebena_kit/api/base_api.dart';
import 'package:http/http.dart';

class API extends BaseAPI {
  API(ConfigurationAPI configurationAPI) : super(configurationAPI);

  OnNetworkError onNetworkErrorDelegate;

  @override
  Map<String, dynamic> checkingResponse(Response response) {
    if (onNetworkErrorDelegate != null) {
      if (response.statusCode == 502) {
        onNetworkErrorDelegate.onBadGateway();
        return null;
      }
      return super.checkingResponse(response);
    }
    return super.checkingResponse(response);
  }
}