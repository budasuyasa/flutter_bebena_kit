import 'package:flutter_bebena_kit/api/base_api.dart';

class API extends BaseAPI implements OnNetworkError {
  API(ConfigurationAPI configurationAPI) : super(configurationAPI) {
    this.onNetworkError = this;
  }

  OnNetworkError onNetworkErrorDelegate;

  @override
  void onBadGateway() {
    onNetworkErrorDelegate.onBadGateway();
  }
}