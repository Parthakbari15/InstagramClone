import 'dart:typed_data';
import 'package:get/get.dart';

class AddPostController extends GetxController {
  var isLoading = false.obs;
  final Rx<Uint8List?> postFile = Rx<Uint8List?>(null);

  ///it's used to show progress indicator when image load
  void setLoading(bool value) {
    isLoading.value = value;
  }

  ///it's used to select image file to post
  void selectedPostFile(Uint8List newFile) {
    postFile.value = newFile;
  }

  /// it's used to clear selected file after post done and again show select option to user
  void clearFile() {
    postFile.value = null;
  }
}
