// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' as google_fonts_manifest;

abstract class AppTheme {
  static AppTheme of(BuildContext context) {
    // Here, you can implement logic to choose between LightMode or DarkMode
    return LightModeTheme(); // For now, only LightModeTheme is implemented.
  }

  // Theme Colors
  late Color primaryColor;
  late Color secondaryColor;
  late Color tertiaryColor;
  late Color alternate;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color primaryText;
  late Color secondaryText;

  // Additional Colors
  late Color primaryBtnText;
  late Color lineColor;
  late Color grayIcon;
  late Color gray200;
  late Color gray600;
  late Color black600;
  late Color tertiary400;
  late Color textColor;

  // Typography definitions with font family and styles
  String get title1Family => typography.title1Family;
  TextStyle get title1 => typography.title1;
  String get title2Family => typography.title2Family;
  TextStyle get title2 => typography.title2;
  String get title3Family => typography.title3Family;
  TextStyle get title3 => typography.title3;
  String get subtitle1Family => typography.subtitle1Family;
  TextStyle get subtitle1 => typography.subtitle1;
  String get subtitle2Family => typography.subtitle2Family;
  TextStyle get subtitle2 => typography.subtitle2;
  String get bodyText1Family => typography.bodyText1Family;
  TextStyle get bodyText1 => typography.bodyText1;
  String get bodyText2Family => typography.bodyText2Family;
  TextStyle get bodyText2 => typography.bodyText2;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends AppTheme {
  // Initialize all theme colors
  ///* Color(0xFF764ABC)*/
  @override
  late Color primaryColor = Colors.blue;
  @override
  late Color secondaryColor = const Color(0xFF39D2C0);
  @override
  late Color tertiaryColor = const Color(0xFFEE8B60);
  @override
  late Color alternate = const Color(0xFFFF5963);
  @override
  late Color primaryBackground = const Color(0xFFF1F4F8);
  @override
  late Color secondaryBackground = const Color(0xFFFFFFFF);
  @override
  late Color primaryText = const Color(0xFF101213);
  @override
  late Color secondaryText = const Color(0xFF57636C);

  @override
  late Color primaryBtnText = const Color(0xFFFFFFFF);
  @override
  late Color lineColor = const Color(0xFFE0E3E7);
  @override
  late Color grayIcon = const Color(0xFF95A1AC);
  @override
  late Color gray200 = const Color(0xFFDBE2E7);
  @override
  late Color gray600 = const Color(0xFF262D34);
  @override
  late Color black600 = const Color(0xFF090F13);
  @override
  late Color tertiary400 = const Color(0xFF39D2C0);
  @override
  late Color textColor = const Color(0xFF1E2429);
}

abstract class Typography {
  // Abstract properties for fonts
  String get title1Family;
  TextStyle get title1;
  String get title2Family;
  TextStyle get title2;
  String get title3Family;
  TextStyle get title3;
  String get subtitle1Family;
  TextStyle get subtitle1;
  String get subtitle2Family;
  TextStyle get subtitle2;
  String get bodyText1Family;
  TextStyle get bodyText1;
  String get bodyText2Family;
  TextStyle get bodyText2;
  String get bodyText3Family;
  TextStyle get bodyText3;
}

class ThemeTypography extends Typography {
  final AppTheme theme;

  ThemeTypography(this.theme);

  // Font families and styles for each text type
  @override
  String get title1Family => 'Poppins';
  @override
  TextStyle get title1 => _getTextStyle('Poppins', theme.primaryText, 24);

  @override
  String get title2Family => 'Poppins';
  @override
  TextStyle get title2 => _getTextStyle('Poppins', theme.secondaryText, 22);

  @override
  String get title3Family => 'Poppins';
  @override
  TextStyle get title3 => _getTextStyle('Poppins', theme.primaryText, 20);

  @override
  String get subtitle1Family => 'Poppins';
  @override
  TextStyle get subtitle1 => _getTextStyle('Poppins', theme.primaryText, 18);

  @override
  String get subtitle2Family => 'Poppins';
  @override
  TextStyle get subtitle2 => _getTextStyle('Poppins', theme.secondaryText, 16);

  @override
  String get bodyText1Family => 'Poppins';
  @override
  TextStyle get bodyText1 =>
      _getTextStyle('Poppins', theme.primaryText, 15, FontWeight.w500);

  @override
  String get bodyText2Family => 'Poppins';
  @override
  TextStyle get bodyText2 =>
      _getTextStyle('Poppins', theme.primaryText, 12, FontWeight.w500);
  @override
  String get bodyText3Family => 'Poppins';
  @override
  TextStyle get bodyText3 =>
      _getTextStyle('Poppins', theme.secondaryText, 12, FontWeight.w500);

  // Helper method to get text style with default values
  // TextStyle _getTextStyle(String fontFamily, Color color, double fontSize) {
  //   return google_fonts_manifest.GoogleFonts.poppins(
  //     color: color,
  //     fontWeight: FontWeight.w600,
  //     fontSize: fontSize,
  //   );
  // }
  TextStyle _getTextStyle(
    String fontFamily,
    Color color,
    double fontSize, [
    FontWeight? fontWeight,
  ]) {
    return google_fonts_manifest.GoogleFonts.poppins(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w600,
    );
  }
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? height,
  }) {
    return useGoogleFonts
        ? google_fonts_manifest.GoogleFonts.poppins(
          color: color ?? this.color ?? Colors.black,
          fontSize: fontSize ?? this.fontSize ?? 14,
          fontWeight: fontWeight ?? this.fontWeight ?? FontWeight.normal,
          fontStyle: fontStyle ?? this.fontStyle,
          letterSpacing: letterSpacing ?? this.letterSpacing,
          decoration: decoration,
          height: height ?? this.height,
        )
        : copyWith(
          fontFamily: fontFamily ?? this.fontFamily,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing,
          decoration: decoration,
          height: height,
        );
  }
}
