import 'package:flutter/material.dart';

class EditTextUtils {
  TextFormField getCustomEditTextArea({
    String labelValue = "",
    String hintValue = "",
    String? Function(String?)? validator,
    Widget? icon,
    bool? validation,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    String? validationErrorMsg,
  }) {
    return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: icon,
          prefixStyle: TextStyle(color: Color(0xff000000)),
          fillColor: Colors.white.withOpacity(0.6),
          filled: true,
          isDense: true,
          labelStyle: TextStyle(color: Color(0xff000000)),
          focusColor: Color(0xff000000),
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(25.0),
            ),
            borderSide: new BorderSide(
              color: Color(0xff000000),
              width: 1.0,
            ),
          ),
          disabledBorder: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(25.0),
            ),
            borderSide: new BorderSide(
              color: Color(0xff000000),
              width: 1.0,
            ),
          ),
          focusedBorder: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(25.0),
            ),
            borderSide: new BorderSide(
              color: Color(0xff000000),
              width: 1.0,
            ),
          ),
          hintText: hintValue,
          labelText: labelValue,
        ),
        validator: validator);
  }
}
