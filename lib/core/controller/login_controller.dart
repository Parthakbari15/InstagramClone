import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController{
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> passController= TextEditingController().obs;
  var isLoading = false.obs;


  ///it's used to set the loading values if some data will be loading then it's true otherwise it's false
  void setLoadingValues(bool values){
    isLoading.value=values;
  }

}