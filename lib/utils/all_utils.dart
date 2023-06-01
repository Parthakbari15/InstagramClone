import 'package:go_router/go_router.dart';
import '../core/resources/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/view/view.dart';

///to chose image from gallery or direct click photo based on given source
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
  debugPrint('No Image Selected');
}

/// to show snack-bar based on situations
showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    content,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  )));
}

///show dialog when sign-out
Future<void> showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Sign-out Alert'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Are You Sure?'),
              Text('You Want to Sign-out?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              AuthMethods().signOut();
              context.go('/LoginScreen');
            },
          ),
        ],
      );
    },
  );
}
