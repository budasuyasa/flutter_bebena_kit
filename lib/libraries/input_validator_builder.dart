import 'package:flutter_bebena_kit/libraries/input_validart.dart';

/// Make validation input easier using builder
class InputValidatorBuilder {
  final String inputValue;
  final String fieldName;

  bool _isRequired    = false;
  bool _isNumber      = false;
  bool _isPhoneNumber = false;
  bool _isEmail       = false;
  bool _isStringDate  = false;

  int _minLength    = 0;
  int _exactLength  = 0;
  int _maxLength    = 0;

  String _sameAsFieldName;
  String _sameAsFieldValue;

  DateCompareValidator _compareDate;
  YearComparator _greaterThanYear;

  /// Validator builder for easier validating
  /// 
  /// [inputValue] will validated, and when there some error
  /// [fieldName] will be used as error field name
  /// 
  /// 
  /// Example:
  /// ```dart
  /// (
  ///   InputValidatorBuilder(value, "FieldName")
  ///     ..required()
  ///     ..someValidationMethod()
  /// ).validate();
  /// ```
  InputValidatorBuilder(this.inputValue, this.fieldName);

  void required([ bool isRequired = true ]) => this._isRequired = isRequired;

  void number() => this._isNumber = true;

  void nomorHandphone() => this._isPhoneNumber = true;

  void email() => this._isEmail = true;

  void stringDate() => this._isStringDate = true;

  void minLength(int length) => this._minLength = length;
  
  void exactLength(int length) => this._exactLength = length;

  void maxLength(int length) => this._maxLength = length;

  void sameAs(String value, String fieldName) {
    this._sameAsFieldValue = value;
    this._sameAsFieldName = fieldName;
  }

  void compareWithDate(String date, String fieldName) {
    this._compareDate = DateCompareValidator(dateToCompare: date, fieldNameCompared: fieldName);
  }

  void greaterThanYear(String compareTo, String fieldName, [ bool enable = true]) {
    if (enable) {
      this._greaterThanYear = YearComparator(
        compareWithYear: int.parse(compareTo),
        fieldCompareTo: fieldName
      );
    }
  }


  String validate() => InputValidator.validate(
    inputValue, 
    fieldName,

    isRequired: _isRequired,
    isEmail: _isEmail,
    isNomorHandphone: _isPhoneNumber,
    isTanggalLahir: _isStringDate,
    isNumber: _isNumber,
    maxLength: _maxLength,
    minLength: _minLength,
    exactLength: _exactLength,
    beforeDate: _compareDate,
    sameValueAs: _sameAsFieldValue,
    sameValueAsField: _sameAsFieldName,
    greaterThanYear: _greaterThanYear
  );
}

