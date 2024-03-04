import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';

class ImportMediaController extends GetxController{
  Rx<bool> isLoading=Rx<bool>(true);
  RxList<Album> albums=RxList([]);
  @override
  void onInit() {
    super.onInit();
    initAsync();
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
       albums.value = await PhotoGallery.listAlbums();
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted || await Permission.storage.request().isGranted) {
        return true;
      }
    }
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted) {
        return true;
      }
    }
    return false;
  }

}