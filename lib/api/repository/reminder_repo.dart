import 'dart:convert';
import 'dart:io';

import 'package:nebula/utils/app_utils.dart';
import 'package:nebula/utils/log_utils.dart';

import '../../utils/strings.dart';
import '../api_provider.dart';
import '../responses/api_response.dart';

class ReminderRepo {
  ReminderRepo({required this.apiProvider});

  final ApiProvider apiProvider;

  // static const String baseUrl = ApiConstants.identityUrl;
  // static String baseUrl =  AppUtils.getUrlPath("identityUrl") as String;

  Future<ApiResponse> callReminderApi(String fileName,) async {
    try {
      final res = await apiProvider.post( "${Strings.baseUrl}/Prod/event/process",jsonEncode(
          {"filename": fileName, "file": fileName}));
      return AppUtils.getApiResponse(res);
    } on SocketException {
      return ApiResponse.error(0, Strings.noInternetConnection);
    } catch (e) {
      LogUtils.error(e);
      return ApiResponse.error(1, "Error Occurred : ${e.toString()}");
    }
  }
}