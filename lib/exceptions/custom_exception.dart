class CustomException implements Exception {
  CustomException(this.message);

  final String message;

  @override
  String toString() {
    return this.message;
  }
}