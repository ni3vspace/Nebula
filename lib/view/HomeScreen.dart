//home screen
/*
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
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
import '../../models/reminder_model.dart';
import '../../routes/app_pages.dart';
import '../../utils/color_constants.dart';
import '../../utils/strings.dart';
import '../../utils/widgets/circle_ring_icon.dart';
import '../../utils/widgets/circler_widget.dart';
import '../../utils/widgets/common_widgets.dart';
import 'home_controller.dart';
import 'dart:ui' as ui;

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20,20,20,20),
                  // decoration: decorationCommon(),
                  child: Obx(() => controller.camInitialize.value == true ?
                  controller.lastImageFileName.value !=null
                      ?FutureBuilder(
                    future: controller.getImageFromFile(), // Await the result of _previewWidget
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Display a loading indicator while waiting
                      }
                      return _previewWidget(controller, size,snapshot.data); // Return the result of _previewWidget
                    },
                  ):_cameraView(controller,aspectRatio):Container()),
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
    return Container(
      // color: Colors.red,
      decoration: decorationCommon(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.0),
        child: Stack(
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
                        return CircleRingIcon(size: 60,);
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
        ),
      ),
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

  _previewWidget(HomeController controller, Size size, ui.Image? image) {
    if(image==null){
      return Container();
    }

    final imageHeight = image.height!.toDouble();
    final imageWidth = image.width!.toDouble();

    // Calculate the vertical position for the top and bottom widgets based on the image size
    final topPosition = imageHeight <= size.height ? 30.0 : 10.0;
    final bottomPosition = imageHeight <= size.height ? 30.0 : 10.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          // color: Colors.red,
            decoration: decorationCommon(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: Image.file(controller.lastImageFileName.value!),
            )),
        Positioned(
            top: topPosition,
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
            bottom: bottomPosition,
            left: 80,
            right: 80,
            child:Container(
              child: RoundedButton(text: Strings.make_reminder.toUpperCase(),
                color: ColorConstants.camItemsBack1,textColor:Colors.white,
                onPressed: () {controller.callReminderApi(); },),
            ) )
      ],
    );
  }

  void _callOpenCamera(HomeController controller) {
    controller.lastImageFileName.value=null;
    controller.controller.setDescription(controller.cameras[controller.flipCamera.value]);
  }

  decorationCommon() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      border: Border.all(
        color: Colors.transparent,
        width: 2.0,
      ),
    );
  }

}
*/



