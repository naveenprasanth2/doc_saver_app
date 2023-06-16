import 'package:flutter/material.dart';

class SnackBarHelper {
  static showErrorSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(error),
    ));
  }

  static showSuccessSnackBar(BuildContext context, String success) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(success),
    ));
  }
}
