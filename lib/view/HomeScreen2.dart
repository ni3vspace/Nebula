import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'Constants.dart';

class HomeScreen2 extends StatelessWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("log=="+ (MediaQuery.of(context).size.height*0.02).toString());
    Size size=MediaQuery
        .of(context)
        .size;
    final panelHeightClosed = size
        .height * 0.11;
    final panelHeightOpen = size
        .height * 0.75;
    return Scaffold(
      backgroundColor: Constants.bgColor,
      body: widgetSildingPanel(panelHeightClosed,size),
    );
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: panelHeightClosed,
        maxHeight: size.height,
        parallaxEnabled: true,
        parallaxOffset: .5,
        // color: const Color.fromARGB(128, 28, 28, 28),
        //   color:Color(0xFF181818).withOpacity(0.5),
        //   color:Colors.black,
          color:Color(0xFF181818),

        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/png_image/home_screen2.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        panelBuilder: (controller) {

          // return SchoolInfoWidget();
          return Container(
            height: size.height,
            // width: size.width,
            color:Color(0xFF181818).withOpacity(0.5),
            // color: const Color.fromARGB(128, 28, 28, 28),
            // color: Color(0x80181818),
            child: Stack(
              children: [
                Positioned(
                  top: -10,
                    left: 0,
                    child: Image.asset("assets/png_image/gallery.png"))
              ],
            ),

          );
        }
    ),
    );
  }


  Widget widgetSildingPanel(double panelHeightClosed, Size size){
    return SlidingUpPanel(
      minHeight: panelHeightClosed,
      maxHeight: size.height,
      parallaxEnabled: true,
      parallaxOffset: .5,
      color: Colors.black,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
      body: GestureDetector(
        onTap: (){
          // Navigator.push( context, MaterialPageRoute(builder: (context) => HomeScreen2()));
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
      panelBuilder: (controller) {
        // return SchoolInfoWidget();
        return Container(
          height: size.height,
          width: size.width,
          // color: Color.fromARGB(128, 28, 28, 28),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: EdgeInsets.fromLTRB(10,20,10,20),
                    child: Image.asset("assets/png_image/uploadmedia.png")),
              ),
            ],
          ),
        );
      },
    );
  }
}
