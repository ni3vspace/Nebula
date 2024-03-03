class ErrorResponse {
  ErrorResponse({
    required this.errors,
  });

  final List<String> errors;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
    errors: List<String>.from(json["errors"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "errors": List<dynamic>.from(errors.map((x) => x)),
  };
}
