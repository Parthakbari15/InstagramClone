import 'dart:typed_data';
import 'package:get/get.dart';
import '../../view/view.dart';

class SignUpController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<Uint8List?> imgFile = Rx<Uint8List?>(null);

  ///to pick image from gallery
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery,);
    imgFile.value = im;
  }

  ///update is loading value based on situation like if data loading then set true else false
  void setValuesOfIsLoading(bool values) {
    isLoading.value = values;
  }
}
