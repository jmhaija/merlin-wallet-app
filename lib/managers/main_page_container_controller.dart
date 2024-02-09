// ignore_for_file: unnecessary_overrides

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MainPageContainerModel {}

class MainPageContainerController extends GetxController {
  GlobalKey key = GlobalKey();
  Rx<MainPageContainerModel> mainPageContainerModelObj = MainPageContainerModel().obs;

  @override
  void onInit() {
    super.onInit();
  }
  
  @override
  void onReady() {
    super.onReady();
  }
  
  @override
  void onClose() {
    super.onClose();
    mainPageContainerModelObj.close();
  }
}
