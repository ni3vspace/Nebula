import 'package:flutter/material.dart';
import 'package:nebula/utils/color_constants.dart';
import 'package:nebula/view/HomeScreen1.dart';

import 'HomeScreen2.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("log=="+ (MediaQuery.of(context).size.height*0.02).toString());
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/png_image/home_screen.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: (){
                  Navigator.push( context, MaterialPageRoute(builder: (context) => HomeScreen2()));
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(bottom: 90),
                  child: Image.asset("assets/png_image/home_screen_component.png"),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.01,
            )
          ],
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
