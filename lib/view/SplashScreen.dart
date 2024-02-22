import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Constants.dart';
import 'LoginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.bgColor,
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/png_image/SPLASH_SCREEN.png",
                fit : BoxFit.fill,
              )
              // child: SvgPicture.asset(
              //   "assets/images/splash.svg",
              //   color: Colors.transparent,
              //   fit : BoxFit.fill,
              // )
          ),
        ],
      ),
    );
  }
}