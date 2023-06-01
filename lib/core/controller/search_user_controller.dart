import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchUserController extends GetxController {
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<Stream<QuerySnapshot>?> searchResults = Rx<Stream<QuerySnapshot>?>(null);

  RxBool isShowUsers = false.obs;
  var isFollowing = false.obs;
  var isLoading = false.obs;
  var uid = ''.obs;
  var userData = {}.obs;
  var postLen = 0.obs;
  var followers = 0.obs;
  var following = 0.obs;



  @override
  void onInit() {
    super.onInit();
    searchController.value = TextEditingController();
  }

  @override
  void onClose() {
    searchController.value.dispose();
    super.onClose();
  }
  ///used to show searched user
  void setIsShowUser(bool value) {
    isShowUsers.value = value;
  }

  void setSearchResults(Stream<QuerySnapshot>? results) {
    searchResults.value = results;
  }


  ///it's used to set the loading values if some data will be loading then it's true otherwise it's false
  void setLoadingValues(bool values) {
    isLoading.value = values;
  }

  void checkWhetherIsFollowing(bool values) {
    isFollowing.value = values;
  }

  void updateUserData(dynamic values) {
    userData.value = values;
  }

  void updatePostLen(int values) {
    postLen.value = values;
  }

  void updateFollowers(int values) {
    followers.value = values;
  }

  void updateFollowing(int values) {
    following.value = values;
  }
}
