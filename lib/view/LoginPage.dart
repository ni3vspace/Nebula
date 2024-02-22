import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nebula/view/LoginSuccess.dart';

import 'Constants.dart';

class LoginPage extends StatelessWidget {
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
              "assets/png_image/blank_screen.png",
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
                "assets/png_image/logo_png.png",
                alignment: Alignment.center,
                width: size.width * 0.8,
              ),
            ),
          ),
          Positioned(
            bottom: 0, // Position at the bottom
            left: 0,
            child: YourBottomContainer(), // Your container at the bottom
          ),
        ],
      ),
    );
  }
}

class YourBottomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      width: size.width,
      // height: 100, // Adjust the height as needed
      // color: Colors.blue, // Example color
      alignment: Alignment.center,
      child: Column(
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
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LoginSuccess()));
            },
            child: Container(
              padding: EdgeInsets.only(left: 20,right: 20),
              width: size.width,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "assets/images/all_buttons.svg",
                alignment: Alignment.center,
                // width: size.width * 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
