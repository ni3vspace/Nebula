import 'dart:convert';
import 'dart:io';

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
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart';
import '../../api/responses/api_response.dart';
import '../../utils/app_utils.dart';
import '../../utils/strings.dart';
import '../../utils/widgets/common_widgets.dart';
import 'package:path/path.dart' as path;

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
            var result=await addEventToCalendar(remindersList[0]);
          }
          Navigator.pop(Get.overlayContext!);
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
        LogUtils.debugLog("data=${result.data}");
        AppUtils.getToast(message: Strings.addedCalender);
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

}