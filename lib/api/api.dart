import 'package:flutter_bebena_kit/api/api_configuration.dart';
import 'package:flutter_bebena_kit/api/base_api.dart';

class API extends BaseAPI implements OnNetworkError {
  API({
    ConfigurationURL configurationURL,
    ConfigurationAPI configurationAPI
  }) : super(
    configurationAPI: configurationAPI,
    configurationURL: configurationURL
  ) {
    this.onNetworkError = this;
  }

  OnNetworkError onNetworkErrorDelegate;

  @override
  void onBadGateway() {
    onNetworkErrorDelegate.onBadGateway();
  }
}