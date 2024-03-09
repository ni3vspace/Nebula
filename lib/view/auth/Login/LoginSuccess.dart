import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nebula/utils/color_constants.dart';
import 'package:nebula/utils/image_constants.dart';
import 'package:nebula/utils/widgets/circler_widget.dart';
import 'package:nebula/view/HomeScreen.dart';

class LoginSuccess extends StatelessWidget {
  final String userMail;
  const LoginSuccess({Key? key,required this.userMail}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size.width, // this will be your stack height
              ),
              Positioned(
               left: size.width*0.49,
                child: CircleWithIconWidget(assetName: ImageConstants.google_logo),
              ),
              Positioned(
                child: CircleWithIconWidget(
                  assetName: ImageConstants.check_mark,
                  fillColor: ColorConstants.presentaion,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30,10,10,0),
            child: const Text(
              "SIGNED UP WITH",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30,05,10,0),
            child: Text(
              userMail,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
