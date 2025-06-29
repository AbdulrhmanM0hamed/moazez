import 'package:flutter/material.dart';

class CustomSnackbar {

  static void show({

    required BuildContext context,

    required String message,

    bool isError = false,

  }) {

    final snackBar = SnackBar(

      content: Text(message),

      backgroundColor: isError ? Colors.red : Colors.green,

      behavior: SnackBarBehavior.floating,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

      // Adjust the margin to position the SnackBar at the top
      // We add MediaQuery.of(context).padding.top to account for the status bar
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.0, // Add padding for status bar and some space
        left: 16.0,
        right: 16.0,
      ),
      // Setting a negative or large bottom margin can also help push it up,
      // but 'top' margin is usually sufficient for floating behavior.
      // bottom: 0.0, // You can explicitly set bottom to 0 if needed, or remove it.

    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

}