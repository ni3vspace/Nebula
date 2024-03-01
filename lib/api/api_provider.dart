import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nebula/utils/strings.dart';

import '../utils/app_utils.dart';

class ApiProvider extends GetConnect {
  @override
  bool get allowAutoSignedCert => true;


  @override
  Future<void> onInit() async {
    httpClient.baseUrl = Strings.baseUrl;


    httpClient.timeout = const Duration(seconds: 60);
    httpClient.maxAuthRetries = 3;

    httpClient.addRequestModifier<void>((request) async {
      request.headers['Content-type'] = "application/json";
      //request.headers['Accept'] = "text/plain";
      // request.headers['Authorization'] = "Bearer ${await UserPref.jwtToken}";
      return request;
    });

    if (kDebugMode) {
      // log("=======>Bearer ${await UserPref.jwtToken}");
      httpClient.addResponseModifier((request, response) {
        log("${request.method} ${request.url}");
        log("Status:${response.statusCode}\n Response: ${response.body.toString()}");
        return response;
      });
    }

    // this call back is added to let the api know to refresh the token that can happen
    // if the response code is 401
  /*  httpClient.addAuthenticator<dynamic>((request) async {
      // make the call to refresh token to get the token
      final String baseUrl = await AppUtils.getUrlPath("identityUrl");
      final refreshTokenUrl = '${baseUrl}RefreshToken';
      final String oldToken = await UserPref.refreshToken;
      request.headers['Cookie'] = "refreshToken=$oldToken";
      final Response? response = await httpClient.post(refreshTokenUrl,
          body: {}, headers: request.headers);
      if (response?.isOk ?? false) {
        final content = (response?.body ?? <String, dynamic>{}) as Map;
        final newToken = content['token'];
        await UserPref.saveJwtToken(newToken);
        request.headers['Authorization'] = "Bearer ${await UserPref.jwtToken}";
        if (response != null) AppUtils.extractRefreshToken(response);
      } else {
        if (response?.statusCode != null) {
          String jwtToken = await UserPref.jwtToken;
          if (jwtToken.isNotEmpty) AppUtils.logoutUser(Strings.sessionExpired);
        }
      }
      return request;
    });*/
    super.onInit();
  }
}
