import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/view/view.dart';
import '../../../core/core.dart';
import 'package:flutter/material.dart';

class PersonalChatScreen extends StatelessWidget {
  const PersonalChatScreen(
      {Key? key, required this.userName, required this.photoUrl, required this.uid, required this.chatRoomId})
      : super(key: key);
  final String userName;
  final String photoUrl;
  final String uid;
  final String chatRoomId;
  static final ChatController _chatController = Get.put(ChatController());

  ///to send messages
  sendMessaged(String sendBy) {
    _chatController.updatePchatId(const Uuid().v1());

    if (_chatController.chatController.value.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': _chatController.chatController.value.text,
        'sendBy': sendBy,
        'timeStamp': DateTime.now(),
        'pChatId': _chatController.pChatId.value,
      };
      FireStoreMethods().addConversationsMessages(chatRoomId, messageMap, _chatController.pChatId.value!);
    }

    _chatController.changeStateOfSentMsg('');
    _chatController.updateControllerValue('');
  }

  ///unSend messages
  unSendMessage(String chatId, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  debugPrint('chatRoomId:$chatRoomId , pChatId:$chatId , userName : $userName');
                  FireStoreMethods().deleteChat(chatRoomId, chatId, userName);
                  Navigator.pop(context);
                },
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'UnSend',
                      style: TextStyles.h3Normal.copyWith(color: Colors.red),
                    ),
                    const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ],
                )))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
          width: double.infinity,
          child: AppBar(
            backgroundColor: scaffoldBackgroundColor,
            centerTitle: false,
            elevation: 0,
            title: GestureDetector(
              onTap: () => context.push('/SearchedUser/$uid'),
              child: Row(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(photoUrl)),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      userName,
                      style: TextStyles.h3Bold.copyWith(color: mobileBackgroundColor),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  CupertinoIcons.left_chevron,
                  color: mobileBackgroundColor,
                )),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.call,
                    color: mobileBackgroundColor,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.videocam_rounded,
                    color: mobileBackgroundColor,
                  )),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('ChatRoom')
                      .doc(chatRoomId)
                      .collection('chats')
                      .orderBy('timeStamp', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (!_chatController.hasBuiltOnce.value) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      _chatController.changeValueOfHasBuiltOnce(true);
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('Say Hello 👋👋'),
                      );
                    }

                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _chatController.scrollToBottom()); // to scroll automatically in up direction when messages send

                    return ListView.builder(
                      controller: _chatController.scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot message = snapshot.data!.docs[index];
                        bool isSender = message['sendBy'] == userName; // Replace 'sender' with your sender identifier

                        return Align(
                          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            padding: const EdgeInsets.all(12.0),
                            constraints: const BoxConstraints(
                              maxWidth: 200.0,
                            ),
                            decoration: BoxDecoration(
                              color: isSender ? senderMsgBubbleColor : receiverMsgBubbleColor,
                              borderRadius: BorderRadius.only(
                                topLeft: isSender ? const Radius.circular(16.0) : const Radius.circular(0),
                                topRight: const Radius.circular(16.0),
                                bottomLeft: const Radius.circular(16.0),
                                bottomRight: isSender ? const Radius.circular(0) : const Radius.circular(16.0),
                              ),
                            ),
                            child: GestureDetector(
                              onLongPress: () => unSendMessage(message['pChatId'], context),
                              child: Text(
                                message['message'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
        width: double.infinity,
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4),
            child: Container(
              height: 10,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 30),
              child: Form(
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    onChanged: (value) => _chatController.changeStateOfSentMsg(value),
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.start,
                    controller: _chatController.chatController.value,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Message....',
                      contentPadding: const EdgeInsets.only(bottom: 20),
                      prefixIcon: const Icon(
                        Icons.camera_alt_outlined,
                        color: mobileBackgroundColor,
                      ),
                      suffixIcon: Obx(
                        () {
                          return _chatController.isEnableToSend.value
                              ? TextButton(
                                  onPressed: () => sendMessaged(userName),
                                  child: const Text(
                                    'Send',
                                    style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                                  ))
                              : SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.mic,
                                          color: mobileBackgroundColor,
                                        ),
                                      ),
                                      IconButton(
                                        padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                                        constraints: const BoxConstraints(),
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.photo,
                                          color: mobileBackgroundColor,
                                        ),
                                      ),
                                      IconButton(
                                        padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
                                        constraints: const BoxConstraints(),
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.emoji_emotions,
                                          color: mobileBackgroundColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: darkGray),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: darkGray),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
