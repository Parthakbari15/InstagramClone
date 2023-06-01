import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;

  const TextFieldInput(
      {Key? key, required this.textEditingController, required this.textInputType, required this.hintText, required this.isPass})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          filled: true,
          contentPadding: const EdgeInsets.all(8),
        ),
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: isPass,
      ),
    );
  }
}
