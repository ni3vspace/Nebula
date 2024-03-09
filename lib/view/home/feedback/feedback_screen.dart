import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nebula/utils/image_constants.dart';
import 'package:nebula/utils/widgets/circler_widget.dart';
import 'package:nebula/utils/widgets/rounded_buttons.dart';
import 'package:nebula/view/home/feedback/feedback_controller.dart';

import '../../../utils/color_constants.dart';
import '../../../utils/strings.dart';

class FeedbackScreen extends StatelessWidget {

  FeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return GetBuilder<FeedbackController>(
      init: FeedbackController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            // You can execute code here when the dialog is dismissed
            controller.resetStatusBarColor();
            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset : false,
            backgroundColor: ColorConstants.back_black,
            body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
              physics: AlwaysScrollableScrollPhysics(), // Ensure scrolling is always enabled
              child: Container(
                height: size.height,
                // color: ColorConstants.back_black,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("assets/png_image/blank_screen.png"),
                //     fit: BoxFit.fill,
                //   ),
                // ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top:10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.resetStatusBarColor();
                              Get.back();
                            },
                            child: CircleWithIconWidget(
                              assetName: ImageConstants.close,
                              fillColor: ColorConstants.camItemsBack,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                Strings.feedback.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        Strings.feedback_title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        scrollPadding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).viewInsets.bottom),
                        controller: controller.textEditingController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        maxLines: 19,
                        style: TextStyle(color: Colors.white,fontSize: 17),
                        cursorColor: ColorConstants.saveFeedbackButton,
                        // Set text color
                        decoration: InputDecoration(
                          // focusColor: ColorConstants.saveFeedbackButton,
                          hintText: Strings.feedback_enter,
                          hintStyle: TextStyle(color: ColorConstants.borderColorFeedback),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorConstants.borderColorFeedback,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorConstants.saveFeedbackButton,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50),
                      child: RoundedButton(
                        text: Strings.save,
                        color: ColorConstants.saveFeedbackButton,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

  }




}
