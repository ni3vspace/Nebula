class BadRequestError {
  BadRequestError({
    required this.field,
    required this.details,
  });

  final String field;
  final String details;

  factory BadRequestError.fromJson(Map<String, dynamic> json) =>
      BadRequestError(
        field: json["field"],
        details: json["details"],
      );

  Map<String, dynamic> toJson() => {
    "field": field,
    "details": details,
  };
}

class BadRequestErrorData {
  BadRequestErrorData({
    required this.errors,
  });

  final List<BadRequestError> errors;

  factory BadRequestErrorData.fromJson(Iterable<dynamic> json) =>
      BadRequestErrorData(
        errors: List<BadRequestError>.from(
            json.map((x) => BadRequestError.fromJson(x))),
      );
}
