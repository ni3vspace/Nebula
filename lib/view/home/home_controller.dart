import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nebula/utils/global_utils.dart';
import 'package:nebula/utils/log_utils.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/strings.dart';

class HomeController extends GetxController{

  late List<CameraDescription> cameras;
  late CameraController controller;
  var camInitialize=false.obs;
  Rx<File?> lastImageFileName= Rx(null);
  Rx<FlashMode?> currentFlashMode= Rx(FlashMode.off);
  Rx<int> flipCamera= Rx(CamerasEnum.BACK_CAMERA.getCameraVal());

  var camError="".obs;
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      cameras = await availableCameras();
      controller = CameraController(cameras[flipCamera.value], ResolutionPreset.max,enableAudio: false);
      controller.initialize().then((_) {
        camInitialize.value=true;
        controller.setFlashMode(currentFlashMode.value!);
        // currentFlashMode.value = controller.value.flashMode;
      }).catchError((Object e) {
        if (e is CameraException) {
          LogUtils.error('camera error'+e.toString());
          camError.value=e.code;
          switch (e.code) {
            case 'CameraAccessDenied':

              LogUtils.error("CameraAccessDenied");
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

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
       enableAudio: false
    );

    // Dispose the previous controller
    camInitialize.value=false;
    await previousCameraController?.dispose();

    // Replace with the new controller
    controller = cameraController;

    // Update UI if controller updated
    cameraController.addListener(() {
      camInitialize.value=true;
      controller.setFlashMode(currentFlashMode.value!);
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
      LogUtils.error('camera error'+e.toString());
      camError.value=e.code;
      switch (e.code) {
        case 'CameraAccessDenied':

          LogUtils.error("CameraAccessDenied");
          break;
        default:
        // Handle other errors here.
          break;
      }
    }
    // Update the Boolean
    camInitialize.value = controller!.value.isInitialized;
  }


}