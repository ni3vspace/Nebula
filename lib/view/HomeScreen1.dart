import 'package:flutter/material.dart';

import 'Constants.dart';
import 'HomeScreen2.dart';

class HomeScreen1 extends StatelessWidget {
  const HomeScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("log=="+ (MediaQuery.of(context).size.height*0.02).toString());
    return Scaffold(
      backgroundColor: Constants.bgColor,
      body:GestureDetector(
        onTap: (){
          Navigator.push( context, MaterialPageRoute(builder: (context) => HomeScreen2()));
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/png_image/HomeScreen_1.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
