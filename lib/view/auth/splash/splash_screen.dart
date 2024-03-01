import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nebula/utils/image_constants.dart';

import '../../Constants.dart';
import '../Login/LoginPage.dart';


class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.bgColor,
      body: SizedBox(
          height: size.height,
          width: size.width,
          child: Image.asset(
            ImageConstants.splashPng,
            fit : BoxFit.cover,
          )
          // child: SvgPicture.asset(
          //   "assets/images/splash.svg",
          //   color: Colors.transparent,
          //   fit : BoxFit.fill,
          // )
      ),
    );
  }
}