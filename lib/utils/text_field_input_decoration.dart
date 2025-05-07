import 'package:flutter/material.dart';

class TextFieldInputDecoration {
  static InputDecoration getInputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffix_,
    Widget? suffixIcon_,
    String? errorText_,
  }) {
    return InputDecoration(
        errorText: errorText_,
        prefixIcon: Icon(icon, color: Colors.grey), // Icon on the left
        hintText: hintText, // Placeholder text
        hintStyle: TextStyle(color: Colors.grey), // Light grey placeholder
        filled: true,
        fillColor: Colors.white, // Background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
          borderSide: BorderSide(color: Colors.grey, width: 1), // Grey border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1), // Light grey border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue, width: 2), // Blue border when active
        ),

        suffix: suffix_,
        suffixIcon: suffixIcon_
    );

  }
}