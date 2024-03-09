import 'dart:convert';
import 'dart:io';

import 'package:nebula/utils/app_utils.dart';
import 'package:nebula/utils/log_utils.dart';

import '../../utils/strings.dart';
import '../api_provider.dart';
import '../responses/api_response.dart';

class AllEventsRepo {
  AllEventsRepo({required this.apiProvider});

  final ApiProvider apiProvider;

  Future<ApiResponse> getAllEvents() async {
    try {
      final res = await apiProvider.get( "${Strings.baseUrl}/Prod/event/process");
      return AppUtils.getApiResponse(res);
    } on SocketException {
      return ApiResponse.error(0, Strings.noInternetConnection);
    } catch (e) {
      LogUtils.error(e);
      return ApiResponse.error(1, "Error Occurred : ${e.toString()}");
    }
  }
}