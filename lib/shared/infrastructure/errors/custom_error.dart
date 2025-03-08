class CustomError implements Exception {
  final String message;
  final String code;

  CustomError(this.message, {this.code = "unknown"});

  @override
  String toString() => 'Error [$code]: $message';
}