//controller
/*

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:nebula/api/repository/reminder_repo.dart';
import 'package:nebula/models/reminder_model.dart';
import 'package:nebula/utils/global_utils.dart';
import 'package:nebula/utils/log_utils.dart';
import 'package:nebula/view/home/add_reminder_popup_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart';
import '../../api/responses/api_response.dart';
import '../../utils/app_utils.dart';
import '../../utils/strings.dart';
import '../../utils/widgets/common_widgets.dart';
import 'package:path/path.dart' as path;
import 'dart:typed_data'; // Import this for Uint8List
import 'dart:ui' as ui;

class HomeController extends GetxController{
  ReminderRepo reminderRepo;
  HomeController(
      {required this.reminderRepo});

  late List<CameraDescription> cameras;
  late CameraController controller;
  var camInitialize=false.obs;
  Rx<File?> lastImageFileName= Rx(null);
  Rx<FlashMode?> currentFlashMode= Rx(FlashMode.off);
  Rx<int> flipCamera= Rx(CamerasEnum.BACK_CAMERA.getCameraVal());
  Rx<bool> cameraMenuVisible= Rx(false);
  DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();
  var camError="".obs;
  String? calenderId;
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      await getCalenderIdCreate();
      cameras = await availableCameras();
      controller = CameraController(cameras[flipCamera.value], ResolutionPreset.max,enableAudio: false);
      controller.initialize().then((_) {
        camInitialize.value=true;
        cameraMenuVisible.value=true;
        controller.setFlashMode(currentFlashMode.value!);
        Future.delayed(Duration(seconds: 4),(){
          cameraMenuVisible.value=false;
        });
        // currentFlashMode.value = controller.value.flashMode;
      }).catchError((Object e) {
        LogUtils.error('error'+e.toString());
        if (e is CameraException) {
          LogUtils.error('camera error'+e.toString());
          camError.value=e.code;
          switch (e.code) {
            case 'CameraAccessDenied':
              if(e.description!=null)
                Fluttertoast.showToast(msg: e.description!);
              LogUtils.error(e.description.toString());
              break;
            default:
            // Handle other errors here.
              break;
          }
        }
      });
    });
    // controller = CameraController(_cameras[0], ResolutionPreset.max);

  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  captureImage() async {
    XFile? rawImage = await takePicture();
    File imageFile = File(rawImage!.path);

    int currentUnix = DateTime.now().millisecondsSinceEpoch;
    Directory? directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
      // ignore: avoid_slow_async_io
      if (!await directory.exists())
        directory = await getExternalStorageDirectory();
    }

    print("directory!.path=" + directory!.path.toString());
    Directory appDocDirFolder = Directory('${directory!.path}/${Strings.nebula}/');
    print("appDocDirFolder=" + appDocDirFolder.toString());
    if (!appDocDirFolder.existsSync()) {
      appDocDirFolder.createSync(recursive: true);
    }
    String fileFormat = imageFile.path.split('.').last;
    lastImageFileName.value= await imageFile.copy(
      '${appDocDirFolder!.path}/$currentUnix.$fileFormat',
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void callReminderApi() async {
    showLoadingDialog();
    try {
      String fileName="",filePath="";
      if(lastImageFileName.value!=null)
        {
          // Get the file path
          filePath = lastImageFileName.value!.path;
          // Get the file name
          fileName = path.basename(filePath);
          print('File Name: $fileName');

          print('File Path: $filePath');
        }
      ApiResponse response=await AppUtils.uploadDocument(fileName, filePath);

      switch (response.status) {
        case Status.SUCCESS:
          List<dynamic> responseData = json.decode(response.data);
          List<Reminders> remindersList = responseData.map((json) => Reminders.fromJson(json)).toList();
          LogUtils.debugLog(remindersList.first.toJson().toString());

          if(remindersList.isNotEmpty){
            roundedDialog(AddReminderPopUpScreen(reminders: remindersList[0],fromListPage:true,onPressed: () async {
             var result= await addEventToCalendar(remindersList[0]);
             if(result){
               Navigator.pop(Get.overlayContext!);
               Get.back(closeOverlays: true);
             }

            },));
            // var result=await addEventToCalendar(remindersList[0]);
          }else{
            Navigator.pop(Get.overlayContext!);
          }

          break;
        case Status.ERROR:
          // AppUtils.getToast(message: response.statusCode.toString(), isError: true);
          LogUtils.error(response.data.toString());
          AppUtils.handleApiError(response);
          Navigator.pop(Get.overlayContext!);
          break;
      }
    } catch (e) {
      LogUtils.error(e);
      Navigator.pop(Get.overlayContext!);
      AppUtils.getToast(message: e.toString(), isError: true);
    }
  }

  Future<bool> addEventToCalendar(Reminders reminder) async {
    LogUtils.debugLog("CalenderId====$calenderId");
    final Result permissionStatus = await deviceCalendarPlugin.requestPermissions();
    if(permissionStatus.hasErrors){
      AppUtils.getToast(message: permissionStatus.errors.first.errorMessage);
      return false;
    }

    // TZDateTime now = TZDateTime.now(local);
    //
    // // Add 2 minutes to the current date and time
    // TZDateTime start = now.add(const Duration(minutes: 5));
    // TZDateTime end = start.add(const Duration(minutes: 10));

    final event =  Event(calenderId,
      // eventId: reminder.id,
      title: reminder.name,
      description: reminder.description,
      // start: start,
      // end: end,
      start: _getTzdateTime(reminder.startDate),
      end: _getTzdateTime(reminder.endDate),
      url: Uri.parse(reminder.imageUrl ?? ""),
      location: reminder.location,
    );

    LogUtils.debugLog(event.toJson().toString());
    final Result<String>? result = await deviceCalendarPlugin.createOrUpdateEvent(event);

    if(result!=null){
      if(result.hasErrors){
        LogUtils.error(result.errors.first.errorMessage);
        AppUtils.getToast(message: result.errors.first.errorMessage);
      }else{
        lastImageFileName.value=null;
        LogUtils.debugLog("data=${result.data}");
        SuccessDialogScreen(Strings.addedCalender);
        // AppUtils.getToast(message: );
        return true;
      }
    }
    return false;

    // Continue with adding the event
  }

  _getTzdateTime(String? date) {
    if(date==null){
      return null;
    }

    DateTime dateTime=DateTime.parse(date);
    LogUtils.debugLog(dateTime.toString());

// Convert to TZDateTime for a specific time zone (e.g., 'Asia/Kolkata')
    TZDateTime tzDateTime = TZDateTime.from(dateTime, getLocation('Asia/Kolkata'));

// Print the time zone aware TZDateTime object
    print(tzDateTime);
    return tzDateTime;
  }

  deleteCalender() async {
    var a = await deviceCalendarPlugin.retrieveCalendars();
    if(a.isSuccess){
      a.data?.forEach((element) async {
        LogUtils.debugLog("id=${element.id} name ${element.name}");
        if(element.name=="Nebula Reminder"){
          var a1 = await deviceCalendarPlugin.deleteCalendar(element.id!);

          if(a1.isSuccess){
            LogUtils.error("a1=="+a1.data.toString());
          }
          if (a1.hasErrors){
            LogUtils.error("a1=="+a1.errors.first.errorMessage);
          }
        }
      });


    }if (a.hasErrors){
      LogUtils.error(a.errors.first.errorMessage);
    }
  }

  retrieveEvents({bool isClearAll=false}) async {
    var startDate=DateTime.now().subtract(Duration(days: 5));
    var endDate=DateTime.now().add(Duration(days: 5));
    LogUtils.debugLog("startDate=${startDate.toString()} endDate=${endDate.toString()}");
    // var a = await deviceCalendarPlugin.retrieveEvents(calenderId, RetrieveEventsParams(eventIds: ["101"]));
    var a = await deviceCalendarPlugin.retrieveEvents(calenderId, RetrieveEventsParams(startDate: startDate,endDate: endDate));
    if(a.isSuccess){
      a.data?.forEach((element) async {
        LogUtils.debugLog("id=${element.eventId} calendarId=${element.calendarId} title=${element.title} name ${element.start}");
      });
      if(isClearAll) {
        deviceCalendarPlugin.deleteCalendar(calenderId!);
      }
    }if (a.hasErrors){
      LogUtils.error("retrieveEvents=${a.errors.first.errorMessage}");
    }
  }

  getCalenderIdCreate() async {

    var a = await deviceCalendarPlugin.retrieveCalendars();
    if(a.isSuccess){
      // a.data?.forEach((element) {
      //   if(element.name == Strings.nebula){
      //     calenderId=calenderId;
      //   }
      // });

      // Calendar? cal=a.data?.firstWhere((element) => element.name == Strings.nebula);

      Calendar? cal;
      if (a.data != null && a.data!.isNotEmpty) {
        // cal = a.data!.firstWhere((element) => element.name == Strings.nebula);
        cal = a.data!.firstWhere((element) => element.name == Strings.nebula, orElse: () => Calendar(id: "-1"));
        if(cal!=null && cal.id=="-1")
          cal=null;
      }

      calenderId=cal?.id;

      if(calenderId==null){
        Result<String> calender = await deviceCalendarPlugin.createCalendar(Strings.nebula);
        if(calender.isSuccess){
          calenderId=calender.data;
        }
      }
      LogUtils.debugLog("CalenderId="+calenderId.toString());
    }
    if (a.hasErrors){
      LogUtils.error(a.errors.first.errorMessage);
    }
  }

  Future<void> addEventManual() async {
    DateTime dateTime1=DateTime.now().add(Duration(minutes: 2));
    DateTime dateTime2=dateTime1.add(Duration(minutes: 3));
    String startDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime1);
    String endDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime2);
    LogUtils.debugLog("StartDate= $startDate Enddate=$endDate");
    await addEventToCalendar(Reminders(id: "10001",name: "Manual added",startDate: startDate,endDate: endDate),);
    retrieveEvents(isClearAll:false);
  }

  Future<ui.Image> getImageFromFile() async {
    final bytes = await lastImageFileName.value?.readAsBytes();

    final image = await decodeImageFromList(bytes!);
    return image;
  }


}


 */



//


