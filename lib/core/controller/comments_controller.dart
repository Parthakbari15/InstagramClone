import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CommentsController extends GetxController{

  final Rx<TextEditingController> commentEditingController = TextEditingController().obs;
  var hasBuiltOnce = false.obs;

  ///update textEditingController value when send button press

  void updateControllerValue(String value){
    commentEditingController.value.text=value;
  }

  ///update the value of hasBuiltOnce to update chat only one time other vice it reload the screen on every word

  void changeValueOfHasBuiltOnce(bool value){
    hasBuiltOnce.value=value;
  }
}