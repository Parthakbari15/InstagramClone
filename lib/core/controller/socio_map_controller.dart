import 'package:get/get.dart';

class SocioMapController extends GetxController {
  Rx<bool> isLoading = true.obs;

  ///to change the isLoading values in based on situation like data will be loaded or loading

  void setIsLoading(bool value) {
    isLoading.value = value;
  }
}
