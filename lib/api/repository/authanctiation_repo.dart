import 'dart:io';

import 'package:nebula/utils/strings.dart';

import '../../utils/app_utils.dart';
import '../api_provider.dart';
import '../responses/api_response.dart';

class AuthanticationRepo{
  AuthanticationRepo({required this.apiProvider});

  final ApiProvider apiProvider;

  Future<ApiResponse> verifyEmail(String email) async {
    try {
      final res = await apiProvider.get(Strings.baseUrl + "/Prod/user/verifyByEmailId");
      return AppUtils.getApiResponse(res);
    } on SocketException {
      return ApiResponse.error(0, Strings.noInternetConnection);
    } catch (e) {
      return ApiResponse.error(1, "Error Occurred : ${e.toString()}");
    }
  }

  Future<ApiResponse> createEmail(String userName,String email,String pass) async {
    try {
      final res = await apiProvider.get(Strings.baseUrl + "/Prod/user/create");
      return AppUtils.getApiResponse(res);
    } on SocketException {
      return ApiResponse.error(0, Strings.noInternetConnection);
    } catch (e) {
      return ApiResponse.error(1, "Error Occurred : ${e.toString()}");
    }
  }
}