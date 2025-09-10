import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static void show(String message, [Color? backgroundColor]) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor ?? Color(0xFF764ABC),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class SnackbarHelper {
  static void show(
    BuildContext context,
    String message, {
    Color? bgcolor,
    Duration duration = const Duration(seconds: 2),
  }) {
    final theme = AppTheme.of(context);

    final snackBar = SnackBar(
      content: Center(
        child: Text(
          message,
          style: theme.typography.bodyText2.override(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      backgroundColor: bgcolor ?? Colors.blue,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
