import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:akshaya_pathara/Global/apptheme.dart';

class ExitHelper {
  static Future<bool> showExitConfirmationDialog(BuildContext context) async {
    final theme = AppTheme.of(context);

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(
                  'Exit App?',
                  style: theme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  'Are you sure you want to close the app?',
                  style: theme.bodyText2,
                  textAlign: TextAlign.center,
                ),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: [
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: theme.typography.bodyText2.override(
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    child: Text(
                      'Exit',
                      style: theme.typography.bodyText2.override(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () {
                      SystemNavigator.pop(); // Exit the app
                    },
                  ),
                ],
              ),
        ) ??
        false;
  }
}
