import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nebula/utils/global_utils.dart';
import 'package:nebula/utils/image_constants.dart';
import 'package:nebula/utils/log_utils.dart';

import '../../utils/color_constants.dart';
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
                Container(
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
                          ?Image.file(controller.lastImageFileName.value!):_cameraView(controller,aspectRatio)
                  ):Container()),
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

                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: SvgPicture.asset(ImageConstants.pinIcon),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            controller.lastImageFileName.value=null;
                            controller.controller.setDescription(controller.cameras[controller.flipCamera.value]);
                            // controller.onNewCameraSelected(controller.cameras[controller.flipCamera.value]);

                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: SvgPicture.asset(ImageConstants.cameraIcon),
                          ),
                        ),

                        GestureDetector(
                          onTap: (){
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
        AspectRatio(aspectRatio:aspectRatio,child: CameraPreview(controller.controller)),
        Positioned(
            bottom: 50,
            right: 40,
            left: 40,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Draggable(
                  data: 'capture',
                  childWhenDragging: camIcon(false,"PIN"),

                  dragAnchorStrategy: pointerDragAnchorStrategy,
                  feedback: camIcon(true,"PIN"),
                  child:camIcon(true,"PIN"),
                  // onDragStarted: ()=> controller.pinDragStarted.value=true,
                  // onDragEnd: (draggableDetails)=> controller.pinDragStarted.value=false,
                  onDragCompleted: () {
                    // controller.pinDragStarted.value=false;
                    LogUtils.debugLog("DragCompleted");
                  },
                ),

                DragTarget(
                    builder: (BuildContext context, List<Object?> candidateData, List<dynamic> rejectedData) {
                      return CircleRingIcon(size: 55,);
                    },
                    onWillAccept: (data) => data == 'capture',
                    onAccept: (data) {
                      LogUtils.debugLog("DragTarget onAccept");
                      controller.captureImage();
                    },
                  onLeave: (data){
                    LogUtils.debugLog("DragTarget onLeave="+data.toString());
                  },
                 ),

                camIcon(true,"PRESENTSTION"),
            ],)),
        Positioned(
            top: 20,
            right: 15,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.0),
                    color: Color(int.parse('0x55555555')),

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
                          onTap: (){},
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
                    color: Color(int.parse('0x55555555')),

                  ),
                  child: Container(
                    padding:EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: (){},
                      child: SvgPicture.asset(ImageConstants.feedback),
                    ),
                  ),
                )
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
      child: Container(
        height: 45,width: 45,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: type=="PRESENTSTION"?ColorConstants.presentaionDisable:ColorConstants.pinOnCamera,
        ),
        child: Opacity(
            opacity: type=="PRESENTSTION"?0.5:1,
            child: SvgPicture.asset(type=="PRESENTSTION"?ImageConstants.presentaionIcon:ImageConstants.pinIcon)),
      ),
    );
  }


}

class CircleRingIcon extends StatelessWidget {
  final double size;
  final Color borderColor;

  CircleRingIcon({this.size = 48.0, this.borderColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 5.0, // Adjust the width as needed
        ),
        color: Colors.transparent,
      ),
    );
  }
}
