import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nebula/utils/image_constants.dart';
import 'package:nebula/view/auth/Login/LoginController.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/color_constants.dart';
import '../../../utils/widgets/rounded_buttons.dart';
import 'LoginSuccess.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final LoginController controller = Get.find();
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              ImageConstants.blank_screen,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned(
            top: size.height * 0.13,
            left: 0,
            child:  Container(
              width: size.width,
              alignment: Alignment.center,
              child: Image.asset(
                ImageConstants.logo_png,
                alignment: Alignment.center,
                width: size.width * 0.8,
              ),
            ),
          ),
          Positioned(
            bottom: 0, // Position at the bottom
            left: 0,
            child: YourBottomContainer(controller), // Your container at the bottom
          ),
        ],
      ),
    );
  }
}

class YourBottomContainer extends StatelessWidget {
  LoginController controller;
  YourBottomContainer(this.controller);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      width: size.width,
      // height: 100, // Adjust the height as needed
      // color: Colors.blue, // Example color
      alignment: Alignment.center,
      child: Obx(()=>controller.isLoading.value?
      CircularProgressIndicator():
      controller.isLoggedIn.value?LoginSuccess(userMail: controller.userMail,):
      Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: const Text(
              "SIGN UP WITH",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w700
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal:20,vertical: 8 ),
              child: RoundedButton(imageName:ImageConstants.google_logo,text: 'CONTINUE WITH GOOGLE', onPressed: () async {
                await controller.googleSignOut();
                controller.googleSignIn();
              },)),
          Container(
              margin: EdgeInsets.symmetric(horizontal:20,),
              child: Opacity(
                  opacity: 0.5,
                  child: RoundedButton(imageName:ImageConstants.apple_logo,text: 'CONTINUE WITH APPLE', onPressed: () {  },))),
          Container(
              margin: EdgeInsets.symmetric(horizontal:20,vertical: 8 ),
              child: Opacity(
                  opacity: 0.5,
                  child: RoundedButton(imageName:ImageConstants.facebook_logo,text: 'CONTINUE WITH FACEBOOK', onPressed: () {  },))),


        ],
      )),
    );
  }
}
