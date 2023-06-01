import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:instagram_clone/view/view.dart';
import '../../../core/resources/auth_methods.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.uid, required this.photoUrl, required this.userName, required this.bio})
      : super(key: key);
  final String uid;
  final String photoUrl;
  final String userName;
  final String bio;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  Uint8List? imgFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _nameController.text = widget.userName;
    _bioController.text = widget.bio;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _bioController.dispose();
  }

  /// select new profile image
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      imgFile = im;
    });
  }

  /// update the user profile
  void updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    String result =
        await AuthMethods().updateUser(uid: widget.uid, userName: _nameController.text, bio: _bioController.text, file: imgFile!);

    if (result != 'Success' && imgFile == null) {
      // ignore: use_build_context_synchronously
      showSnackbar(result, context);
    } else {
      // ignore: use_build_context_synchronously
      showSnackbar('Profile Update Successfully', context);
    }
    setState(() {
      _isLoading = false;
    });
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
            centerTitle: false,
            elevation: 0,
            backgroundColor: scaffoldBackgroundColor,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: mobileBackgroundColor,
                )),
            title: const Text(
              'Edit Profile',
              style: TextStyle(color: mobileBackgroundColor),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    if (imgFile != null) {
                      updateProfile();
                    } else {
                      showSnackbar('Select New Profile Photo to Update Profile', context);
                    }
                  },
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ))
                      : const Icon(
                          Icons.check_rounded,
                          color: Colors.blueAccent,
                        )),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 40.0),
          child: Column(
            children: [
              imgFile != null
                  ? CircleAvatar(maxRadius: 35, backgroundImage: MemoryImage(imgFile!))
                  : CircleAvatar(
                      maxRadius: 35,
                      backgroundImage: NetworkImage(widget.photoUrl),
                    ),
              TextButton(
                  onPressed: () => selectImage(),
                  child: const Text(
                    'Edit picture',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                  )),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: mobileBackgroundColor, fontSize: 18),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: mobileBackgroundColor)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: mobileBackgroundColor)),
                  label: Text('UserName'),
                ),
              ),
              TextField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: mobileBackgroundColor, fontSize: 18),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: mobileBackgroundColor)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: mobileBackgroundColor)),
                  label: Text('Bio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
