import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:flutter/material.dart';

List<Widget> buildTermsWidgets(
  BuildContext context,
  Map<String, List<String>> termsAndConditionsData,
) {
  final theme = AppTheme.of(context);

  List<Widget> widgets = [];

  if (termsAndConditionsData.containsKey("subtitle")) {
    for (String subtitle in termsAndConditionsData["subtitle"]!) {
      widgets.add(
        MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
            child: Text(
              subtitle,
              style: theme.typography.subtitle1.override(color: Colors.blue),
            ),
          ),
        ),
      );
    }
  }

  // ✅ Load bullet list
  if (termsAndConditionsData.containsKey("bullet")) {
    for (String element in termsAndConditionsData["bullet"]!) {
      widgets.add(
        MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "• $element",
                style: theme.typography.bodyText1.override(),
              ),
            ),
          ),
        ),
      );
    }
  }

  // ✅ Load paragraph list
  if (termsAndConditionsData.containsKey("paragraph")) {
    for (String para in termsAndConditionsData["paragraph"]!) {
      widgets.add(
        MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              para,
              style: theme.typography.bodyText1.override(),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      );
    }
  }

  return widgets;
}
