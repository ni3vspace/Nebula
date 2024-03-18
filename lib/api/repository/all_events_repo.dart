import 'dart:convert';
import 'dart:io';

import 'package:nebula/utils/app_utils.dart';
import 'package:nebula/utils/log_utils.dart';
import 'package:nebula/utils/user_pref.dart';

import '../../utils/preferences_helper.dart';
import '../../utils/storage.dart';
import '../../utils/strings.dart';
import '../api_provider.dart';
import '../responses/api_response.dart';

class AllEventsRepo {
  AllEventsRepo({required this.apiProvider});

  final ApiProvider apiProvider;

  Future<ApiResponse> getAllEvents() async {
    try {
      String mail=await PreferencesHelper.getString(
          StorageConstants.userEmail);
      // mail="Krishna";
      final res = await apiProvider.get( "${apiProvider.baseUrl1}/Prod/event/findByUser/$mail");
      return AppUtils.getApiResponse(res);
    } on SocketException {
      return ApiResponse.error(0, Strings.noInternetConnection);
    } catch (e) {
      LogUtils.error(e);
      return ApiResponse.error(1, "Error Occurred : ${e.toString()}");
    }
  }
}