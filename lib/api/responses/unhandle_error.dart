class UnHandledError {
  UnHandledError({
    required this.error,
  });

  final String error;

  factory UnHandledError.fromJson(Map<String, dynamic> json) => UnHandledError(
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
  };
}
