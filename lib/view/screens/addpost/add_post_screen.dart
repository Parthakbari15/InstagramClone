import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../view.dart';

// ignore: must_be_immutable
class AddPostScreen extends StatelessWidget {
  AddPostScreen({Key? key}) : super(key: key);

  TextEditingController captionController = TextEditingController();

  static final AddPostController _myController = Get.put(AddPostController());

  /// to post image
  postImage(
    String uid,
    String userName,
    String profImage,
    BuildContext context,
  ) async {
    try {
      _myController.setLoading(true);
      String res =
          await FireStoreMethods().uploadPost(captionController.text, uid, userName, _myController.postFile.value!, profImage);
      _myController.clearFile();
      if (res == "success") {
        _myController.setLoading(false);
        // ignore: use_build_context_synchronously
        showSnackbar(
          'Posted!',
          context,
        );
      } else {
        _myController.setLoading(false);
        // ignore: use_build_context_synchronously
        showSnackbar(res, context);
      }
    } catch (err) {
      showSnackbar(err.toString(), context);
    }
  }

  /// to select image from gallery
  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.camera);
                _myController.selectedPostFile(file);
              },
              child: const Text('Take Photo'),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.gallery);
                _myController.selectedPostFile(file);
              },
              child: const Text('Choose from Gallery'),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    ///if image not selected then it show's for the select image other wise post screen
    return Container(
      padding: MediaQuery.of(context).size.width > webScreenSize
          ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 4)
          : const EdgeInsets.symmetric(horizontal: 0.0),
      width: double.infinity,
      child: Obx(
        () {
          return _myController.postFile.value == null
              ? Center(
                  child: IconButton(icon: const Icon(Icons.upload), onPressed: () => _selectImage(context)),
                )
              : Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: scaffoldBackgroundColor,
                    centerTitle: false,
                    leading: IconButton(
                      onPressed: () => _myController.clearFile(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: mobileBackgroundColor,
                      ),
                    ),
                    title: Text(
                      'Post to',
                      style: TextStyles.h2Bold.copyWith(color: mobileBackgroundColor),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => postImage(
                            userProvider.getUser!.uid, userProvider.getUser!.userName, userProvider.getUser!.photoUrl, context),
                        child: const Text(
                          'Post',
                          style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _myController.isLoading.value
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 2.0, bottom: 5.0),
                                  child: LinearProgressIndicator(),
                                )
                              : const Padding(padding: EdgeInsets.only(top: 2.0, bottom: 5.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 75,
                                width: 75,
                                child: AspectRatio(
                                  aspectRatio: 478 / 451,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: MemoryImage(_myController.postFile.value!),
                                            fit: BoxFit.fill,
                                            alignment: FractionalOffset.topCenter)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width > webScreenSize
                                    ? MediaQuery.of(context).size.width * 0.35
                                    : MediaQuery.of(context).size.width * 0.65,
                                child: TextField(
                                  controller: captionController,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(color: secondaryColor),
                                    hintText: 'Enter caption here...',
                                    border: InputBorder.none,
                                  ),
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextButton(title: 'Tag People', onPressed: () {}),
                                CustomTextButton(title: 'Add location', onPressed: () {}),
                                CustomTextButton(title: 'Add music', onPressed: () {}),
                                CustomTextButton(title: 'Also post to', onPressed: () {}),
                              ],
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'Advance settings',
                              style: TextStyle(color: mobileBackgroundColor, fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.chevron_right,
                                color: mobileBackgroundColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
