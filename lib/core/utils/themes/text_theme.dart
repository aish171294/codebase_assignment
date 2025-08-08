import 'package:flutter/material.dart';

class TextStyleHelper {
  static TextStyle _getTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    FontStyle fontStyle = FontStyle.normal,
    Color? color,
    TextDecoration? decoration,
    TextDecorationStyle? decorationStyle,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      decoration: decoration,
      decorationStyle: decorationStyle,
      decorationColor: decorationColor,
    );
  }

  // Headline 1: Bold, FontWeight.w700
  static TextStyle headline1(double fontSize, {Color? color}) {
    return _getTextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  // Headline 2: SemiBold, FontWeight.w600
  static TextStyle headline2(double fontSize, {Color? color}) {
    return _getTextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  // BodyLarge1: Medium, FontWeight.w500
  static TextStyle bodyLarge1(double fontSize, {Color? color}) {
    return _getTextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  // BodyLarge2: Medium, FontWeight.w500
  static TextStyle bodyLarge2(double fontSize, {Color? color}) {
    return _getTextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  // Description: Regular, FontWeight.w400
  static TextStyle description(double fontSize, {Color? color}) {
    return _getTextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }
}