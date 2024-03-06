import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nebula/utils/color_constants.dart';
import 'package:nebula/utils/widgets/rounded_buttons.dart';

import '../image_constants.dart';
import '../strings.dart';

showLoadingDialog() {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 8),
            child: Text(
              Strings.loading,
            )),
      ],
    ),
  );
  Get.dialog(alert, barrierDismissible: false);
}

roundedDialog(Widget widget) {
  AlertDialog alert = AlertDialog(
    backgroundColor:ColorConstants.back_black,
    contentPadding: EdgeInsets.all(15),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
    content: widget,
  );
  Get.dialog(alert, barrierDismissible: false);
}

SuccessDialogScreen(String text,{bool isShowDoneButton=false,}){
  AlertDialog alert = AlertDialog(
    backgroundColor:Colors.transparent,
    contentPadding: const EdgeInsets.all(0),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 250,
          child: Stack(
            children: [
              Positioned(
                  top: 110,
                  left: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20,30,20,30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: ColorConstants.back_black,
                        width: 1.0,
                      ),
                      color: ColorConstants.back_black,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 40,),
                        Container(child: Text(text,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.white),)),
                      ],
                    ),
                  )
              ),
              Positioned(
                top: 5,
                left: 30,
                right: 30,
                child: Container(
                  // padding: EdgeInsets.fromLTRB(0,20,50,20),
                  height: 150,
                  // width:size.width ,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child:SvgPicture.asset(ImageConstants.success_event)
                  ),
                ),
              ),
            ],
          ),
        ),

        Visibility(
          visible: isShowDoneButton,
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child:RoundedButton(text: Strings.done, textColor: ColorConstants.back_black,color: ColorConstants.addReminder,onPressed: () {  },),
          ),
        ),

      ],
    ),
  );

  Future.delayed(Duration(milliseconds: 500), () {
    Get.dialog(alert, barrierDismissible: false);
  });

  Future.delayed(Duration(seconds: 2), () {
    Get.back(closeOverlays: true);
    // if(Get.isDialogOpen!=null && Get.isDialogOpen==true){
    //   Get.back(closeOverlays: true);
    // }
  });
}