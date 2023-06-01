import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ChatController extends GetxController {
  final Rx<TextEditingController> chatController = TextEditingController().obs;
  final ScrollController scrollController = ScrollController();
  var isEnableToSend = false.obs;
  var hasBuiltOnce = false.obs;
  final Rx<String?> pChatId = Rx<String?>(null);

  /// is used to scroll up messages list
  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  ///update textEditingController value when send button press
  void updateControllerValue(String value) {
    chatController.value.text = value;
  }

  ///enable or disable send button to send message
  void changeStateOfSentMsg(String value) {
    if (value.isNotEmpty) {
      isEnableToSend.value = true;
    } else {
      isEnableToSend.value = false;
    }
  }

  ///update value of pChatId
  void updatePchatId(String chatId) {
    pChatId.value = chatId;
  }

  ///update the value of hasBuiltOnce to update chat only one time other vice it reload the screen on every word

  void changeValueOfHasBuiltOnce(bool value) {
    hasBuiltOnce.value = value;
  }
}
