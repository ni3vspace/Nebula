class UIStatus<T> {
  Result status;
  String? message;

  UIStatus.success({this.message}) : status = Result.SUCCESS;

  UIStatus.loading() : status = Result.LOADING;

  UIStatus.error(this.message) : status = Result.ERROR;
}

enum Result { SUCCESS, LOADING, ERROR }