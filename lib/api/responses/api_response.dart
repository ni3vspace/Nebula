class ApiResponse<T> {
  Status status;
  int? statusCode;
  T? data;
  Map<String, String>? headers;

  ApiResponse.success(this.statusCode, this.data, {this.headers})
      : status = Status.SUCCESS;

  ApiResponse.error(this.statusCode, this.data, {this.headers})
      : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Data : $data \n Headers: $headers";
  }
}

enum Status { SUCCESS, ERROR }