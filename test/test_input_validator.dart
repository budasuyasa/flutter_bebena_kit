import 'package:flutter_bebena_kit/libraries/input_validator_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Test Input Validator", () {
    String validate = (
      InputValidatorBuilder("5", "Number")
        ..required()
        ..number()
        ..email()
        ..exactLength(1)
    ).validate();

    expect(validate, isNotNull);
  });
}