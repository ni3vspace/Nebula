import 'dart:ffi';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nebula/utils/log_utils.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/preferences_helper.dart';
import '../../../utils/storage.dart';

class LoginController extends GetxController {
  LoginController();
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
        isLoggedIn.value=true;
        isLoading.value=false;
        userData=userData;
        LogUtils.debugLog("userData==="+userData.toString());
        userMail=userData.email ?? "";
        await PreferencesHelper.setString(
            StorageConstants.userName,userData.displayName ?? "");

        await PreferencesHelper.setString(
            StorageConstants.userEmail,userMail);

        // userData===GoogleSignInAccount:{displayName: Nitin Sanga, email: n3.sanga@gmail.com, id: 113616431374668691612, photoUrl: https://lh3.googleusercontent.com/a/ACg8ocJWybnzEafDFYMgwjPhz-O8WwE0AJWmbVj8RhOicE13og=s96-c, serverAuthCode: 4/0AeaYSHCTmi93QVxZYkmuKxpD9kWVd7AmrWHtUa5-89wZBIPRPPzTsydYTIw_6PimS7UgwA}
        Future.delayed(const Duration(seconds: 2), () async {
          Get.offNamed(Routes.home);

        });

      }else{
        isLoading.value=false;
        Fluttertoast.showToast(msg: 'Sign-in cancelled by user');
      }

    }).catchError((e) {
      Fluttertoast.showToast(msg:e.toString(),toastLength: Toast.LENGTH_LONG);
      isLoading.value=false;
      LogUtils.error("googleSignIn catchError");
      LogUtils.error(e);
    });
  }
  Future<void> googleSignOut() async {
    isLoading.value=true;
    _googleSignIn.signOut().then((userData) {
      isLoggedIn.value=false;
      isLoading.value=false;

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
}