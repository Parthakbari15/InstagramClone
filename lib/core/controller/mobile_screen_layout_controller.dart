import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MobileScreenLayoutController extends GetxController {
  PageController pageController = PageController();
  var page = 0.obs;

  void navigationTapped(int value) {
    pageController.jumpToPage(value);
  }

  void onPageChanged(int values) {
    page.value = values;
  }
}
