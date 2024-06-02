import 'package:flutter/material.dart';

class CustomSnackbar {
  void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        duration: Duration(seconds: 3), // Change the duration if needed
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
