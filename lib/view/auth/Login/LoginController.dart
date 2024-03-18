import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nebula/api/repository/authanctiation_repo.dart';
import 'package:nebula/models/LoginSuccess.dart';
import 'package:nebula/utils/log_utils.dart';

import '../../../api/responses/api_response.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/preferences_helper.dart';
import '../../../utils/storage.dart';

class LoginController extends GetxController {
  AuthanticationRepo authanticationRepo;
  LoginController({required this.authanticationRepo});
  GoogleSignIn _googleSignIn = GoogleSignIn();
  // GoogleSignInAccount? userData;
  Rx<bool> isLoggedIn=RxBool(false);
  Rx<bool> isLoading=RxBool(false);
  String userMail="";
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void googleSignIn(){
    isLoading.value=true;
    _googleSignIn.signIn().then((userData) async {
      if(userData!=null){
        LogUtils.debugLog("userData==="+userData.toString());
        // _loginSuccess(userData);
       await callApi(userData);

      }else{
        isLoading.value=false;
        Fluttertoast.showToast(msg: 'Sign-in cancelled by user');
      }

    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg:error.toString(),toastLength: Toast.LENGTH_LONG);
      isLoading.value=false;
      LogUtils.error("googleSignIn stackTrace");
      LogUtils.error(error);
    }).catchError((e) {
      Fluttertoast.showToast(msg:e.toString(),toastLength: Toast.LENGTH_LONG);
      isLoading.value=false;
      LogUtils.error("googleSignIn catchError");
      LogUtils.error(e);
    });
  }
  Future<void> googleSignOut() async {
    isLoading.value=true;
   await _googleSignIn.signOut().then((userData) {
      // isLoggedIn.value=false;
      // isLoading.value=false;

      // Get.offNamed(Routes.login);

    }).onError((error, stackTrace){
      LogUtils.error("googleSignout catchError");
      LogUtils.error(stackTrace);
      LogUtils.error(error);
    }).catchError((e) {
      isLoading.value=false;
      LogUtils.error("googleSignout catchError");
      LogUtils.error(e);
    });
  }

  Future<void> callApi(GoogleSignInAccount userData) async {
    // showLoadingDialog();
    try {
      ApiResponse response=await authanticationRepo.createEmail(userData.displayName ??"",userData.email,"");

      switch (response.status) {
        case Status.SUCCESS:
          // var responseData = json.decode(response.data);
          LoginSuccess loginSuccess=LoginSuccess.fromJson(response.data);
          // Navigator.pop(Get.overlayContext!);//pop progress
          _loginSuccess(userData);

          break;
        case Status.ERROR:
          isLoading.value=false;
          // AppUtils.getToast(message: response.data.toString(), isError: true);
          LogUtils.error(response.data.toString());
          AppUtils.handleApiError(response);
          // Navigator.pop(Get.overlayContext!);
          break;
      }
    } catch (e) {
      isLoading.value=false;
      LogUtils.error(e);
      // Navigator.pop(Get.overlayContext!);
      AppUtils.getToast(message: e.toString(), isError: true);
    }
  }

  Future<void> _loginSuccess(GoogleSignInAccount userData) async {
    isLoggedIn.value=true;
    isLoading.value=false;

    userMail=userData.email ?? "";
    await PreferencesHelper.setString(
        StorageConstants.userName,userData.displayName ?? "");

    await PreferencesHelper.setString(
        StorageConstants.userEmail,userMail);

    // userData===GoogleSignInAccount:{displayName: Nitin Sanga, email: n3.sanga@gmail.com, id: 113616431374668691612, photoUrl: https://lh3.googleusercontent.com/a/ACg8ocJWybnzEafDFYMgwjPhz-O8WwE0AJWmbVj8RhOicE13og=s96-c, serverAuthCode: 4/0AeaYSHCTmi93QVxZYkmuKxpD9kWVd7AmrWHtUa5-89wZBIPRPPzTsydYTIw_6PimS7UgwA}
    Future.delayed(const Duration(seconds: 2), () async {
      Get.offNamed(Routes.disclaimer);
    });
  }
}