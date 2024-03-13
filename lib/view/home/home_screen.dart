import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nebula/utils/global_utils.dart';
import 'package:nebula/utils/image_constants.dart';
import 'package:nebula/utils/log_utils.dart';
import 'package:nebula/utils/widgets/rounded_buttons.dart';
import 'package:nebula/view/home/add_reminder_popup_screen.dart';
import 'package:nebula/view/home/feedback/feedback_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/reminder_model.dart';
import '../../routes/app_pages.dart';
import '../../utils/color_constants.dart';
import '../../utils/strings.dart';
import '../../utils/widgets/circle_ring_icon.dart';
import '../../utils/widgets/circler_widget.dart';
import '../../utils/widgets/common_widgets.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  DateTime? currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double remainingHeight = size.height - 60; // 50 for bottom widget
    double aspectRatio = size.width / remainingHeight;


    LogUtils.debugLog("size width ${(size.width/2)}");
    LogUtils.debugLog("size height ${size.height / 1.3}");
    LogUtils.debugLog("size total ${(size.width)/(size.height / 1.3)}");
    final HomeController controller = Get.find();
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: 'Press again to exit');
          return false;
        }
        return true;
      },
      child:  Scaffold(
        body:Container(
          padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/png_image/blank_screen.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20,20,20,20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    child: Obx(() => controller.camInitialize.value == true ?
                    ClipRRect(
                        borderRadius: BorderRadius.circular(18.0),
                        child:controller.lastImageFileName.value !=null
                            ?_previewWidget(controller,size):_cameraView(controller,aspectRatio)
                    ):permissionError(controller)),
                  ),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(20,5,20,30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: ColorConstants.bottomBorder,

                  ),
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            // roundedDialog(AddReminderPopUpScreen(reminders: Reminders(),));
                            // SuccessDialogScreen();
                            Get.toNamed(Routes.event_list);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: SvgPicture.asset(ImageConstants.pinIcon),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _callOpenCamera(controller);
                            // controller.onNewCameraSelected(controller.cameras[controller.flipCamera.value]);

                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: SvgPicture.asset(ImageConstants.cameraIcon),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            // controller.addEventManual();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: SvgPicture.asset(ImageConstants.presentaionIcon),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
      ),
    );
  }

  _cameraView(HomeController controller, double aspectRatio) {
    return Stack(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(18.0),
            child: AspectRatio(aspectRatio:aspectRatio,child: CameraPreview(controller.controller))),
        Positioned(
            bottom: 50,
            right: 40,
            left: 40,
            child: GestureDetector(
              onTap: (){
                LogUtils.debugLog("captured");
                controller.captureImage();
              },
              child: CircleRingIcon(size: 60,),
            ),),
        Positioned(
            top: 20,
            right: 15,
            child: Row(
              children: [
                AnimatedOpacity(
                  opacity: controller.cameraMenuVisible.value ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500), // Adjust the duration as needed
                  curve: Curves.easeInOut,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // padding:EdgeInsets.only(top: 5),
                            child: Text("Flip",style: textStyleForMenu()),
                          ),
                          Container(
                            padding:EdgeInsets.only(top: 20),
                            child:  Text("Flash Off ",style: textStyleForMenu()),
                          ),
                          Container(
                            padding:EdgeInsets.only(top: 15),
                            child:  Text("Import Media",style: textStyleForMenu()),
                          ),

                        ],),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30,right: 7),
                      child: Text("Feedback",style: textStyleForMenu()),
                    )
                  ],
              ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: ColorConstants.camItemsBack,

                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding:EdgeInsets.only(top: 10),
                            child: GestureDetector(
                              onTap: (){
                                LogUtils.debugLog("clicked flip");
                                controller.flipCamera.value=controller.flipCamera.value==0?1:0;
                                controller.controller.setDescription(controller.cameras[controller.flipCamera.value]);
                                // controller.onNewCameraSelected(controller.cameras[controller.flipCamera.value]);
                              },
                              child: SvgPicture.asset(ImageConstants.flip),
                            ),
                          ),
                          Container(
                            padding:EdgeInsets.only(top: 10),
                            child: Obx(()=> GestureDetector(
                                onTap: (){

                                  controller.currentFlashMode.value==FlashMode.off?
                                  controller.currentFlashMode.value=FlashMode.always
                                      : controller.currentFlashMode.value=FlashMode.off;
                                  controller.controller.setFlashMode(controller.currentFlashMode.value!);
                                  LogUtils.debugLog("currentFlashMode=="+controller.currentFlashMode.value.toString());
                                  // controller.onNewCameraSelected(controller.cameras[controller.flipCamera.value]);

                                },
                                child: SvgPicture.asset(controller.currentFlashMode.value==FlashMode.always?ImageConstants.flash_on:ImageConstants.flash_off),
                              ),
                            ),
                          ),
                          Container(
                            padding:EdgeInsets.only(top: 10,bottom: 10),
                            child: GestureDetector(
                              onTap: () async {
                                XFile? image= await GlobalUtils.pickImage();
                                if(image!=null) {
                                  controller.lastImageFileName.value=File(image.path);
                                }
                              },
                              child: SvgPicture.asset(ImageConstants.import),
                            ),
                          ),

                      ],),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10,),
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: ColorConstants.camItemsBack,

                      ),
                      child: Container(
                        padding:EdgeInsets.all(5),
                        child: GestureDetector(
                          onTap: (){
                            Get.dialog(FeedbackScreen());
                          },
                          child: SvgPicture.asset(ImageConstants.feedback),
                        ),
                      ),
                    )
                  ],
                ),

              ],
            ))
      ],
    );
  }

  Widget camIcon(bool isVisible,String type){
    return Visibility(
      visible: isVisible,
      maintainState: true,
      maintainSize: true,
      maintainAnimation: true,
      // maintainSize:true,
      child: CircleWithIconWidget(assetName: type=="PRESENTSTION"?ImageConstants.presentaionIcon:ImageConstants.pinIcon,
      fillColor: type=="PRESENTSTION"?ColorConstants.presentaionDisable:ColorConstants.pinOnCamera,
        opacity: type=="PRESENTSTION"?0.5:1,
      )

    );
  }

  TextStyle textStyleForMenu(){
    return TextStyle(color: Colors.white,fontSize: 14);
  }

  _previewWidget(HomeController controller, Size size) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18.0),
          child: DottedBorder(
              strokeWidth: 2.0,
              color: Colors.grey,
              dashPattern: [8, 4],
              child: Image.file(controller.lastImageFileName.value!,)),
        ),
        Positioned(
            top: 30,
            left: 10,
            right: 10,
            child: Row(
              children: [
                GestureDetector(
                    onTap: (){
                      _callOpenCamera(controller);
                    },
                    child: CircleWithIconWidget(assetName: ImageConstants.close,fillColor: ColorConstants.camItemsBack,height: 30,width: 30,)),
                Expanded(
                  child: Text(Strings.reminder.toUpperCase(),
                    style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  )
                )
              ],
            )),

        Positioned(
            bottom: 40,
            left: 10,
            right: 10,
            child:setReminderPopUp(controller)
        )
            /*Container(
              child: RoundedButton(text: Strings.make_reminder.toUpperCase(),
                color: ColorConstants.camItemsBack1,textColor:Colors.white,
                onPressed: () {controller.callReminderApi(); },),
            ) )*/
      ],
    );
  }

  void _callOpenCamera(HomeController controller) {
    controller.lastImageFileName.value=null;
    controller.controller.setDescription(controller.cameras[controller.flipCamera.value]);
  }
  Widget setReminderPopUp(HomeController controller){

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: ColorConstants.camItemsBack1,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 10),
          child: Text(Strings.actionPopUp,style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,fontSize: 18),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

          Container(
            padding: EdgeInsets.only(top: 10),
            child:RoundedButton(text: Strings.reminder, imageName: ImageConstants.pinIcon,
              padding: EdgeInsets.all(10),
              iconHeight: 20,iconWidth: 20,
              textColor: ColorConstants.back_black,color: ColorConstants.pinOnCamera,onPressed: (){
                controller.callReminderApi();
            },),
          ),
          Opacity(
            opacity: 0.5,
            child: Container(
              padding: EdgeInsets.only(top: 1),
              child:RoundedButton(text: Strings.classroom,
                imageName: ImageConstants.presentaionIcon,
                padding: EdgeInsets.all(10),
                iconHeight: 20,iconWidth: 20,
                textColor: ColorConstants.back_black,color: ColorConstants.presentaion,onPressed: (){

              },),
            ),
          ),

        ],
      ),
    );
    
  }

  permissionError(HomeController controller) {
    if(controller.cameraException.value!=null){
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(controller.cameraException.value?.description ?? "",style: const TextStyle(fontSize: 17,color: Colors.white),),
            Container(
              margin: EdgeInsets.all(10),
              child: RoundedButton(text: "Open App Setting", 
                  padding: EdgeInsets.all(10),
                  onPressed: (){
                    openAppSettings();
              }),
            )
          ],
        ),
      );
    }
    return Container();
  }

}


