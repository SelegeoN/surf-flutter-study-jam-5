import 'package:flutter/material.dart';

class CustomTextField extends TextField {//текстовое поле
  String hint;
  CustomTextField({
    Key? key,
    TextEditingController? controller,
    TextStyle? style,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    required this.hint
  }) : super(
    key: key,
    controller: controller,
    style: style,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    decoration: InputDecoration(
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      border: OutlineInputBorder(),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white),
    ),
  );
}
