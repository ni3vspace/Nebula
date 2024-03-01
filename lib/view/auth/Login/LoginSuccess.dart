import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nebula/view/HomeScreen.dart';

import '../../Constants.dart';


class LoginSuccess extends StatelessWidget {
  const LoginSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.bgColor,
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/png_image/login_sucees_png.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),

      // body: Stack(
      //   children: [
      //     Positioned(
      //         top: 0,
      //         left: 0,
      //         child: Image.asset(
      //           "assets/png_image/login_sucees_png.png",
      //           fit : BoxFit.none,
      //         )),
      //   ],
      // ),
    );
  }
}
